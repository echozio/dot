{
  lib,
  config,
  pkgs,

  style,
  user,

  home-manager,
  ...
}:
{
  config = {
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = "Hyprland --config ${
          pkgs.writeText "greetd-hyprland.conf" (
            home-manager.lib.hm.generators.toHyprconf {
              attrs = {
                inherit (config.home-manager.users.${user}.wayland.windowManager.hyprland.settings)
                  input
                  general
                  misc
                  decoration
                  animations
                  ;
                windowrule = "float, class:gtkgreet";
                exec-once = [
                  "${lib.getExe pkgs.gtkgreet} -s ${pkgs.writeText "greetd-style.css" ''
                    window, button, entry {
                      background: ${style.colors.bg.rgba};
                      border: none;
                      box-shadow: none;
                      text-shadow: none;
                    }
                    label, window, button, entry {
                      color: #${style.colors.fg.hex};
                    }
                    #command-selector arrow {
                      opacity: 0;
                    }
                  ''} -c 'uwsm start hyprland-uwsm.desktop'; hyprctl dispatch exit"
                  "${lib.getExe pkgs.hyprpaper} -c ${
                    pkgs.writeText "greetd-hyprpaper.conf" (
                      home-manager.lib.hm.generators.toHyprconf {
                        attrs = config.home-manager.users.${user}.services.hyprpaper.settings;
                      }
                    )
                  }"
                ];
              };
            }
          )
        }";
      };
    };
  };
}
