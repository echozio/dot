{
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
        cat = builtins.concatStringsSep " ";
      in
      [
        (cat [
          "$mod, A, exec, uwsm app --"
          "imsh-shot screen --cursor --utc --copy"
          "--output ~/pic/scr/%Y-%m-%dT%H-%M-%S.%3NZ.png"
        ])
        (cat [
          "$mod SHIFT, A, exec, uwsm app --"
          "imsh-shot screen --cursor --utc --copy"
          "--output ~/pic/scr/%Y-%m-%dT%H-%M-%S.%3NZ.png"
          "--api-key '%rbw get scrn.is/api-key' --upload"
        ])
        (cat [
          "$mod, S, exec, uwsm app --"
          "imsh-shot area --freeze --utc --copy"
          "--output ~/pic/scr/%Y-%m-%dT%H-%M-%S.%3NZ.png"
        ])
        (cat [
          "$mod SHIFT, S, exec, uwsm app --"
          "imsh-shot area --freeze --utc --copy"
          "--output ~/pic/scr/%Y-%m-%dT%H-%M-%S.%3NZ.png"
          "--api-key '%rbw get scrn.is/api-key' --upload"
        ])
        (cat [
          "$mod, D, exec, uwsm app --"
          "imsh-shot active --cursor --utc --copy"
          "--output ~/pic/scr/%Y-%m-%dT%H-%M-%S.%3NZ.png"
        ])
        (cat [
          "$mod SHIFT, D, exec, uwsm app --"
          "imsh-shot active --cursor --utc --copy"
          "--output ~/pic/scr/%Y-%m-%dT%H-%M-%S.%3NZ.png"
          "--api-key '%rbw get scrn.is/api-key' --upload"
        ])
        (cat [
          "$mod, R, exec, uwsm app --"
          "imsh-cast --utc --copy"
          "--output ~/vid/rec/%Y-%m-%dT%H-%M-%S.%3NZ.mp4"
        ])
        (cat [
          "$mod SHIFT, R, exec, uwsm app --"
          "imsh-cast --utc --copy"
          "--output ~/vic/rec/%Y-%m-%dT%H-%M-%S.%3NZ.mp4"
          "--api-key '%rbw get scrn.is/api-key' --upload"
        ])
      ];
  };
}
