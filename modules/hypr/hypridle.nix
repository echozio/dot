{
  pkgs,

  user,
  ...
}:
{
  home-manager.users.${user} = {
    home.packages = [ pkgs.brightnessctl ];

    wayland.windowManager.hyprland.settings.bind = [ "$mod, Delete, exec, loginctl lock-session" ];

    services.hypridle = {
      enable = true;

      settings = {
        general.lock_cmd = builtins.toString (pkgs.writeShellScript "lock" ''
          pidof hyprlock || hyprlock
        '');

        listener = [
          {
            timeout = 1;
            on-resume = builtins.toString (pkgs.writeShellScript "dpms-on-undim" ''
              hyprctl dispatch dpms on
              brightnessctl -r
            '');
          }
          {
            timeout = 10;
            on-timeout = builtins.toString (pkgs.writeShellScript "manual-lock-dim" ''
              save="$(brightnessctl -m | awk -F, '{if ($4 != "10%") {print "-s"; exit}}')"
              pidof hyprlock && brightnessctl $save set 10%
            '');
          }
          {
            timeout = 30;
            on-timeout = builtins.toString (pkgs.writeShellScript "manual-lock-dpms-off" ''
              pidof hyprlock && hyprctl dispatch dpms off
            '');
          }
          {
            timeout = 60;
            on-timeout = builtins.toString (pkgs.writeShellScript "auto-dim" ''
              save="$(brightnessctl -m | awk -F, '{if ($4 != "10%") {print "-s"; exit}}')"
              brightnessctl $save set 10%
            '');
          }
          {
            timeout = 300;
            on-timeout = builtins.toString (pkgs.writeShellScript "auto-lock" ''
              loginctl lock-session
            '');
          }
          {
            timeout = 330;
            on-timeout = builtins.toString (pkgs.writeShellScript "auto-lock-dpms-off" ''
              hyprctl dispatch dpms off
            '');
          }
        ];
      };
    };
  };
}
