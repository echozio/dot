{
  lib,
  config,

  impermanence,
  ...
}:
{
  imports = [ impermanence.nixosModules.impermanence ];

  config = {
    fileSystems."/fix".neededForBoot = true;

    environment.persistence."/fix" = {
      hideMounts = true;

      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };
}
