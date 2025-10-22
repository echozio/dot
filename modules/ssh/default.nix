{ pkgs, ... }:
{
  services.openssh = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.sshfs
  ];
}
