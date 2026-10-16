{
  user,
  ...
}:
{
  imports = [ ./syncthingtray-init.nix ];

  environment.persistence."/fix".users.${user}.directories = [ ".local/state/syncthing" ];

  home-manager.users.${user}.services.syncthing = {
    enable = true;
    tray.enable = true;

    overrideFolders = true;
    overrideDevices = true;
    settings.options = {
      urAccepted = -1;
    };
  };
}
