{
  lib,
  user,

  imsh-clients,
  ...
}:
{
  home-manager.users.${user} = {
    imports = [
      imsh-clients.homeManagerModules.imsh-clients
    ];

    programs.imsh-clients = {
      enable = true;
      imsh-cast-monitor.waybar.enable = true;
    };

    wayland.windowManager.hyprland.settings.bind =
      let
        bind = keys: command: {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + ${keys}"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("uwsm app -- ${builtins.concatStringsSep " " command}")'')
          ];
        };
      in
      [
        (bind "A" [
          "imsh-shot screen --cursor --utc --copy"
          "--output ~/pic/scr/%Y-%m-%dT%H-%M-%S.%3NZ.png"
        ])
        (bind "SHIFT + A" [
          "imsh-shot screen --cursor --utc --copy"
          "--output ~/pic/scr/%Y-%m-%dT%H-%M-%S.%3NZ.png"
          "--api-key '%rbw get scrn.is/api-key' --upload"
        ])
        (bind "S" [
          "imsh-shot area --freeze --utc --copy"
          "--output ~/pic/scr/%Y-%m-%dT%H-%M-%S.%3NZ.png"
        ])
        (bind "SHIFT + S" [
          "imsh-shot area --freeze --utc --copy"
          "--output ~/pic/scr/%Y-%m-%dT%H-%M-%S.%3NZ.png"
          "--api-key '%rbw get scrn.is/api-key' --upload"
        ])
        (bind "D" [
          "imsh-shot active --cursor --utc --copy"
          "--output ~/pic/scr/%Y-%m-%dT%H-%M-%S.%3NZ.png"
        ])
        (bind "SHIFT + D" [
          "imsh-shot active --cursor --utc --copy"
          "--output ~/pic/scr/%Y-%m-%dT%H-%M-%S.%3NZ.png"
          "--api-key '%rbw get scrn.is/api-key' --upload"
        ])
        (bind "R" [
          "imsh-cast --utc --copy"
          "--output ~/vid/rec/%Y-%m-%dT%H-%M-%S.%3NZ.mp4"
        ])
        (bind "SHIFT + R" [
          "imsh-cast --utc --copy"
          "--output ~/vic/rec/%Y-%m-%dT%H-%M-%S.%3NZ.mp4"
          "--api-key '%rbw get scrn.is/api-key' --upload"
        ])
      ];
  };
}
