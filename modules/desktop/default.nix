{ user, ... }:
{
  home-manager.users.${user}.xdg.desktopEntries = {
    aerc = {
      name = "";
      noDisplay = true;
    };
    uuctl = {
      name = "";
      noDisplay = true;
    };
  };
}
