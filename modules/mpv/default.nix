{
  pkgs,

  user,
  ...
}:
{
  home-manager.users.${user}.programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      uosc
      thumbfast
    ];
  };
}
