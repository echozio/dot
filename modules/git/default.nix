{
  lib,

  user,
  email,
  ...
}:
{
  home-manager.users.${user}.programs.git = {
    enable = true;
    userName = lib.toSentenceCase user;
    userEmail = email;
  };
}
