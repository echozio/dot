{
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 0;
    "kernel.keys.maxkeys" = 1000000;
    "kernel.keys.maxbytes" = 25000000;
  };
}
