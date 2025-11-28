local M = {}

function M.setup()
  vim.g.netrw_banner = 0

  -- absolute 30 cols/rows
  vim.g.netrw_winsize = -30

  -- tree style
  vim.g.netrw_liststyle = 3
end

return M
