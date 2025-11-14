{ user, ... }:
{
  home-manager.users.${user}.programs.zathura = {
    enable = true;
    mappings = {
      h = "feedkeys <C-Left>";
      k = "feedkeys <C-Up>";
      j = "feedkeys <C-Down>";
      l = "feedkeys <C-Right>";
    };

    options = {
      font = "JetBrains Mono Nerd Font Propo 12";
      default-fg = "rgba(255,255,255,1)";
      default-bg = "rgba(0,0,0,0.2)";
      statusbar-bg = "rgba(0,0,0,0)";
      inputbar-bg = "rgba(0,0,0,0)";
      completion-bg = "rgba(0,0,0,0)";
    };
  };
}
