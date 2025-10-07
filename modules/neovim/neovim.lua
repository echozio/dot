vim.opt.tabstop = 2
vim.opt.shiftwidth = 0
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.path = vim.o.path .. '**'
vim.opt.wildmenu = true
vim.opt.cursorline = true
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
vim.opt.colorcolumn = '+1'
vim.opt.textwidth = 72
vim.opt.formatoptions = 'cqj'
vim.keymap.set({'n','v'}, '<C-c>', '"+y')
vim.keymap.set({'n','v'}, '<C-v>', '"+p')
vim.keymap.set({'n','v'}, '<C-x>', '"+d')
vim.keymap.set({'n','v'}, '<C-q>', '<C-v>', { noremap = true})
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('ReturnToLastLine', { clear = true }),
  callback = function()
    local last = vim.fn.line([['"]])
    if last > 1 and last < vim.fn.line("$") then
      vim.cmd([[normal! g'"]])
    end
  end
})
vim.opt.list = true
vim.opt.listchars = {
  trail = '~',
  tab = '|  ',
  leadmultispace = ':' .. string.rep(' ', vim.opt.tabstop:get() - 1),
}
vim.api.nvim_create_autocmd('OptionSet', {
  group = vim.api.nvim_create_augroup('ListcharsLeadmultispaceWidth', { clear = true }),
  pattern = 'tabstop',
  callback = function()
    local listchars = vim.opt.listchars:get()
    listchars.leadmultispace = ':' .. string.rep(' ', vim.opt.tabstop:get() - 1)
    vim.opt.listchars = listchars
  end
})
vim.opt.cmdheight = 0
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
vim.api.nvim_set_hl(0, 'Normal', { bg='none' })
vim.api.nvim_set_hl(0, 'StatusLine', { bg='none' })
vim.api.nvim_set_hl(0, 'WinBar', { bg='none' })
vim.api.nvim_set_hl(0, 'WinBarNC', { bg='none', fg='gray' })
function _G.WinBar()
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
  return table.concat(buffers)
end
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufDelete'}, {
  group = vim.api.nvim_create_augroup("WinBarVisibility", { clear = true }),
  pattern = "*",
  callback = function()
    local buffers = 0
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[bufnr].buflisted then
        buffers = buffers + 1
      end
    end
    if buffers > 1 then
      vim.opt.winbar = "%!v:lua.WinBar()"
    else
      vim.opt.winbar = ""
    end
  end
})
vim.diagnostic.config({ virtual_text = true })
vim.opt.signcolumn = "yes"
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.api.nvim_create_autocmd('InsertCharPre', {
  group = vim.api.nvim_create_augroup("TriggerAutocomplete", { clear = true }),
  buffer = vim.api.nvim_get_current_buf(),
  callback = function()
    vim.lsp.completion.get()
  end
})
vim.lsp.config('*', {
  root_markers = { '.git' },
  on_attach = function(client, bufnr)
    vim.lsp.completion.enable(true, client.id, bufnr, {})
  end,
})
vim.lsp.config('nixd', {
  cmd = { 'nixd' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
})
vim.lsp.enable({
  "nixd",
})
