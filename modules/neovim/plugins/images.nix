{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    image-nvim
    (diagram-nvim.overrideAttrs (final: prev: {
      version = "0-unstable-2026-06-12";
      src = prev.src.override {
        rev = "a221810b17cdda2d5fdddba9bab3eba6fab8fabc";
        hash = "sha256-+K5o50CtBFqn37t6GnAnI1p2CfCyA1w4TIhMKpfZX4A=";
      };
    }))
  ];
  programs.neovim.customPlugins.images-config = {
    "plugin/images-config.lua" = # lua
      ''
        vim.filetype.add({
          extension = {
            d2 = "d2",
          },
        })

        require('image').setup({
          backend = "kitty",
          processor = "magick_rock",
        })

        require('diagram').setup({
          renderer_options = {
            mermaid = {
              background = "transparent",
              theme = "dark",
            },
            d2 = {
              theme_id = "200";
              layout = "elk";
              format = "svg";
            },
          },
        })
      '';
  };
}
