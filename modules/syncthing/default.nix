{
  user,
  ...
}:
{
  imports = [ ./syncthingtray-init.nix ];

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
