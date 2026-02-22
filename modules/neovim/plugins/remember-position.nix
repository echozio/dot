{
  programs.neovim.customPlugins.remember-position= {
    "plugin/remember-position.lua" = # lua
      ''
        vim.api.nvim_create_autocmd('BufReadPost', {
          group = vim.api.nvim_create_augroup('ReturnToLastLine', { clear = true }),
          callback = function()
            local last = vim.fn.line([['"]])
            if last > 1 and last < vim.fn.line("$") then
              vim.cmd([[normal! g'"]])
            end
          end
        })
      '';
  };
}
