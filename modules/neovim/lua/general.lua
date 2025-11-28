local M = {}

function M.setup()
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
end

return M
