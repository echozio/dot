{ config, ... }:
{
  config = {
    boot = {
      initrd.systemd.enable = true;

      zfs.devNodes = builtins.dirOf config.disko.devices.disk.system.device;

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
