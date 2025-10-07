{
  lib,

  user,
  ...
}:
{
  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.layerrule = [
      "blur,wayprompt"
      "ignorezero,wayprompt"
    ];

    programs.wayprompt = {
      enable = true;

      settings = {
        general = {
          font-regular = "JetBrains Mono Nerd Font Propo:size=12";
          font-large = "JetBrains Mono Nerd Font Propo:size=24";
          corner-radius = 10;
          border = 0;
          pin-square-amount = 32;
        };

        colours = {
          background = "00000033";
          border = "00000033";
          text = "ffffffff";
          error-text = "ffffffff";

          pin-background = "00000033";
          pin-border = "eeeeeeff";
          pin-square = "eeeeeeff";

          ok-button = "00000033";
          ok-button-border = "eeeeeeff";
          ok-button-text = "eeeeeeff";

          not-ok-button = "00000033";
          not-ok-button-border = "eeeeeeff";
          not-ok-button-text = "eeeeeeff";

          cancel-button = "00000033";
          cancel-button-border = "eeeeeeff";
          cancel-button-text = "eeeeeeff";
        };
      };
    };
  };
}
