{
  lib,
  pkgs,

  style,
  user,
  ...
}:
{
  fonts = {
    fontconfig = {
      subpixel = {
        rgba = lib.mkDefault "rgb";
        lcdfilter = "default";
      };

      hinting.style = "slight";

      defaultFonts = {
        monospace = [ style.fonts.mono.family ];
        sansSerif = [ style.fonts.sansSerif.family ];
        serif = [ style.fonts.serif.family ];
        emoji = [ style.fonts.emoji.family ];
      };
    };

    packages = [
      style.fonts.mono.package
      style.fonts.sansSerif.package
      style.fonts.serif.package
      style.fonts.emoji.package
      pkgs.corefonts
    ];
  };

  home-manager.users.${user}.dconf.settings = {
    "org/gnome/desktop/interface".font-antialiasing = "rgba";
  };
}
