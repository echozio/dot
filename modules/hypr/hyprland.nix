{
  lib,
  pkgs,

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
            gaps_out = 20;
            border_size = 2;
            "col.active_border" = "rgba(00000000) rgba(ffffffff) rgba(00000000) 45deg";
            "col.inactive_border" = "rgba(00000000)";
            layout = "dwindle";
          };

          decoration = {
            rounding = 10;
            shadow = {
              enabled = false;
              range = 4;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };
            blur = {
              enabled = true;
              size = 9;
              passes = 3;
              new_optimizations = true;
            };
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
              "border,      1, 2,   linear"
              "borderangle, 1, 100, linear, loop"
              "fade,        1, 2,   linear"
              "workspaces,  1, 2,   linear"
            ];
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            disable_hyprland_qtutils_check = true;
          };

          ecosystem = {
            no_donation_nag = true;
            no_update_news = true;
          };

          group = {
            drag_into_group = 2;
            merge_groups_on_drag = false;
            "col.border_active" = "rgba(00000000) rgba(ffffffff) rgba(00000000) 45deg";
            "col.border_inactive" = "rgba(00000000)";
            "col.border_locked_active" = "rgba(00000000) rgba(ffffffff) rgba(00000000) 45deg";
            "col.border_locked_inactive" = "rgba(00000000)";

            groupbar = {
              render_titles = false;
              gaps_in = 1;
              gaps_out = 5;
              indicator_height = 4;
              rounding = 2;
              "col.active" = "rgba(ffffffff)";
              "col.inactive" = "rgba(999999ff)";
            };
          };

          cursor = {
            warp_on_change_workspace = 1;
          };

          binds = {
            workspace_center_on = 1;
          };

          workspace = (builtins.genList (n: "${toString (n + 1)}, persistent:true") 9) ++ [
            "special:special, on-created-empty:kitty --class kitty-special"
          ];

          "$mod" = lib.mkDefault "SUPER";

          bind = [
            "$mod,       Q,      killactive,"
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
            "$mod, 0, togglespecialworkspace"

            "$mod SHIFT, 1, movetoworkspacesilent, 1"
            "$mod SHIFT, 2, movetoworkspacesilent, 2"
            "$mod SHIFT, 3, movetoworkspacesilent, 3"
            "$mod SHIFT, 4, movetoworkspacesilent, 4"
            "$mod SHIFT, 5, movetoworkspacesilent, 5"
            "$mod SHIFT, 6, movetoworkspacesilent, 6"
            "$mod SHIFT, 7, movetoworkspacesilent, 7"
            "$mod SHIFT, 8, movetoworkspacesilent, 8"
            "$mod SHIFT, 9, movetoworkspacesilent, 9"
            "$mod SHIFT, 0, movetoworkspacesilent, special:special"
          ];

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];

          bindni = [ ", Alt_L, sendkeystate, , Alt_L, down, class:discord" ];
          bindnir = [ ", Alt_L, sendkeystate, , Alt_L, up, class:discord" ];

          windowrule = [
            "noblur, xwayland:1"
            "workspace special:special silent, class:^kitty-special$"
            "size 827 555, class:^kitty-special$"
            "float, onworkspace:special:special"
            "workspace 4 silent, class:^steam$"
            "workspace 2 silent, class:^steam_app_[0-9]+$"
            "workspace 5 silent, class:^firefox$"
            "workspace 3 silent, class:^discord$"
            "workspace 3 silent, class:^Slack$"
            "workspace 3 silent, class:^Spotify$"
          ];
        };
      };

      xdg.configFile."uwsm/env".source =
        "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        name = "Adwaita";
        package = pkgs.gnome-themes-extra;
        size = 24;
      };
    };
}
