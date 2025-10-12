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
        pinentry.package = pkgs.writeShellScriptBin "rbw-pinentry-wrapper" ''
          if [ -n "$WAYLAND_DISPLAY" ]; then
            exec ${lib.getExe config.programs.wayprompt.package} "$@"
          else
            exec ${lib.getExe pkgs.pinentry-tty} "$@"
          fi
        '';
      };
    };
}
