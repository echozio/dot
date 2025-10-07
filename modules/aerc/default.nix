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
          lib.types.submodule (
            { config, ... }:
            {
              config.aerc = {
                enable = true;
                extraAccounts = lib.mkIf (config.signature.showSignature == "append") {
                  signature-file =
                    builtins.toFile (lib.strings.sanitizeDerivationName "${config.address}-signature")
                      (
                        lib.concatStrings [
                          config.signature.delimiter
                          config.signature.text
                        ]
                      );
                  signature-cmd = lib.mkIf (config.signature.command != null) config.signature.command;
                };
              };
            }
          )
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
