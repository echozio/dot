{ pkgs, ... }:
{
  boot = {
    # kernelPackages = pkgs.linuxPackages_zen;
    # held back for zfs compat
    kernelPackages = pkgs.linuxPackages_6_18;
    zfs.package = pkgs.zfs_2_4;
  };
}
