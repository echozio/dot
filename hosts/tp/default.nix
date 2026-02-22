{
  pkgs,
  modulesPath,

  sec,
  user,
  ...
}:
{
  imports = [
    sec.nixosModules.dot

    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  disko.devices.disk.system.device =
    "/dev/disk/by-id/nvme-nvme.144d-533637564e463154413134303934-53414d53554e47204d5a564c3435313248424c552d3030424c37-00000001";

  networking = {
    hostName = "tp";
    hostId = "4a2e8151";
    networkmanager.enable = true;
    modemmanager = {
      enable = true;
      fccUnlockScripts = [
        {
          id = "2c7c:030a";
          path = "${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/2c7c:030a";
        }
      ];
    };
  };

  systemd.services.ModemManager = {
    enable = true;
    wantedBy = [
      "multi-user.target"
      "network.target"
    ];
  };

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "uas"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;

    bluetooth.enable = true;
  };

  home-manager.users.${user} = {
    services.hypridle.brightnessDevice = "intel_backlight";
  };

  powerManagement.powertop.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
}
