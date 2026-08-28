{ user, ... }:
{
  environment.persistence."/fix".users.${user} = {
    directories = [ ".claude" ];
    files = [ ".claude.json" ];
  };

  home-manager.users.${user} =
    { config, pkgs, ... }:
    let
      sandboxTools = pkgs.buildEnv {
        name = "claude-sandbox-tools";
        paths = with pkgs; [
          bashInteractive
          coreutils
          curl
          diffutils
          fd
          file
          findutils
          gawk
          git
          gnugrep
          gnupatch
          gnused
          gnutar
          gzip
          jq
          less
          nix
          procps
          python3
          ripgrep
          unzip
          which
          yq-go
          xz
        ];
      };
      caBundle = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      sandboxContext = pkgs.writeText "claude-sandbox-context.md" ''
        ## Sandboxed environment

        You are running inside a bubblewrap container. Only the current project
        directory, `~/.claude`, `/tmp`, and the nix store exist; the rest of the
        filesystem is absent. Network access works and nix builds work through
        the nix daemon.

        Claude Code's internal command sandbox is disabled here — the container
        itself provides the isolation. Network access and nix work directly in
        regular commands.

        There are no SSH keys or GitHub credentials in this environment, and
        `gh` is not installed. `git push`, `git fetch` and `gh` cannot
        authenticate — do not attempt them and do not spend time diagnosing
        this. Instead, commit your work to a new branch and finish by giving
        the user a copy-pasteable command to run outside the sandbox to push
        and open a PR. Keep every line under typical terminal width (~80
        columns), using backslash continuations — wrapped lines don't copy
        correctly:

            git push -u origin <branch> && \
              gh pr create --head <branch> --title "..." --fill
      '';
      sandboxSettings = pkgs.writeText "claude-sandbox-settings.json" (
        builtins.toJSON { sandbox.enabled = false; }
      );
      claude-sandboxed = pkgs.writeShellScriptBin "claude-sandboxed" ''
        tmp=$(mktemp -d -t claude-sandbox.XXXXXXXX)
        trap 'rm -rf "$tmp"' EXIT
        ${pkgs.bubblewrap}/bin/bwrap \
          --unshare-all \
          --share-net \
          --die-with-parent \
          --proc /proc \
          --dev /dev \
          --bind "$tmp" /tmp \
          --tmpfs "$HOME" \
          --ro-bind /nix/store /nix/store \
          --ro-bind /nix/var/nix/db /nix/var/nix/db \
          --ro-bind /nix/var/nix/profiles /nix/var/nix/profiles \
          --bind /nix/var/nix/daemon-socket /nix/var/nix/daemon-socket \
          --ro-bind-try /etc/nix /etc/nix \
          --ro-bind-try /etc/static /etc/static \
          --ro-bind-try /etc/resolv.conf /etc/resolv.conf \
          --ro-bind-try /etc/hosts /etc/hosts \
          --ro-bind-try /etc/nsswitch.conf /etc/nsswitch.conf \
          --ro-bind-try /etc/passwd /etc/passwd \
          --ro-bind-try /etc/group /etc/group \
          --ro-bind-try /etc/machine-id /etc/machine-id \
          --ro-bind ${sandboxContext} /etc/claude-code/CLAUDE.md \
          --ro-bind ${pkgs.bashInteractive}/bin/bash /bin/sh \
          --ro-bind ${pkgs.coreutils}/bin/env /usr/bin/env \
          --bind "$HOME/.claude" "$HOME/.claude" \
          --ro-bind-try "$HOME/.claude/settings.json" "$HOME/.claude/settings.json" \
          --file 11 "$HOME/.claude.json" \
          --ro-bind-try "$HOME/.config/git" "$HOME/.config/git" \
          --bind "$PWD" "$PWD" \
          --chdir "$PWD" \
          --clearenv \
          --setenv HOME "$HOME" \
          --setenv USER "$USER" \
          --setenv LOGNAME "$USER" \
          --setenv SHELL ${pkgs.bashInteractive}/bin/bash \
          --setenv TERM "''${TERM:-xterm-256color}" \
          --setenv COLORTERM "''${COLORTERM:-truecolor}" \
          --setenv LANG "''${LANG:-C.UTF-8}" \
          --setenv PATH ${sandboxTools}/bin \
          --setenv TMPDIR /tmp \
          --setenv NIX_REMOTE daemon \
          --setenv SSL_CERT_FILE ${caBundle} \
          --setenv NIX_SSL_CERT_FILE ${caBundle} \
          --setenv CURL_CA_BUNDLE ${caBundle} \
          ${config.programs.claude-code.finalPackage}/bin/claude \
          --permission-mode auto \
          --settings ${sandboxSettings} \
          "$@" \
          11< "$HOME/.claude.json"
      '';
    in
    {
      nixpkgs.config.allowUnfree = true;

      home.packages = [ claude-sandboxed ];

      programs.claude-code = {
        enable = true;
        context = ''
          ## Git workflow

          Always create a feature branch for any code change — never commit directly to the default branch.

          When merging a PR: squash merge, then delete both the remote and local branch.

          Don't add a PR body unless the change genuinely warrants explanation beyond the title.

          ## Interacting with the system

          Network access and nix usage requires running commands unsandboxed.

          Avoid making assumptions about the unsandboxed environment.

          Use `nix run` or `nix shell` to run programs not typically available on every system.

          ## Shell redirection

          Be mindful of where you redirect stderr to stdout with 2>&1. If you're parsing standard
          output of a command with tools like jq or yq this will likely break parsing.
        '';
        settings = {
          permissions = {
            allow = [
              "Read(//nix/store/*)"
            ];
          };
          sandbox = {
            enabled = true;
            excludedCommands = [
              "nix *"
              "gh *"
              "git push"
              "git push *"
              "git pull"
              "git pull *"
              "git commit *"
              "git fetch"
              "git fetch *"
            ];
            filesystem = {
              denyRead = [ "/" ];
              allowRead = [
                "/nix"
                "/run/current-system"
              ];
            };
          };
          effortLevel = "medium";
          model = "fable";
        };
        mcpServers.agentgateway = {
          type = "http";
          url = "https://mcp.stafftastic.com/mcp/http";
        };
      };

      home.file."${config.programs.claude-code.configDir}/settings.json" = {
        mutable = true;
        force = true;
      };
    };
}
