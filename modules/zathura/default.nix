{ style, user, ... }:
{
  home-manager.users.${user}.programs.zathura = {
    enable = true;
    mappings = {
      h = "feedkeys <C-Left>";
      k = "feedkeys <C-Up>";
      j = "feedkeys <C-Down>";
      l = "feedkeys <C-Right>";
    };

    options = with style; {
      font = "${fonts.mono.family} 12";
      default-fg = colors.fg.rgba;
      default-bg = colors.bg.rgba;
      statusbar-bg = colors.bg.rgba;
      inputbar-bg = colors.bg.rgba;
      completion-bg = colors.bg.rgba;
    };
  };
}
