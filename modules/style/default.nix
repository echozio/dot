{ lib, pkgs, ... }:
let
  color = import ./color-helper.nix lib;
in
{
  _module.args.style = {
    wallpaper = builtins.toString ./wallpaper.jpg;

    fonts = {
      mono = rec {
        family = "JetBrains Mono Nerd Font Propo";
        package = pkgs.nerd-fonts.jetbrains-mono;
        ttf = "${package}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontPropo-Regular.ttf";
      };

      sansSerif = rec {
        family = "Open Sans";
        package = pkgs.open-sans;
        ttf = "${package}/share/fonts/truetype/OpenSans-Regular.ttf";
      };

      serif = rec {
        family = "Roboto Slab";
        package = pkgs.roboto-slab;
        ttf = "${package}/share/fonts/truetype/RobotoSlab-Regular.ttf";
      };

      emoji = rec {
        family = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
        ttf = "${package}/share/fonts/noto/NotoColorEmoji.ttf";
      };
    };

    colors = rec {
      bg = color 0 0 0 0.2;
      fg = color 216 222 233 1;
      lo = color 67 76 94 1;
      hi = bg;
      hibg = color 46 52 64 1;
      url = color 0 135 189 1;

      black = color 59 66 82 1;
      brBlack = color 76 86 106 1;

      red = color 191 97 106 1;
      brRed = red;

      green = color 163 190 140 1;
      brGreen = green;

      yellow = color 235 203 139 1;
      brYellow = color 208 135 112 1;

      blue = color 129 161 193 1;
      brBlue = color 94 129 172 1;

      magenta = color 180 142 173 1;
      brMagenta = magenta;

      cyan = color 136 192 208 1;
      brCyan = color 143 188 187 1;

      white = color 229 233 240 1;
      brWhite = color 236 239 244 1;

      color0 = black;
      color1 = red;
      color2 = green;
      color3 = yellow;
      color4 = blue;
      color5 = magenta;
      color6 = cyan;
      color7 = white;

      color8 = brBlack;
      color9 = brRed;
      color10 = brGreen;
      color11 = brYellow;
      color12 = brBlue;
      color13 = brMagenta;
      color14 = brCyan;
      color15 = brWhite;
    };
  };
}
