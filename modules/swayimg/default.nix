{
  lib,
  pkgs,
  user,
  ...
}:
{
  home-manager.users.${user}.programs.swayimg = {
    enable = true;
    settings = {
      "keys.viewer" = {
        MouseRight = "mode gallery";
        ScrollUp = "zoom +10";
        ScrollDown = "zoom -10";
        y = ''exec ${lib.getExe' pkgs.wl-clipboard "wl-copy"} -- "%"'';
        "Shift+y" = ''exec ${pkgs.writeShellScript "wl-copy-image" ''
          ${lib.getExe pkgs.imagemagick} - png:- | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}
        ''} < "%" '';
      };
    };
  };
}
