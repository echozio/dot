{
  lib,
  pkgs,

  user,
  email,
  ...
}:
{
  environment.persistence."/fix".users.${user} = {
    files = [
      {
        file = ".local/share/rbw/device_id";
        parentDirectory.mode = "0700";
      }
    ];
    directories = [
      {
        directory = ".cache/rbw";
        mode = "0700";
      }
    ];
  };

  home-manager.users.${user} =
    { config, ... }:
    {
      home.sessionVariables = {
        SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/rbw/ssh-agent-socket";
      };

      programs.rbw = {
        enable = true;
        settings = {
          email = email;
          pinentry = pkgs.writeShellScriptBin "rbw-pinentry-wrapper" ''
            if [ -n "$WAYLAND_DISPLAY" ]; then
              exec ${lib.getExe config.programs.wayprompt.package} "$@"
            else
              exec ${lib.getExe pkgs.pinentry-tty} "$@"
            fi
          '';
        };
      };
    };
}
