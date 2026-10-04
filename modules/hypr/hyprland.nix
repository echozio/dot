{
  lib,
  pkgs,

  style,
  user,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;
  key = k: mkLuaInline ''mod .. " + ${k}"'';
  bind = keys: dispatcher: { _args = [ keys (mkLuaInline dispatcher) ]; };
  bindWith = flags: keys: dispatcher: { _args = [ keys (mkLuaInline dispatcher) flags ]; };
in
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  home-manager.users.${user} =
    { config, ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        configType = "lua";
        systemd.enable = false;
        settings = {
          mod._var = lib.mkDefault "SUPER";

          monitor = [
            {
              output = "";
              mode = "preferred";
              position = "auto";
              scale = 1;
            }
          ];

          config = {
            input = {
              kb_layout = "us";
              kb_options = "compose:ralt,caps:escape";
              follow_mouse = 1;
              touchpad.natural_scroll = false;
              sensitivity = 0;
              accel_profile = "flat";
            };

            general = {
              gaps_in = 5;
              gaps_out = 10;
              border_size = 0;
              col = {
                active_border = {
                  colors = [
                    "rgba(00000000)"
                    style.colors.fg.rgbaHex
                    "rgba(00000000)"
                  ];
                  angle = 45;
                };
                inactive_border = "rgba(00000000)";
              };
              layout = "dwindle";
            };

            decoration = {
              rounding = 10;
              shadow.enabled = false;
              blur = {
                enabled = true;
                size = 5;
                passes = 3;
                noise = 0.03333;
              };
              dim_inactive = true;
              dim_strength = 0.2;
              dim_special = 0.2;
              dim_around = 0.2;
            };

            animations.enabled = lib.mkDefault true;

            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
            };

            ecosystem = {
              no_donation_nag = true;
              no_update_news = true;
            };

            group = {
              drag_into_group = 2;
              merge_groups_on_drag = false;
              col = {
                border_active = {
                  colors = [
                    "rgba(00000000)"
                    style.colors.fg.rgbaHex
                    "rgba(00000000)"
                  ];
                  angle = 45;
                };
                border_inactive = "rgba(00000000)";
                border_locked_active = {
                  colors = [
                    "rgba(00000000)"
                    style.colors.fg.rgbaHex
                    "rgba(00000000)"
                  ];
                  angle = 45;
                };
                border_locked_inactive = "rgba(00000000)";
              };

              groupbar = {
                render_titles = true;
                font_family = style.fonts.mono.family;
                font_size = 16;
                text_offset = 0;
                gaps_in = 10;
                gaps_out = 10;
                keep_upper_gap = false;
                height = 44;
                indicator_height = 0;
                gradients = true;
                gradient_rounding = 10;
                gradient_round_only_edges = false;
                col = {
                  active = style.colors.bg.rgbaHex;
                  inactive = style.colors.bg.rgbaHex;
                };
                text_color = style.colors.fg.rgbaHex;
                text_color_inactive = style.colors.lo.rgbaHex;
                blur = true;
              };
            };

            cursor = {
              warp_on_change_workspace = 1;
            };

            binds = {
              workspace_center_on = 1;
            };
          };

          curve = [
            { _args = [ "linear" { type = "bezier"; points = [ [ 0 0 ] [ 1 1 ] ]; } ]; }
            { _args = [ "easeOut" { type = "bezier"; points = [ [ 0.42 0 ] [ 0.58 1 ] ]; } ]; }
            { _args = [ "easeInOut" { type = "bezier"; points = [ [ 0 0 ] [ 0.58 1 ] ]; } ]; }
            { _args = [ "easeIn" { type = "bezier"; points = [ [ 0.42 0 ] [ 1 1 ] ]; } ]; }
          ];

          animation = [
            {
              leaf = "windows";
              enabled = true;
              speed = 2;
              bezier = "linear";
            }
            {
              leaf = "windowsOut";
              enabled = true;
              speed = 2;
              bezier = "linear";
            }
            # { leaf = "border"; enabled = true; speed = 2; bezier = "linear"; }
            # { leaf = "borderangle"; enabled = true; speed = 100; bezier = "linear"; style = "loop"; }
            {
              leaf = "fade";
              enabled = true;
              speed = 2;
              bezier = "linear";
            }
            {
              leaf = "workspaces";
              enabled = true;
              speed = 2;
              bezier = "linear";
            }
          ];

          workspace_rule =
            (builtins.genList (n: {
              workspace = toString (n + 1);
              persistent = true;
            }) 9)
            ++ [
              {
                workspace = "special:special";
                on_created_empty = "[workspace special:special; float] ${pkgs.writeShellScript "init-empty-special-workspace" ''
                  settings=(
                    "--override" "initial_window_width=160c"
                    "--override" "initial_window_height=48c"
                  )
                  uwsm app -- kitty "''${settings[@]}" btop
                ''}";
              }
            ];

          bind = [
            (bind (key "Q") "hl.dsp.window.close()")
            (bind (key "SHIFT + Q") "hl.dsp.window.kill()")
            (bind (key "SHIFT + Delete") "hl.dsp.exit()")
            (bind (key "F") "hl.dsp.window.fullscreen()")
            (bind (key "SHIFT + F") ''hl.dsp.window.float({ action = "toggle" })'')
            (bind (key "CTRL + F") "hl.dsp.window.pseudo()")
            (bind (key "G") "hl.dsp.group.toggle()")
            (bind (key "N") "hl.dsp.group.next()")
            (bind (key "P") "hl.dsp.group.prev()")

            (bind (key "h") ''hl.dsp.focus({ direction = "left" })'')
            (bind (key "j") ''hl.dsp.focus({ direction = "down" })'')
            (bind (key "k") ''hl.dsp.focus({ direction = "up" })'')
            (bind (key "l") ''hl.dsp.focus({ direction = "right" })'')

            (bind (key "Tab") ''hl.dsp.workspace.toggle_special("special")'')
            (bind (key "SHIFT + Tab") ''hl.dsp.window.move({ workspace = "special:special", follow = false })'')
          ]
          ++ (builtins.genList (
            n:
            let
              i = toString (n + 1);
            in
            bind (key i) "hl.dsp.focus({ workspace = ${i} })"
          ) 9)
          ++ (builtins.genList (
            n:
            let
              i = toString (n + 1);
            in
            bind (key "SHIFT + ${i}") "hl.dsp.window.move({ workspace = ${i}, follow = false })"
          ) 9)
          ++ [
            (bindWith { mouse = true; } (key "mouse:272") "hl.dsp.window.drag()")
            (bindWith { mouse = true; } (key "mouse:273") "hl.dsp.window.resize()")

            # previously bindpunti / bindpuntir
            (bindWith {
              dont_inhibit = true;
              submap_universal = true;
              non_consuming = true;
              transparent = true;
              ignore_mods = true;
            } "Alt_L" ''hl.dsp.exec_cmd("${lib.getExe pkgs.pamixer} --default-source --unmute")'')
            (bindWith {
              dont_inhibit = true;
              submap_universal = true;
              non_consuming = true;
              transparent = true;
              ignore_mods = true;
              release = true;
            } "Alt_L" ''hl.dsp.exec_cmd("${lib.getExe pkgs.pamixer} --default-source --mute")'')
          ];

          window_rule = [
            {
              match.group = true;
              animation = "popin 100%";
            }
            {
              match.workspace = "special:special";
              float = true;
            }
            {
              match.class = "^steam$";
              workspace = "4 silent";
            }
            {
              match.class = "^steam_app_[0-9]+$";
              workspace = "2 silent";
            }
            {
              match.class = "^battle.net.exe$";
              workspace = "2 silent";
            }
            {
              match.class = "^firefox$";
              workspace = "5 silent";
            }
            {
              match.class = "^discord$";
              workspace = "3 silent";
            }
            {
              match.class = "^com.slack.Slack$";
              workspace = "3 silent";
            }
            {
              match.class = "^spotify$";
              workspace = "3 silent";
            }
            {
              match.class = "^org.signal.Signal$";
              workspace = "3 silent";
            }
            {
              match.class = "^steam_app_2694490";
              workspace = "5 silent";
              tile = true;
            }
            {
              match.class = "^wow[a-z]*.exe$";
              workspace = "5 silent";
            }
          ];
        };
      };

      xdg.configFile."uwsm/env".source =
        "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    };
}
