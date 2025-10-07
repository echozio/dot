{
  lib,
  config,

  user,
  ...
}:
{
  home-manager.users.${user}.xdg.userDirs =
    let
      tilde = config.home-manager.users.${user}.home.homeDirectory;
    in
    {
      enable = true;
      createDirectories = true;

      # cli friendly names
      documents = "${tilde}/doc";
      download = "${tilde}/dls";
      music = "${tilde}/mus";
      pictures = "${tilde}/pic";
      videos = "${tilde}/vid";

      # some non-standard ones that should be there
      extraConfig = {
        XDG_GIT_DIR = "${tilde}/git";
        XDG_TMP_DIR = "${tilde}/tmp";
        XDG_MNT_DIR = "${tilde}/mnt";

        # important git repos
        XDG_DOT_DIR = "${tilde}/dot";
        XDG_SEC_DIR = "${tilde}/sec";
        XDG_SRV_DIR = "${tilde}/srv";
      };

      # map useless dirs to tmp
      desktop = "${tilde}/tmp";
      publicShare = "${tilde}/tmp";
      templates = "${tilde}/tmp";
    };

  environment.persistence."/fix".users.${user}.directories =
    builtins.map
      (directory: {
        inherit directory;
        mode = "0700";
      })
      [
        "doc"
        "mus"
        "pic"
        "vid"
        "git"
        "dot"
        "sec"
        "srv"
      ];
}
