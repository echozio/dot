{
  lib,
  config,

  user,
  ...
}:
{
  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.layerrule = [ "blur,waybar" ];

    programs.waybar = {
      enable = true;
      systemd.enable = true;

      style = builtins.readFile ./style.css;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 36;
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
            "disk"
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
            format = " {:%I:%M:%S%p}";
          };
          "clock#utc" = {
            interval = 1;
            format = " {:%I:%M:%S%p}";
            timezone = "UTC";
          };
          cpu = {
            interval = 1;
            format = " {usage}%";
          };
          memory = {
            interval = 1;
            format = " {percentage}%";
          };
          disk = {
            interval = 1;
            format = " {percentage_used}%";
            path = "/";
          };
          battery = {
            bat = "BAT0";
            interval = 1;
            states = {
              warning = 20;
              critical = 10;
            };
            format = "{icon} {capacity}%";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            tooltip-format = "{timeTo}";
          };
          tray = {
            icon-size = 18;
            spacing = 10;
          };
        };
      };
    };
  };
}
