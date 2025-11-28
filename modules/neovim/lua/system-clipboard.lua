local M = {}

function M.setup()
  vim.keymap.set({'n','v'}, '<C-c>', '"+y')
  vim.keymap.set({'n','v'}, '<C-v>', '"+p')
  vim.keymap.set({'n','v'}, '<C-x>', '"+d')

  -- Use C-q for block visual mode
  vim.keymap.set({'n','v'}, '<C-q>', '<C-v>', { noremap = true})
end

return M
