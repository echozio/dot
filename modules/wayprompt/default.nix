{
  style,
  user,
  ...
}:
{
  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.layerrule = [
      "blur on, ignore_alpha 0, match:namespace wayprompt"
    ];

    programs.wayprompt = {
      enable = true;

      settings = {
        general = {
          font-regular = "${style.fonts.mono.family}:size=12";
          font-large = "${style.fonts.mono.family}:size=24";
          corner-radius = 10;
          border = 0;
          pin-square-amount = 32;
        };

        colours = with style.colors; {
          background = bg.hexRgba;
          border = bg.hexRgba;
          text = fg.hexRgba;
          error-text = fg.hexRgba;

          pin-background = bg.hexRgba;
          pin-border = fg.hexRgba;
          pin-square = fg.hexRgba;

          ok-button = bg.hexRgba;
          ok-button-border = fg.hexRgba;
          ok-button-text = fg.hexRgba;

          not-ok-button = bg.hexRgba;
          not-ok-button-border = fg.hexRgba;
          not-ok-button-text = fg.hexRgba;

          cancel-button = bg.hexRgba;
          cancel-button-border = fg.hexRgba;
          cancel-button-text = fg.hexRgba;
        };
      };
    };
  };
}
