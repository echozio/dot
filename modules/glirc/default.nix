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

          programs.glirc.extraConfig = lib.mkBefore ''
            key-bindings:
              * bind: "C-d"
                action: scroll-down-small
              * bind: "C-u"
                action: scroll-up-small
              * bind: "C-f"
                action: scroll-down
              * bind: "C-b"
                action: scroll-up
              * bind: "C-a"
                action: jump-to-activity
              * bind: "C-s"
                action: jump-to-previous
          '';
        };
    };
}
