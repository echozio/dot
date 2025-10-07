{
  lib,
  config,
  pkgs,

  user,

  home-manager,
  ...
}:
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  config = {
    users = {
      users.${user} = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.password.path;
        group = user;
        uid = 1000;
        useDefaultShell = true;
        extraGroups = [
          "wheel"
          "video"
          "audio"
        ];
      };

      groups.${user}.gid = 1000;
    };

    sops.secrets.password.neededForUsers = true;

    home-manager.users.${user} = {
      home.stateVersion = lib.mkDefault config.system.stateVersion;
    };
  };
}
