{ user, mkAgentSandbox, ... }:
{
  environment.persistence."/fix".users.${user} = {
    directories = [ ".claude" ];
    files = [ ".claude.json" ];
  };

  home-manager.users.${user} =
    { config, pkgs, ... }:
    let
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
      claude-sandboxed = mkAgentSandbox {
        package = pkgs.claude-code;
        homeDirs = [ ".claude" ];
        args = [
          ''--ro-bind-try "$HOME/.claude/settings.json" "$HOME/.claude/settings.json"''
          ''--file 11 "$HOME/.claude.json"''
          "--ro-bind ${sandboxContext} /etc/claude-code/CLAUDE.md"
        ];
        flags = [
          "--permission-mode"
          "auto"
          "--settings"
          "${sandboxSettings}"
        ];
        setup = ''exec 11< "$HOME/.claude.json"'';
        clipboardImages = true;
      };
    in
    {
      nixpkgs.config.allowUnfree = true;

      programs.claude-code = {
        enable = true;
        package = claude-sandboxed;
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
          editorMode = "vim";
          effortLevel = "medium";
          model = "opus";
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
