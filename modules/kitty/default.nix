{
  lib,
  pkgs,

  style,
  user,
  ...
}:
{
  config.home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.bind = [ "$mod, Return, exec, uwsm app -- kitty" ];

    programs.kitty = {
      enable = true;
      # ctrl+shift+wheel zooms; upstream declined wheel support in mouse_map
      package = pkgs.kitty.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./wheel-zoom.patch ];
      });
      font = {
        name = style.fonts.mono.family;
        size = 12;
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      settings = {
        window_padding_width = 10;
        disable_ligatures = false;
        confirm_os_window_close = 0;
        remember_window_size = false;
        initial_window_width = "80c";
        initial_window_height = "24c";
      }
      // (with style.colors; {
        foreground = "#${fg.hex}";
        background = "#${bg.hex}";
        background_opacity = bg.a;
        selection_foreground = "#${bg.hex}";
        selection_background = "#${fg.hex}";

        cursor = "#${fg.hex}";
        cursor_text_color = "#${bg.hex}";

        url_color = "#${url.hex}";
      })
      // builtins.mapAttrs (_: c: "#${c.hex}") (
        lib.getAttrs (builtins.genList (n: "color${toString n}") 16) style.colors
      );
      extraConfig = ''
        mouse_map ctrl+shift+middle press ungrabbed change_font_size all 0
      '';
    };
  };
}
