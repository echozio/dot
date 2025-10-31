{
  pkgs,

  user,
  ...
}:
{
  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.layerrule = [
      "blur,notifications"
      "ignorezero,notifications"
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
          font = "JetBrains Mono Nerd Font Propo 12";
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
          background = "#00000033";
          foreground = "#eeeeee";
          frame_color = "#eeeeee";
        };

        urgency_normal = {
          timeout = 3;
          background = "#00000033";
          foreground = "#eeeeee";
          frame_color = "#eeeeee";
        };

        urgency_critical = {
          timeout = 30;
          background = "#00000033";
          foreground = "#eeeeee";
          frame_color = "#eeee00";
        };
      };
    };
  };
}
