{
  pkgs,

  style,
  user,
  ...
}:
{
  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.layerrule = [
      "blur on, ignore_alpha 0, match:namespace notifications"
    ];

    home.packages = [ pkgs.libnotify ];

    services.dunst = {
      enable = true;
      settings = {
        global = {
          follow = "mouse";
          alignment = "center";
          width = 500;
          height = "(36, 180)";
          origin = "top-center";
          offset = "(0, 0)";
          corner_radius = 10;
          corners = "bottom";
          padding = 12;
          horizontal_padding = 12;
          frame_width = 0;
          markup = "full";
          icon_position = "off";
          font = "${style.fonts.mono.family} 12";
          line_height = 12;
          stack_duplicates = true;
          hide_duplicate_count = true;
          transparency = 0;
          separator_height = 0;
          fullscreen = "show";
          layer = "top";
        };

        urgency_low = {
          timeout = 3;
          background = "#${style.colors.bg.hexRgba}";
          foreground = "#${style.colors.fg.hex}";
          frame_color = "#${style.colors.fg.hex}";
        };

        urgency_normal = {
          timeout = 3;
          background = "#${style.colors.bg.hexRgba}";
          foreground = "#${style.colors.fg.hex}";
          frame_color = "#${style.colors.fg.hex}";
        };

        urgency_critical = {
          timeout = 30;
          background = "#${style.colors.bg.hexRgba}";
          foreground = "#${style.colors.fg.hex}";
          frame_color = "#${style.colors.red.hex}";
        };
      };
    };
  };
}
