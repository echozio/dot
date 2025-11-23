{ pkgs, nixpkgs-stable, ... }:
{
  boot.kernelPackages =
    nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_lqx;
}
