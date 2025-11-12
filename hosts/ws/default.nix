{
  modulesPath,
  sec,
  pkgs,
  nixpkgs-stable,
  ...
}:
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

    useDHCP = false;
    enableIPv6 = false;

    bridges.br0.interfaces = [
      "eno1"
      "eno2"
    ];

    nameservers = [ "10.120.120.101" ];
    domain = "lan.inl1.echoz.io";
    search = [ "lan.inl1.echoz.io" ];

    defaultGateway = "10.210.120.201";

    interfaces.br0.ipv4.addresses = [
      {
        address = "10.210.100.101";
        prefixLength = 16;
      }
      {
        address = "192.168.0.5";
        prefixLength = 24;
      }
    ];
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

    printers = {
      ensurePrinters = [
        {
          name = "cs410n";
          deviceUri = "ipp://192.168.0.7";
          model = "everywhere";
          ppdOptions = {
            PageSize = "A4";
          };
        }
      ];

      ensureDefaultPrinter = "cs410n";
    };
  };
}
