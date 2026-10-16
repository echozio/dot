{
  pkgs,
  user,
  tuicr,
  ...
}:
{
  home-manager.users.${user}.home.packages = [
    tuicr.packages.${pkgs.stdenv.system}.default
  ];
}
