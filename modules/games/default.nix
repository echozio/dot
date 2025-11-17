{
  pkgs,
  user,
  ...
}:
{
  home-manager.users.${user}.home.packages = [
    (pkgs.callPackage ./mods/gta-iv.nix { })
  ];
}
