{ user, ... }:
{
  home-manager.users.${user}.programs.swayimg = {
    enable = true;
    settings = {
      "keys.viewer" = {
        MouseRight = "mode gallery";
        ScrollUp = "zoom +10";
        ScrollDown = "zoom -10";
      };
    };
  };
}
