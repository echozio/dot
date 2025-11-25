{ lib, pkgs, ... }:
{
  boot.binfmt = {
    emulatedSystems = lib.remove pkgs.stdenv.hostPlatform.system [
      "x86_64-linux"
      "aarch64-linux"
    ];
    preferStaticEmulators = true;
  };
}
