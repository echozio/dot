{
  programs.neovim.customPlugins.listchars = {
    "plugin/listchars.lua" = # lua
      ''
        vim.opt.list = true
        vim.opt.listchars = {
          trail = '~',
          tab = '|  ',
          leadmultispace = ':' .. string.rep(' ', vim.opt.shiftwidth:get() - 1),
        }

        local function update()
          local listchars = vim.opt_local.listchars:get()
          listchars.leadmultispace = ':' .. string.rep(' ', vim.opt_local.shiftwidth:get() - 1)
          vim.opt_local.listchars = listchars
        end

        local group = vim.api.nvim_create_augroup('ListcharsLeadmultispaceWidth', { clear = true }),

        vim.api.nvim_create_autocmd('OptionSet', {
          group = group,
          pattern = 'shiftwidth',
          callback = update,
        })

        vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, {
          group = group,
          callback = update,
        })
      '';
  };
}
