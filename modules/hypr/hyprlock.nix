{
  user,
  ...
}:
{
  security.pam.services.hyprlock = { };

  home-manager.users.${user}.programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      background = {
        path = "screenshot";
        blur_passes = 3;
        blur_size = 9;
      };

      input-field = {
        size = "500, 64";
        position = "0, 0";
        monitor = "";
        dots_center = false;
        fade_on_empty = true;
        font_color = "rgba(255, 255, 255, 0.2)";
        inner_color = "rgba(0,0,0,0.2)";
        check_color = "rgba(0,0,255,0.2)";
        fail_color = "rgba(255,0,0,0.2)";
        fail_text = "";
        outline_thickness = 0;
        placeholder_text = "";
        shadow_passes = 0;
      };
    };
  };
}
