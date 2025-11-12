{ user, ... }:
{
  home-manager.users.${user}.programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      toggle_hud = "Super_L+M";
      no_display = true;

      toggle_fps_limit = "Super_L+T";
      fps_limit = [
        0
        60
        30
      ];

      background_color = "000000";
      position = "top-left";
      text_color = "ffffff";
      round_corners = 0;
      table_columns = 3;
      background_alpha = 0.8;
      font_size = 24;

      legacy_layout = false;

      fps = true;

      gpu_stats = true;
      gpu_temp = true;
      gpu_load_change = true;
      gpu_load_value = [
        50
        90
      ];
      gpu_load_color = [
        "ffffff"
        "ffaa7f"
        "cc0000"
      ];
      gpu_text = "GPU";

      vram = true;
      vram_color = "ad64c1";

      cpu_stats = true;
      cpu_temp = true;
      cpu_load_change = true;
      cpu_load_value = [
        50
        90
      ];
      cpu_load_color = [
        "ffffff"
        "ffaa7f"
        "cc0000"
      ];
      cpu_text = "CPU";

      ram = true;
      ram_color = "c26693";

      frame_timing = true;
      frametime_color = "00ff00";

      vkbasalt = true;
    };
  };
}
