{ style, ... }:
{
  config.boot.plymouth = {
    enable = true;
    font = style.fonts.mono.ttf;
  };
}
