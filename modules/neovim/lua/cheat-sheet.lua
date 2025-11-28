local M = {}

function M.setup(opts)
  M.file = opts.file or "/dev/null"
  M.lines = {}

  for line in io.lines(M.file) do
    table.insert(M.lines, line)
  end

  vim.keymap.set({'n','v'}, '<C-/>', function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', {
      silent = true,
      nowait = true,
    })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, M.lines)
    local win = vim.api.nvim_open_win(buf, true, {
      title = 'Cheat sheet',
      relative = 'editor',
      row = math.floor(vim.o.lines * 0.10),
      col = math.floor(vim.o.columns * 0.10),
      height = math.floor(vim.o.lines * 0.80),
      width = math.floor(vim.o.columns * 0.80),
      style = 'minimal',
      title_pos = 'center',
      focusable = true,
    })
  end)
end

return M
