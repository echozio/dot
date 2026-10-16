{
  lib,
  pkgs,

  user,
  email,
  ...
}:
let
  riff = lib.getExe pkgs.riffdiff;
in
{
  home-manager.users.${user}.programs.git = {
    enable = true;

    ignores = [ ".claude/worktrees/" ];

    settings = {
      user.name = lib.toSentenceCase user;
      user.email = email;
      push.autoSetupRemote = true;
      pull.rebase = true;
      init.defaultBranch = "main";
      pager = {
        diff = riff;
        show = riff;
        log = riff;
      };
      interactive.diffFilter = "${riff} --color=on";
      merge.tool = "nvimdiff";
      mergetool = {
        prompt = false;
        keepBackup = false;
        nvimdiff.layout = "LOCAL,BASE,REMOTE / MERGED";
      };
    };
  };
}
