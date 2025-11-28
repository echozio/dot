local M = {}

function M.setup()
  vim.opt.path = vim.o.path .. '**'
  vim.opt.wildmenu = true
  vim.opt.wildignore = {
    "**/.direnv/**",
    "**/node_modules/**",
    "**/vendor/**",
  };
end

return M
