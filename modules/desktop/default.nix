{ user, ... }:
{
  home-manager.users.${user}.xdg.desktopEntries = {
    uuctl = {
      name = "";
      noDisplay = true;
    };
  };
}
