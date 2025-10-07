{
  lib,
  config,

  user,
  ...
}:
{
  config = {

    home-manager.users.${user}.services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ "${./wallpaper.jpg}" ];
        wallpaper = [ ",${./wallpaper.jpg}" ];
      };
    };
  };
}
