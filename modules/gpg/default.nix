{
  pkgs,

  pinentry-fuzzel,
  user,
  ...
}:
{
  home-manager.users.${user} =
    { config, ... }:
    {
      programs.gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
        mutableKeys = false;
        mutableTrust = false;
      };

      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.callPackage ./package.nix {
          inherit pinentry-fuzzel;
          rbw = config.programs.rbw.package;
        };
      };
    };
}
