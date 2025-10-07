{ modulesPath, sec, ... }:
{
  imports = [
    sec.nixosModules.dot

    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  disko.devices.disk.system.device = "/dev/disk/by-id/wwn-0x5002538e410ec0c1";

  networking = {
    hostName = "rc";
    hostId = "9cb48259";
  };

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "sd_mod"
      "sdhci_pci"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
  };
}
