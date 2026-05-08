{ pkgs, ... }:
{
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    daemon.settings = {
      features.containerd-snapshotter = true;
    };
    extraPackages = [ pkgs.passt ];
  };

  systemd.user.services.docker.environment = {
    DOCKERD_ROOTLESS_ROOTLESSKIT_NET = "pasta";
    DOCKERD_ROOTLESS_ROOTLESSKIT_PORT_DRIVER = "implicit";
  };

  boot = {
    kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 0;
      "net.ipv4.ip_forward" = 1;
    };
    kernelModules = [ "iptable_nat" ];
  };
}
