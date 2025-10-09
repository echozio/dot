{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.networking.networkmanager.enable {
    environment.persistence."/fix".directories = [ "/etc/NetworkManager" ];
  };
}
