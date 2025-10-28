{ user, ... }:
{
  virtualisation = {
    containers = {
      enable = true;
      registries.search = [ "docker.io" ];
    };

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users.${user}.extraGroups = [ "podman" ];
}
