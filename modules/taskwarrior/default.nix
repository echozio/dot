{ user, pkgs, ... }:
{
  home-manager.users.${user} =
  { config, ... }:
  {
    programs.taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
      dataLocation = "${config.home.homeDirectory}/etc/task";
      config = {
        "news.version" = pkgs.taskwarrior3.version;
      };
    };
  };
}
