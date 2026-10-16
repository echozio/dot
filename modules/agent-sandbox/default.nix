{ lib, pkgs, ... }:
let
  tools = pkgs.buildEnv {
    name = "agent-sandbox-tools";
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

  # Requests are a single line: `list`, or an image MIME type. Nothing else
  # reaches wl-paste, so text on the clipboard stays outside the sandbox.
  clipboardBroker = pkgs.writeShellScript "agent-clipboard-broker" ''
    read -r req
    case "$req" in
      list)
        ${pkgs.wl-clipboard}/bin/wl-paste --list-types | ${pkgs.gnugrep}/bin/grep -E '^image/'
        ;;
      image/png | image/jpeg | image/gif | image/webp | image/bmp)
        # Without an exact match wl-paste may fall back to another type.
        ${pkgs.wl-clipboard}/bin/wl-paste --list-types | ${pkgs.gnugrep}/bin/grep -qxF "$req" &&
          exec ${pkgs.wl-clipboard}/bin/wl-paste --type "$req"
        ;;
    esac
    exit 1
  '';

  clipboardShim = pkgs.writeShellScriptBin "wl-paste" ''
    case "$1" in
      -l | --list-types) req=list ;;
      -t | --type) req=$2 ;;
      --type=*) req=''${1#--type=} ;;
    esac
    case "$req" in
      list | image/*) ;;
      *)
        echo "wl-paste: only clipboard images are available in this sandbox" >&2
        exit 1
        ;;
    esac

    out=$(${pkgs.coreutils}/bin/mktemp)
    trap '${pkgs.coreutils}/bin/rm -f "$out"' EXIT
    printf '%s\n' "$req" |
      ${pkgs.socat}/bin/socat -t 30 - UNIX-CONNECT:/run/agent-clipboard/sock > "$out" || exit 1
    [ -s "$out" ] || exit 1
    ${pkgs.coreutils}/bin/cat "$out"
  '';
in
{
  # `homeDirs` are relative to $HOME. `args` are raw bwrap arguments and may
  # reference shell variables. `clipboardImages` exposes clipboard images (and
  # only images) through a `wl-paste` shim.
  _module.args.mkAgentSandbox =
    {
      package,
      homeDirs ? [ ],
      args ? [ ],
      env ? { },
      flags ? [ ],
      setup ? "",
      clipboardImages ? false,
    }:
    let
      exe = lib.getExe package;
      bwrapArgs = [
        "--unshare-all"
        "--share-net"
        "--die-with-parent"
        "--proc /proc"
        "--dev /dev"
        ''--bind "$tmp" /tmp''
        ''--tmpfs "$HOME"''
        "--ro-bind /nix/store /nix/store"
        "--ro-bind /nix/var/nix/db /nix/var/nix/db"
        "--ro-bind /nix/var/nix/profiles /nix/var/nix/profiles"
        "--bind /nix/var/nix/daemon-socket /nix/var/nix/daemon-socket"
        "--ro-bind-try /etc/nix /etc/nix"
        "--ro-bind-try /etc/static /etc/static"
        "--ro-bind-try /etc/resolv.conf /etc/resolv.conf"
        "--ro-bind-try /etc/hosts /etc/hosts"
        "--ro-bind-try /etc/nsswitch.conf /etc/nsswitch.conf"
        "--ro-bind-try /etc/passwd /etc/passwd"
        "--ro-bind-try /etc/group /etc/group"
        "--ro-bind-try /etc/machine-id /etc/machine-id"
        "--ro-bind ${pkgs.bashInteractive}/bin/bash /bin/sh"
        "--ro-bind ${pkgs.coreutils}/bin/env /usr/bin/env"
        ''--ro-bind-try "$HOME/.config/git" "$HOME/.config/git"''
      ]
      ++ map (dir: ''--bind "$HOME/${dir}" "$HOME/${dir}"'') homeDirs
      ++ lib.optional clipboardImages ''--bind "$clipboard" /run/agent-clipboard''
      ++ args
      ++ [
        ''--bind "$PWD" "$PWD"''
        ''--chdir "$PWD"''
        "--clearenv"
        ''--setenv HOME "$HOME"''
        ''--setenv USER "$USER"''
        ''--setenv LOGNAME "$USER"''
        "--setenv SHELL ${pkgs.bashInteractive}/bin/bash"
        ''--setenv TERM "''${TERM:-xterm-256color}"''
        ''--setenv COLORTERM "''${COLORTERM:-truecolor}"''
        ''--setenv LANG "''${LANG:-C.UTF-8}"''
        "--setenv PATH ${lib.optionalString clipboardImages "${clipboardShim}/bin:"}${tools}/bin"
        "--setenv TMPDIR /tmp"
        "--setenv NIX_REMOTE daemon"
        "--setenv SSL_CERT_FILE ${caBundle}"
        "--setenv NIX_SSL_CERT_FILE ${caBundle}"
        "--setenv CURL_CA_BUNDLE ${caBundle}"
      ]
      ++ lib.mapAttrsToList (name: value: "--setenv ${name} ${lib.escapeShellArg value}") env;
    in
    pkgs.writeTextFile {
      inherit (package) name;
      destination = "/bin/${package.meta.mainProgram}";
      executable = true;
      meta.mainProgram = package.meta.mainProgram;
      text = ''
        #!${pkgs.runtimeShell}
        sandbox=1
        args=()
        for arg in "$@"; do
          if [ "$arg" = --no-sandbox ]; then
            sandbox=
          else
            args+=("$arg")
          fi
        done

        if [ -z "$sandbox" ]; then
          exec ${exe} "''${args[@]}"
        fi

        tmp=$(mktemp -d -t ${package.meta.mainProgram}-sandbox.XXXXXXXX)
        trap 'rm -rf "$tmp"' EXIT
        ${lib.optionalString clipboardImages ''
          clipboard=$(mktemp -d -t ${package.meta.mainProgram}-clipboard.XXXXXXXX)
          if [ -n "''${WAYLAND_DISPLAY:-}" ]; then
            ${pkgs.socat}/bin/socat UNIX-LISTEN:"$clipboard/sock",fork EXEC:${clipboardBroker} 2>/dev/null &
            broker=$!
            for _ in $(seq 20); do
              [ -S "$clipboard/sock" ] && break
              sleep 0.05
            done
          fi
          trap 'kill ''${broker:-} 2>/dev/null; rm -rf "$tmp" "$clipboard"' EXIT
        ''}
        ${lib.optionalString (homeDirs != [ ]) ''
          mkdir -p ${lib.concatMapStringsSep " " (dir: ''"$HOME/${dir}"'') homeDirs}
        ''}
        ${setup}
        ${pkgs.bubblewrap}/bin/bwrap \
          ${lib.concatStringsSep " \\\n  " bwrapArgs} \
          ${exe} ${lib.escapeShellArgs flags} "''${args[@]}"
      '';
    };
}
