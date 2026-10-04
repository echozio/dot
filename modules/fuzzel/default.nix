{
  lib,
  style,
  user,
  ...
}:
{
  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings = {
      bind = [
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + Escape"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("uwsm app -- fuzzel")'')
          ];
        }
      ];
      layer_rule = [
        {
          match.namespace = "launcher";
          blur = true;
          ignore_alpha = 0.19;
          dim_around = true;
        }
      ];
    };

    programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          font = "${style.fonts.mono.family}:size=12";
          terminal = "kitty";
          launch-prefix = "uwsm app --";
          list-executables-in-path = true;
          placeholder = "Search...";
          line-height = 40;
          lines = 5;
          width = 60;
          horizontal-pad = 40;
          vertical-pad = 40;
          inner-pad = 10;
        };

        colors = with style.colors; {
          background = bg.hexRgba;
          text = lo.hexRgba;
          prompt = lo.hexRgba;
          input = fg.hexRgba;
          placeholder = lo.hexRgba;
          match = yellow.hexRgba;
          selection = "00000000";
          selection-text = fg.hexRgba;
          selection-match = yellow.hexRgba;
          counter = lo.hexRgba;
        };

        border = {
          width = 0;
          radius = 10;
        };
      };
    };
  };
}
