{
  lib,
  pkgs,

  user,
  ...
}:
{
  home-manager.users.${user} =
    { config, ... }:
    {
      programs.gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
        mutableKeys = false;
        mutableTrust = false;
      };

      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.writeShellScriptBin "rbw-pinentry" ''
          fallback() {
            if [ -n "$WAYLAND_DISPLAY" ]; then
              exec ${lib.getExe config.programs.wayprompt.package} "$@"
            else
              exec ${lib.getExe pkgs.pinentry-tty} "$@"
            fi
          }

          secret=$(${lib.getExe pkgs.rbw} get gpg) || fallback "$@"

          secret=$(printf '%s' "$secret" | ${lib.getExe pkgs.gnused} 's/%/%25/g')

          echo "OK Pleased to meet you"
          while IFS=' ' read -r cmd rest; do
            case "$cmd" in
              GETPIN)
                printf 'D %s\n' "$secret"
                echo "OK"
                ;;
              GETINFO)
                [ "$rest" = "pid" ] && echo "D $$"
                echo "OK"
                ;;
              BYE)
                echo "OK closing connection"
                exit 0
                ;;
              *)
                echo "OK"
                ;;
            esac
          done
        '';
      };
    };
}
