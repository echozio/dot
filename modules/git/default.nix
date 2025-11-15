{
  lib,

  user,
  email,
  ...
}:
{
  home-manager.users.${user}.programs.git = {
    enable = true;

    settings = {
      user.name = lib.toSentenceCase user;
      user.email = email;
      push.autoSetupRemote = true;
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };
}
