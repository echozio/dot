{ pkgs, ... }:
{
  programs.neovim.plugins = [
    (pkgs.vimPlugins.nvim-treesitter.withAllGrammars // { runtimeDeps = [ pkgs.tree-sitter ]; })
  ];
  programs.neovim.customPlugins.treesitter-config = {
    "plugin/tree-sitter-config.lua" = # lua
      ''
        require('nvim-treesitter.config').setup({
          highlight = {
            enable = true,
            disable = {},
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
              },
            },
          },
        })


        vim.api.nvim_create_autocmd('FileType', {
          group = vim.api.nvim_create_augroup('TreeSitterStart', { clear = true }),
          callback = function(args)
            local language = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
            if vim.treesitter.language.add(language) then
              vim.treesitter.start(args.buf, language)
            end
          end
        })
      '';
  };
}
