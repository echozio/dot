{
  lib,
  pkgs,

  user,
  style,
  ...
}:
let
  yuck = pkgs.writeTextDir "/eww.yuck" ''
    (defwidget microphone-indicator []
      (box
        :orientation "v"
        :halign "center"
        :valign "center"
        :visible {!microphone-muted}
        :active "false"
        (label :xalign 0.5 :justify "center" :text "")))

    (defwindow microphone-indicator
      :monitor 0
      :stacking "overlay"
      :focusable "none"
      :namespace "microphone-indicator"
      :geometry (geometry :y "10px" :width "0px" :height "0px" :anchor "top center")
      (microphone-indicator))

    (deflisten microphone-muted
      :initial "false"
      "${pkgs.writeShellScript "monitor-microphone-muted" ''
        ${lib.getExe pkgs.pamixer} --default-source --get-mute
        ${lib.getExe' pkgs.pulseaudio "pactl"} --format json subscribe \
          | ${lib.getExe pkgs.jq} --unbuffered -cr 'select(.event == "change" and .on == "source") | "."' \
          | xargs -L1 ${lib.getExe pkgs.pamixer} --default-source --get-mute
      ''}")
  '';

  scss =
    let
      s = toString;
      fg = with style.colors.fg; "rgba(${s r},${s g},${s b},0.2)";
    in
    pkgs.writeTextDir "/eww.scss" ''
      .microphone-indicator {
        color: ${fg};
        font-size: 32px;
        min-width: 44px;
        min-height: 44px;

        &.background {
          background: ${style.colors.bg.rgba};
          border-radius: 10px;
        }
      }
    '';

  configDir = pkgs.symlinkJoin {
    name = "eww-config";
    paths = [
      yuck
      scss
    ];
  };
in
{
  home-manager.users.${user} =
    { config, ... }:
    {
      wayland.windowManager.hyprland.settings.layerrule = [
        "blur on, ignore_alpha 0.19, no_anim on, match:namespace microphone-indicator"
      ];

      programs.eww = {
        inherit configDir;
        enable = true;
      };

      systemd.user.services.eww = {
        Unit = {
          PartOf = [ config.wayland.systemd.target ];
          After = [ config.wayland.systemd.target ];
          ConditionEnvironment = "WAYLAND_DISPLAY";
          X-Restart-Triggers = [ "${config.programs.eww.configDir}" ];
        };

        Service = {
          ExecStart = "${lib.getExe config.programs.eww.package} daemon --no-daemonize";
          ExecStartPost = "${lib.getExe config.programs.eww.package} open microphone-indicator";
          KillMode = "mixed";
          Restart = "on-failure";
        };

        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };
}
