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
      options.programs.glirc = {
        extraConfig = lib.mkOption {
          type = with lib.types; nullOr lines;
          default = null;
        };
      };

      config =
        let
          cfg = config.programs.glirc;
        in
        {
          home.packages = [ pkgs.glirc ];

          xdg.configFile."glirc/config" = lib.mkIf (cfg.extraConfig != null) {
            text = cfg.extraConfig;
          };
        };
    };
}
