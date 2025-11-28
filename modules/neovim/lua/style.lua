local M = {}

function M.setup()
  vim.api.nvim_set_hl(0, 'Normal', { bg='none' })
  vim.api.nvim_set_hl(0, 'StatusLine', { bg='none' })
  vim.api.nvim_set_hl(0, 'StatusLineNC', { bg='none', fg='gray' })
  vim.api.nvim_set_hl(0, 'WinBar', { bg='none' })
  vim.api.nvim_set_hl(0, 'WinBarNC', { bg='none', fg='gray' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg='none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg='none' })
  vim.api.nvim_set_hl(0, 'Pmenu', { bg='none' })
  vim.api.nvim_set_hl(0, 'PmenuBorder', { bg='none' })

  vim.opt.winborder = "rounded";
  vim.opt.pumborder = "rounded";

  vim.opt.cmdheight = 0

  -- Raise cmdheight to make recording status visible
  vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
      vim.opt.cmdheight = 1
    end,
  })
  vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
      vim.opt.cmdheight = 0
    end,
  })
end

return M
