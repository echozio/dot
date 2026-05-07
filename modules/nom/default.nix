{ user, ... }:
{
  home-manager.users.${user}.programs.nom = {
    enable = true;
    settings = {
      database = "../../etc/.nom.db";
      ordering = "desc";
      refreshInterval = 1;
    };
  };
}
