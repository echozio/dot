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

    extraConfig = {
      push.autoSetupRemote = true;
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };
}
