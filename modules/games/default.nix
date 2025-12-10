{
  pkgs,
  user,
  ...
}:
{
  home-manager.users.${user}.home = {
    shellAliases = {
      tt = "tt -notheme";
    };

    packages = with pkgs; [
      tt
      (callPackage ./mods/gta-iv.nix { })
    ];
  };
}
