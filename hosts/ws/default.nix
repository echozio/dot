{
  modulesPath,
  sec,
  user,
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
    useNetworkd = true;

    nameservers = [ "10.2.0.1" ];
    domain = "lan.echoz.io";
    search = [ "lan.echoz.io" ];
  };

  systemd.network = {
    links = {
      # tw as in cisco's TwoGigabitEthernet, the 2.5G port
      "10-tw0" = {
        matchConfig.PermanentMACAddress = "cc:28:aa:54:4c:bd";
        linkConfig.Name = "tw0";
      };

      "10-xe0" = {
        matchConfig.PermanentMACAddress = "cc:28:aa:54:4c:be";
        linkConfig.Name = "xe0";
      };
    };

    netdevs."20-br0".netdevConfig = {
      Kind = "bridge";
      Name = "br0";
    };

    networks = {
      "30-br0-ports" = {
        matchConfig.Name = "tw0 xe0";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };

      "40-br0" = {
        matchConfig.Name = "br0";
        address = [
          "10.2.0.5/24"
          "fd02::5/64"
        ];
        gateway = [ "10.2.0.1" ];
      };
    };
  };

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "thunderbolt"
      "usbhid"
    ];
    kernelModules = [ "kvm-amd" ];
  };

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;
    amdgpu.initrd.enable = true;

    printers = {
      ensurePrinters = [
        {
          name = "cs410n";
          deviceUri = "ipp://lp.lan.echoz.io";
          model = "everywhere";
          ppdOptions = {
            PageSize = "A4";
          };
        }
      ];

      ensureDefaultPrinter = "cs410n";
    };
  };

  home-manager.users.${user}.programs.waybar.settings.mainBar.battery.bat = "hidpp_battery_0";
}
