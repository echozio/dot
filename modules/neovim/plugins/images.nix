{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    image-nvim
    diagram-nvim
  ];
  programs.neovim.customPlugins.images-config= {
    "plugin/images-config.lua" = # lua
      ''
        require('image').setup({
          backend = "kitty",
          processor = "magick_rock";
        })

        require('diagram').setup({
          integrations = {
            require("diagram.integrations.markdown"),
          },
        })
      '';
  };
}
