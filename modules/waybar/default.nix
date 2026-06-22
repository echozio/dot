{ style, user, lib, ... }:
{
  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.layerrule = [
      "blur on, ignore_alpha 0.19, match:namespace waybar"
    ];

    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          margin-left = 10;
          margin-right = 10;
          margin-top = 10;
          height = 44;
          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = [
            "clock#date"
            "clock"
            "clock#utc"
          ];
          modules-right = [
            "battery"
            "cpu"
            "memory"
            "custom/disk"
            "tray"
          ];
          "hyprland/workspaces" = {
            format = "{name}";
            on-click = "activate";
            sort-by = "number";
          };
          "clock#date" = {
            interval = 1;
            format = "󰃭 {:%a, %b %d}";
          };
          clock = {
            interval = 1;
            format = "󰅐 {:%I:%M:%S %p}";
          };
          "clock#utc" = {
            interval = 1;
            format = "󰖟 {:%I:%M:%S %p}";
            timezone = "UTC";
          };
          cpu = {
            interval = 1;
            format = " {usage}% {max_frequency:.1f} GHz, ";
          };
          memory = {
            interval = 1;
            format = "{used:.1f}/{total:.1f} GiB";
          };
          "custom/disk" = {
            interval = 1;
            format = "󰉉 {}%";
            exec = "zpool get -Hpovalue capacity system";
          };
          battery = {
            bat = lib.mkDefault "BAT0";
            interval = 1;
            states = {
              warning = 20;
              critical = 10;
            };
            format = "{icon} {capacity}%";
            format-icons = {
              default = [
                " "
                " "
                " "
                " "
                " "
              ];
              charging = [
                " "
                " "
                " "
                " "
                " "
              ];
            };
            tooltip-format = "{timeTo}";
          };
          tray = {
            icon-size = 18;
            spacing = 10;
          };
        };
      };

      style = ''
        * {
          border: none;
          font-family: ${style.fonts.mono.family};
          font-size: 12pt;
        }

        box.module {
          margin: 10px;
        }

        window#waybar {
          border: none;
          border-radius: 10px;
          color: #${style.colors.fg.hex};
          background: ${style.colors.bg.rgba};
        }

        .modules-right > widget > *, #window {
          padding: 0 10px;
        }

        .modules-center > widget > * {
          padding: 0 10px;
        }

        #tray {
          padding: 0;
          padding-right: 10px;
        }

        #workspaces box {
          min-height: 5px;
        }

        #workspaces button, #workspaces button:hover, #workspaces button.active, #workspaces button.empty {
          box-shadow: inherit;
          text-shadow: inherit;
          background: transparent;
          padding: 0 5px;
        }

        #workspaces button label {
          color: #${style.colors.fg.hex};
          transition: background 0.1s linear;
          border-radius: 50%;
          min-height: 24px;
          min-width: 24px;
          border-radius: 50%;
        }

        #workspaces button:hover label {
          background: #${style.colors.fg.hex};
          color: #${style.colors.bg.hex};
        }

        #workspaces button.active label {
          background: #${style.colors.fg.hex};
          color: #${style.colors.bg.hex};
        }

        #workspaces button.empty label {
          color: #${style.colors.lo.hex};
        }

        #cpu {
          padding-right: 0;
        }

        #memory {
          padding-left: 0;
        }
      '';
    };
  };
}
