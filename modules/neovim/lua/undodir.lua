local M = {}

function M.setup()
  vim.opt.undofile = true
  vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
end

return M
