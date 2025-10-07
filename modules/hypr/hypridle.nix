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
      options.services.hypridle = {
        brightnessDevice = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
        };
      };

      config = {
        home.packages = [ pkgs.brightnessctl ];

        wayland.windowManager.hyprland.settings.bind = [ "$mod, Delete, exec, loginctl lock-session" ];

        services.hypridle =
          let
            cfg = config.services.hypridle;
          in
          {
            enable = true;

            settings = {
              general.lock_cmd = builtins.toString (
                pkgs.writeShellScript "lock" ''
                  pidof hyprlock || hyprlock
                ''
              );

              listener = [
                {
                  timeout = 1;
                  on-resume = builtins.toString (
                    pkgs.writeShellScript "dpms-on" ''
                      hyprctl dispatch dpms on
                    ''
                  );
                }
                {
                  timeout = 30;
                  on-timeout = builtins.toString (
                    pkgs.writeShellScript "manual-lock-dpms-off" ''
                      pidof hyprlock && hyprctl dispatch dpms off
                    ''
                  );
                }
                {
                  timeout = 300;
                  on-timeout = builtins.toString (
                    pkgs.writeShellScript "auto-lock" ''
                      loginctl lock-session
                    ''
                  );
                }
                {
                  timeout = 330;
                  on-timeout = builtins.toString (
                    pkgs.writeShellScript "auto-lock-dpms-off" ''
                      hyprctl dispatch dpms off
                    ''
                  );
                }
              ]
              ++ (lib.optionals (cfg.brightnessDevice != null) [
                {
                  timeout = 1;
                  on-resume = builtins.toString (
                    pkgs.writeShellScript "undim" ''
                      brightnessctl -d ${lib.escapeShellArg cfg.brightnessDevice} -r
                    ''
                  );
                }
                {
                  timeout = 10;
                  on-timeout = builtins.toString (
                    pkgs.writeShellScript "manual-lock-dim" ''
                      save="$(brightnessctl -m | awk -F, '{if ($4 != "10%") {print "-s"; exit}}')"
                      pidof hyprlock && brightnessctl $save set 10%
                    ''
                  );
                }
                {
                  timeout = 60;
                  on-timeout = builtins.toString (
                    pkgs.writeShellScript "auto-dim" ''
                      save="$(brightnessctl -m | awk -F, '{if ($4 != "10%") {print "-s"; exit}}')"
                      brightnessctl $save set 10%
                    ''
                  );
                }
              ]);
            };
          };
      };
    };
}
