{
  lib,

  user,
  ...
}:
{
  imports = [
    ./policies.nix
  ];

  environment.persistence."/fix".users.${user}.directories = [
    {
      directory = ".mozilla";
      mode = "0700";
    }
  ];

  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.bind = [ "$mod, W, exec, uwsm app -- firefox" ];
    programs.zsh.shellAliases.ff = "firefox";

    programs.firefox = {
      enable = true;

      profiles.default = {
        id = 0;
        isDefault = true;
        containersForce = true;
        containers = {
          personal = {
            id = 0;
            color = "green";
            icon = "fingerprint";
          };
          work = {
            id = 1;
            color = "blue";
            icon = "briefcase";
          };
        };

        extraConfig = builtins.readFile ./user.js;
        userChrome = builtins.readFile ./userChrome.css;
      };
    };
  };
}
