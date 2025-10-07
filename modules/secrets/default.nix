{
  lib,
  config,
  sops-nix,
  ...
}:
{
  imports = [ sops-nix.nixosModules.sops ];

  config = {
    home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ];

    sops = {
      age.sshKeyPaths = [ "/fix/etc/ssh/ssh_host_ed25519_key" ];
      gnupg.sshKeyPaths = [ ];
    };
  };
}
