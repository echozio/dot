{
  pkgs,
  config,
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

    networkmanager = {
      enable = true;
      ensureProfiles = {
        profiles = {
          "vpn.echoz.io" = {
            connection = {
              id = "vpn.echoz.io";
              type = "wireguard";
              autoconnect = true;
              interface-name = "wg0";
            };

            "wireguard-peer.kKa4US8qJoU0KSIsZzQNlSYGZhbuy2Yl1HVZDiGbs1U=" = {
              endpoint = "81.167.91.47:51820";
              presistent-keepalive = 25;
              allowed-ips = "0.0.0.0/0";
            };

            ipv4 = {
              method = "manual";
              address1 = "10.5.0.2/24";
              dns = "10.5.0.1";
              dns-search = "lan.echoz.io";
            };

            ipv6.method = "disabled";
          };

          wwan = {
            connection = {
              id = "wwan";
              type = "gsm";
              interface-name = "cdc-wdm0";
            };
            gsm.apn = "internet";
            ipv4.method = "auto";
            ipv6 = {
              method = "auto";
              addr-gen-mode = "stable-privacy";
            };
          };
        };

        secrets.entries = [
          {
            file = config.sops.secrets."wireguard.key".path;
            key = "private-key";
            matchIface = "wg0";
            matchSetting = "wireguard";
          }
        ];
      };
    };

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

  sops.secrets."wireguard.key" = { };

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
