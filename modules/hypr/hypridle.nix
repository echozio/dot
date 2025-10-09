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
              general = {
                lock_cmd = builtins.toString (
                  pkgs.writeShellScript "lock" ''
                    pidof hyprlock || hyprlock
                  ''
                );
                before_sleep_cmd = "loginctl lock-session";
                after_sleep_cmd = "hyprctl dispatch dpms on";
              };

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
              ++ (lib.optionals (cfg.brightnessDevice != null) (
                let
                  dev = lib.escapeShellArg cfg.brightnessDevice;
                in
                [
                  {
                    timeout = 1;
                    on-resume = builtins.toString (
                      pkgs.writeShellScript "undim" ''
                        brightnessctl -d ${dev} -r
                      ''
                    );
                  }
                  {
                    timeout = 10;
                    on-timeout = builtins.toString (
                      pkgs.writeShellScript "manual-lock-dim" ''
                        save="$(brightnessctl -d ${dev} -m | awk -F, '{if ($4 != "10%") {print "-s"; exit}}')"
                        pidof hyprlock && brightnessctl -d ${dev} $save set 10%
                      ''
                    );
                  }
                  {
                    timeout = 60;
                    on-timeout = builtins.toString (
                      pkgs.writeShellScript "auto-dim" ''
                        save="$(brightnessctl -d ${dev} -m | awk -F, '{if ($4 != "10%") {print "-s"; exit}}')"
                        brightnessctl -d ${dev} $save set 10%
                      ''
                    );
                  }
                ]
              ));
            };
          };
      };
    };
}
