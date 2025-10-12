{
  lib,
  pkgs,

  user,
  ...
}:
{
  environment.persistence."/fix".users.${user}.directories = [
    {
      directory = ".local/state/oama";
      mode = "0700";
    }
  ];

  home-manager.users.${user} =
    { config, ... }:
    {
      options.programs.oama = {
        settings = lib.mkOption {
          type =
            with lib.types;
            let
              jsonValue = nullOr (oneOf [
                (attrsOf jsonValue)
                (listOf jsonValue)
                number
                str
                bool
              ]);
            in
            jsonValue;
          default = null;
        };
      };

      config =
        let
          cfg = config.programs.oama;
        in
        {
          home.packages = [ pkgs.oama ];

          xdg.configFile."oama/config.yaml" = lib.mkIf (cfg.settings != null) {
            text = builtins.toJSON cfg.settings;
          };

          programs.oama.settings = {
            encryption.tag = "GPG";
            services.google = {
              client_id = "406964657835-aq8lmia8j95dhl1a2bvharmfk3t1hgqj.apps.googleusercontent.com";
              client_secret = "kSmqreRr0qwBWJgbf5Y-PjSU";
              auth_scopes = "https://mail.google.com/";
            };
          };
        };
    };
}
