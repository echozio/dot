{
  lib,
  config,
  pkgs,

  style,
  user,
  ...
}:
let
  hmUserCfg = config.home-manager.users.${user};
in
{
  config = {
    users.users.greeter = {
      createHome = true;
      home = "/var/greeter";
    };

    home-manager.users.greeter = {
      home = {
        stateVersion = config.system.stateVersion;
        pointerCursor = hmUserCfg.home.pointerCursor;
      };

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        settings = {
          inherit (hmUserCfg.wayland.windowManager.hyprland.settings)
            monitor
            input
            general
            misc
            ecosystem
            decoration
            animations
            ;
          windowrule = "float on, match:class ^gtkgreet$";
          layerrule = "blur on, match:namespace waybar";
          exec-once = "${lib.getExe pkgs.gtkgreet} -s ${pkgs.writeText "gtkgreet-style.css" ''
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
            #clock {
              margin-bottom: -48px;
              opacity: 0;
            }
          ''} -c 'uwsm start hyprland-uwsm.desktop'; hyprctl dispatch exit";
        };
      };

      services.hyprpaper = {
        enable = true;
        settings = hmUserCfg.services.hyprpaper.settings;
      };

      programs.waybar = {
        enable = true;
        systemd.enable = true;

        inherit (hmUserCfg.programs.waybar) style;

        settings = {
          mainBar = {
            inherit (hmUserCfg.programs.waybar.settings.mainBar)
              layer
              position
              height
              "clock#date"
              "clock"
              "clock#utc"
              battery
              cpu
              memory
              disk
              ;
            modules-center = [
              "clock#date"
              "clock"
              "clock#utc"
            ];
            modules-right = [
              "battery"
              "cpu"
              "memory"
              "disk"
            ];
          };
        };
      };
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session.command = "uwsm start hyprland-uwsm.desktop";
      };
    };
  };
}
