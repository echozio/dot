{
  programs.neovim.customPlugins.general = {
    "plugin/general.lua" = # lua
      ''
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true

        vim.opt.number = true
        vim.opt.relativenumber = true

        vim.opt.scrolloff = 5

        vim.opt.cursorline = true
        vim.opt.textwidth = 100
        vim.opt.colorcolumn = '+1'
        vim.opt.formatoptions = 'cqj'

        vim.opt.undofile = true
        vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'

        vim.opt.path = vim.o.path .. '**'
        vim.opt.wildmenu = true
        vim.opt.wildignore = {
          "**/.direnv/**",
          "**/node_modules/**",
          "**/vendor/**",
        };
      '';

    "ftplugin/mail.lua" = # lua
      ''
        vim.opt.textwidth = 72
      '';
  };
}
