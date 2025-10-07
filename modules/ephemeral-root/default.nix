{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = {
    boot.initrd.systemd.services.zfs-rotate-root = {
      wantedBy = [ "initrd.target" ];
      after = [ "zfs-import-system.service" ];
      before = [ "sysroot.mount" ];
      path = with pkgs; [
        zfs
        coreutils
      ];
      description = "rotate root dataset";
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        zfs rename "system/root/current" "system/root/$(date -ud "@$(zfs get -Hpo value creation system/root/current)" +%Y-%m-%dT%H-%M-%SZ)"
        zfs create -o mountpoint=legacy "system/root/current"
      '';
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "prune-roots" (builtins.readFile ./prune-roots.sh))
    ];
  };
}
