{
  lib,
  pkgs,

  user,
  ...
}:
{
  home-manager.users.${user} =
    { config, ... }:
    {
      options.programs.nom = {
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
          cfg = config.programs.nom;
        in
        {
          home.packages = [ pkgs.nom ];

          xdg.configFile."nom/config.yml" = lib.mkIf (cfg.settings != null) {
            text = builtins.toJSON cfg.settings;
          };

          programs.nom.settings = {
            database = lib.mkDefault "../../etc/.nom.db";
            ordering = lib.mkDefault "desc";
            refreshInterval = 1;
          };
        };
    };
}
