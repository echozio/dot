{
  lib,
  config,
  pkgs,

  user,
  ...
}:
{
  config.home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.bind = [ "$mod, Return, exec, uwsm app -- kitty" ];

    programs.kitty = {
      enable = true;
      font = {
        name = "JetBrains Mono Nerd Font Mono";
        size = 12;
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      settings = {
        background = "#000000";
        background_opacity = 0.2;
        window_padding_width = 10;
        disable_ligatures = false;
        confirm_os_window_close = 0;
      };
    };
  };
}
