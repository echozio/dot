{ config, ... }:
{
  config = {
    boot = {
      initrd.systemd.enable = true;

      zfs = {
        devNodes = dirOf config.disko.devices.disk.system.device;
        forceImportRoot = false;
      };

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
