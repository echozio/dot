{ pkgs, user, ... }:
{
  virtualisation = {
    containers = {
      enable = true;
      registries.search = [ "docker.io" ];
    };

    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = [ pkgs.podman-compose ];

  users.users.${user}.extraGroups = [ "podman" ];
}
