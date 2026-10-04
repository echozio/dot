{
  lib,
  style,
  user,
  walker,
  ...
}:
{
  config.home-manager.users.${user} = {
    imports = [ walker.homeManagerModules.walker ];

    wayland.windowManager.hyprland.settings = {
      bind = [
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + Escape"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("uwsm app -- walker")'')
          ];
        }
      ];
      layer_rule = [
        {
          match.namespace = "walker";
          blur = true;
          ignore_alpha = 0.19;
          dim_around = true;
        }
      ];
    };

    programs.walker = {
      enable = true;
      runAsService = true;

      config = {
        placeholders.default = {
          input = "Search...";
          list = "";
        };
        providers = {
          default = [ "desktopapplications" ];
          empty = [ "desktopapplications" ];
        };
        theme = "custom";
      };

      themes.custom = {
        style = ''
          * {
            background: none;
            border: none;
            box-shadow: none;
            color: #${style.colors.fg.hex};
            font-family: ${style.fonts.mono.family};
            font-size: 12pt;
            outline: none;
          }

          .box-wrapper {
            padding: 20px;
            border-radius: 20px;
            background: ${style.colors.bg.rgba};
          }
        '';
      };

      elephant = {
        installService = true;
        settings = {
          providers.desktopapplications = {
            launch_prefix = "uwsm app --";
          };
        };
      };
    };
  };
}
