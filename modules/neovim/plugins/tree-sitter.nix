{ pkgs, ... }:
{
  programs.neovim.plugins = [
    (
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (
        _:
        pkgs.vimPlugins.nvim-treesitter.allGrammars
        ++ [
          (pkgs.tree-sitter.buildGrammar rec {
            language = "d2";
            version = "0.7.2";
            src = pkgs.fetchFromGitHub {
              owner = "ravsii";
              repo = "tree-sitter-d2";
              tag = "v${version}";
              hash = "sha256-zx6ud3uh+0Z+cYdP2KkFA27Kb6fW/CSGpC1C4YmCIo0=";
            };
          })
        ]
      ))
      // {
        runtimeDeps = [ pkgs.tree-sitter ];
      }
    )
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
