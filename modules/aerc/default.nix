{
  lib,
  config,
  pkgs,

  user,
  ...
}:
{
  imports = [
    ./filters.nix
    ./binds.nix
  ];

  config = {
    environment.persistence."/fix".users.${user}.directories = [
      {
        directory = ".cache/aerc";
        mode = "0700";
      }
    ];

    home-manager.users.${user} = {
      options.accounts.email.accounts = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            config.aerc.enable = true;
          }
        );
      };

      config = {
        programs.aerc = {
          enable = true;
          extraConfig = {
            general.unsafe-accounts-conf = true;

            ui = {
              mouse-enabled = true;
              dirlist-tree = true;
              fuzzy-complete = true;
            };

            openers = {
              "text/html" = "firefox";
              "application/pdf" = "firefox";
            };
          };
        };
      };
    };
  };
}
