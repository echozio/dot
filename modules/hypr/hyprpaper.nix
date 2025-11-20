{ style, user, ... }:
{
  config = {

    home-manager.users.${user}.services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ style.wallpaper ];
        wallpaper = [ ",${style.wallpaper}" ];
      };
    };
  };
}
