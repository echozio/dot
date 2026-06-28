{ pkgs, user, ... }:
{
  services.openssh = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.sshfs
  ];

  home-manager.users.${user}.programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."Host *".setEnv = "TERM=xterm-256color";
  };
}
