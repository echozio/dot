{ style, user, ... }:
{
  home-manager.users.${user}.services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = style.wallpaper;
        }
      ];
    };
  };
}
