{
  pkgs,

  user,
  ...
}:
{
  home-manager.users.${user}.programs.mpv = {
    enable = true;

    config = {
      keep-open = true;
    };

    scripts = with pkgs.mpvScripts; [
      uosc
      thumbfast
    ];
  };
}
