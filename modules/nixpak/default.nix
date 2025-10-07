{
  lib,
  pkgs,
  nixpak,
  ...
}:
{
  _module.args.mkNixPak = nixpak.lib.nixpak {
    inherit lib pkgs;
  };
}
