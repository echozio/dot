{
  lib,
  pkgs,

  style,
  user,
  ...
}:
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
        settings = {
          monitor = [ ",preferred,auto,1" ];

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
            "col.active_border" = "rgba(00000000) ${style.colors.fg.rgbaHex} rgba(00000000) 45deg";
            "col.inactive_border" = "rgba(00000000)";
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

          animations = {
            enabled = lib.mkDefault true;
            bezier = [
              "linear,    0,    0,    1, 1"
              "easeOut,   0.42, 0, 0.58, 1"
              "easeInOut, 0,    0, 0.58, 1"
              "easeIn,    0.42, 0,    1, 1"
            ];
            animation = [
              "windows,     1, 2,   linear"
              "windowsOut,  1, 2,   linear"
              # "border,      1, 2,   linear"
              # "borderangle, 1, 100, linear, loop"
              "fade,        1, 2,   linear"
              "workspaces,  1, 2,   linear"
            ];
          };

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
            "col.border_active" = "rgba(00000000) ${style.colors.fg.rgbaHex} rgba(00000000) 45deg";
            "col.border_inactive" = "rgba(00000000)";
            "col.border_locked_active" = "rgba(00000000) ${style.colors.fg.rgbaHex} rgba(00000000) 45deg";
            "col.border_locked_inactive" = "rgba(00000000)";

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
              "col.active" = style.colors.bg.rgbaHex;
              "col.inactive" = style.colors.bg.rgbaHex;
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

          workspace = (builtins.genList (n: "${toString (n + 1)}, persistent:true") 9) ++ [
            "special:special, on-created-empty:[workspace special:special; float] ${
              pkgs.writeShellScript "init-empty-special-workspace" ''
                settings=(
                  "--override" "initial_window_width=160c"
                  "--override" "initial_window_height=48c"
                )
                uwsm app -- kitty "''${settings[@]}" btop
              ''
            }"
          ];

          "$mod" = lib.mkDefault "SUPER";

          bind = [
            "$mod,       Q,      killactive,"
            "$mod SHIFT, Q,      forcekillactive,"
            "$mod SHIFT, Delete, exit,"
            "$mod,       F,      fullscreen,     0"
            "$mod SHIFT, F,      togglefloating,"
            "$mod CTRL,  F,      pseudo,"
            "$mod,       G,      togglegroup,"
            "$mod,       N,      changegroupactive,f"
            "$mod,       P,      changegroupactive,b"

            "$mod, h, movefocus, l"
            "$mod, j, movefocus, d"
            "$mod, k, movefocus, u"
            "$mod, l, movefocus, r"

            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod, 9, workspace, 9"

            "$mod, Tab, togglespecialworkspace"

            "$mod SHIFT, 1, movetoworkspacesilent, 1"
            "$mod SHIFT, 2, movetoworkspacesilent, 2"
            "$mod SHIFT, 3, movetoworkspacesilent, 3"
            "$mod SHIFT, 4, movetoworkspacesilent, 4"
            "$mod SHIFT, 5, movetoworkspacesilent, 5"
            "$mod SHIFT, 6, movetoworkspacesilent, 6"
            "$mod SHIFT, 7, movetoworkspacesilent, 7"
            "$mod SHIFT, 8, movetoworkspacesilent, 8"
            "$mod SHIFT, 9, movetoworkspacesilent, 9"

            "$mod SHIFT, Tab, movetoworkspacesilent, special:special"
          ];

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];

          bindpunti = [ ", Alt_L, exec, ${lib.getExe pkgs.pamixer} --default-source --unmute" ];
          bindpuntir = [ ", Alt_L, exec, ${lib.getExe pkgs.pamixer} --default-source --mute" ];

          windowrule = [
            "animation popin 100%, match:group on"
            "float on, match:workspace special:special"
            "workspace 4 silent, match:class ^steam$"
            "workspace 2 silent, match:class ^steam_app_[0-9]+$"
            "workspace 5 silent, match:class ^firefox$"
            "workspace 3 silent, match:class ^discord$"
            "workspace 3 silent, match:class ^com.slack.Slack$"
            "workspace 3 silent, match:class ^spotify$"
            "workspace 3 silent, match:class ^org.signal.Signal$"
            "workspace 5 silent, tile on, match:class ^steam_app_2694490"
          ];
        };
      };

      xdg.configFile."uwsm/env".source =
        "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    };
}
