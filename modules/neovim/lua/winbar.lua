local M = {}

function M.setup()
  vim.api.nvim_create_autocmd({'BufEnter', 'BufAdd', 'BufDelete', 'BufLeave', 'BufModifiedSet', 'BufWrite'}, {
    group = vim.api.nvim_create_augroup("WinBarBuffers", { clear = true }),
    pattern = "*",
    callback = function()
      local buffers = {}
      local current = vim.api.nvim_win_get_buf(0)

      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buflisted then
          local name = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
          if name == "" then name = "[No name]" end

          local highlight = bufnr == current and "WinBar" or "WinBarNC"
          local modified = vim.bo[bufnr].modified and "*" or ""

          table.insert(buffers, string.format(
            "%%#%s# %d:%s%s %%*",
            highlight, bufnr, name, modified
          ))
        end
      end

      if #buffers > 1 and vim.bo[current].buflisted then
        vim.opt_local.winbar = table.concat(buffers)
        vim.keymap.set({'n','v'}, '<C-n>', ':bn<cr>', { buffer = current })
        vim.keymap.set({'n','v'}, '<C-p>', ':bp<cr>', { buffer = current })

      else
        vim.opt_local.winbar = ""
        pcall(function()
          vim.keymap.del({'n','v'}, '<C-n>', { buffer = current })
          vim.keymap.del({'n','v'}, '<C-p>', { buffer = current })
        end)
      end
    end
  })
end

return M
