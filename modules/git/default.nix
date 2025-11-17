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
      merge.tool = "nvimdiff";
      mergetool = {
        prompt = false;
        keepBackup = false;
        nvimdiff.layout = "LOCAL,BASE,REMOTE / MERGED";
      };
    };
  };
}
