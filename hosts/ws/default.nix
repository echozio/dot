{ modulesPath, sec, pkgs, nixpkgs-stable, ... }:
{
  imports = [
    sec.nixosModules.dot
    ./pipewire.nix

    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  disko.devices.disk.system.device = "/dev/disk/by-id/nvme-eui.00000000000000000026b7282f657265";

  networking = {
    hostName = "ws";
    hostId = "e27df163";
  };

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "thunderbolt"
      "usbhid"
    ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = nixpkgs-stable.legacyPackages.${pkgs.system}.linuxPackages_lqx;
  };

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;
    amdgpu.initrd.enable = true;
  };
}
