{
  programs.neovim.customPlugins.clipboard = {
    "plugin/clipboard.lua" = # lua
      ''
        vim.keymap.set({'n','v'}, '<C-c>', '"+y')
        vim.keymap.set({'n','v'}, '<C-v>', '"+p')
        vim.keymap.set({'n','v'}, '<C-x>', '"+d')

        -- Use C-q for block visual mode
        vim.keymap.set({'n','v'}, '<C-q>', '<C-v>', { noremap = true})
      '';
  };
}
