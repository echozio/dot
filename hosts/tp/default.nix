{
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

  disko.devices.disk.system.device = "/dev/disk/by-id/nvme-nvme.144d-533637564e463154413134303934-53414d53554e47204d5a564c3435313248424c552d3030424c37-00000001";

  networking = {
    hostName = "tp";
    hostId = "4a2e8151";
    networkmanager.enable = true;
  };

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci" "thunderbolt" "nvme" "uas" "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  home-manager.users.${user} = {
    services.hypridle.brightnessDevice = "intel_backlight";
    wayland.windowManager.hyprland.settings = {
      device = [
        {
          name = "elan0676:00-04f3:3195-touchpad";
          enabled = false;
        }
      ];
    };
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
