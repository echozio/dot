{
  pkgs,
  ...
}:
{
  config.boot.plymouth = {
    enable = true;
    font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontPropo-Regular.ttf";
  };
}
