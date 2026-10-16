{ user, ... }:
{
  home-manager.users.${user} = {
    xdg.desktopEntries.nom = {
      name = "nom";
      exec = "kitty --class nom nom";
      icon = ./icon.svg;
    };

    wayland.windowManager.hyprland.settings.window_rule = [
      {
        match.class = "^nom$";
        workspace = "1 silent";
      }
    ];

    programs.nom = {
      enable = true;
      settings = {
        database = "../../etc/.nom.db";
        ordering = "desc";
        refreshInterval = 1;
      };
    };
  };
}
