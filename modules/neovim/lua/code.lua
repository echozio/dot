local M = {}

function M.setup()
  vim.opt.signcolumn = "yes"
  vim.opt.completeopt = { "fuzzy", "menu", "menuone", "noinsert", "popup" }

  vim.diagnostic.config({ virtual_text = true })

  vim.lsp.config('*', {
    root_markers = { '.git' },
    on_attach = function(client, bufnr)
      vim.lsp.completion.enable(true, client.id, bufnr, {})
    end,
  })
end

return M
