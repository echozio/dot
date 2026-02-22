{ style, user, ... }:
{
  home-manager.users.${user}.services.hyprpaper = {
    enable = true;
    settings.wallpaper = [
      {
        monitor = "";
        path = style.wallpaper;
      }
    ];
  };
}
