{ user, ... }:
{
  home-manager.users.${user}.programs.rclone.enable = true;
}
