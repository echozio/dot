{
  pkgs,

  user,
  ...
}:
{
  programs.dconf.enable = true;
  home-manager.users.${user} = {
    dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

    gtk = {
      enable = true;

      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;

      theme = {
        name = "Adwaita:Dark";
        package = pkgs.gnome-themes-extra;
      };
    };

    qt = {
      enable = true;

      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };
  };
}
