{
  pkgs,
  user,
  ...
}:
{
  home-manager.users.${user}.home.packages = [
    (pkgs.callPackage ./package.nix { })
  ];
}
