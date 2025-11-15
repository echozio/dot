{ disko, ... }:
{
  imports = [ disko.nixosModules.disko ];

  disko.devices = {
    disk.system = {
      type = "disk";

      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "nofail" ];
            };
          };

          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "system";
            };
          };
        };
      };
    };

    zpool.system = {
      type = "zpool";
      rootFsOptions = {
        mountpoint = "none";
        compression = "zstd";
        acltype = "posixacl";
        xattr = "sa";
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "prompt";
      };
      options.ashift = "12";

      datasets = {
        root = {
          type = "zfs_fs";
          options.mountpoint = "none";
        };

        "root/current" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/";
        };

        nix = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/nix";
        };

        fix = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/fix";
        };
      };
    };
  };
}
