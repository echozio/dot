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
      (callPackage ./mods/cyberpunk-2077.nix { })
      (callPackage ./bnet { })
    ];
  };
}
