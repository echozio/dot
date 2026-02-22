{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.programs.neovim.languageServers = lib.mkOption {
    type = with lib.types; attrsOf anything;
  };

  config.programs.neovim = {
    languageServers = {
      nixd = {
        cmd = [ (lib.getExe pkgs.nixd) ];
        filetypes = [ "nix" ];
        root_markers = [
          "flake.nix"
          ".git"
        ];
        settings.nixd.formatting.command = [ (lib.getExe pkgs.nixfmt) ];
      };

      gopls = {
        cmd = [ (lib.getExe pkgs.gopls) ];
        filetypes = [
          "go"
          "gomod"
        ];
        root_markers = [
          "go.work"
          "go.mod"
          ".git"
        ];
      };

      typescript-language-server = {
        cmd = [
          (lib.getExe pkgs.typescript-language-server)
          "--stdio"
        ];
        filetypes = [
          "javascript"
          "typescript"
        ];
        root_markers = [
          [
            "jsconfig.json"
            "tsconfig.json"
          ]
          "package.json"
          ".git"
        ];
        init_options.hostInfo = "neovim";
      };

      basedpyright = {
        cmd = [
          (lib.getExe' pkgs.basedpyright "basedpyright-langserver")
          "--stdio"
        ];
        filetypes = [ "python" ];
        root_markers = [
          "pyrightconfig.json"
          "pyproject.toml"
          "setup.py"
          ".git"
        ];
        settings.basedpyright = {
          analysis.typeCheckingMode = "basic";
        };
      };

      lua-language-server = {
        cmd = [ (lib.getExe pkgs.lua-language-server) ];
        filetypes = [ "lua" ];
        settings.Lua."diagnostics.globals" = [ "vim" ];
      };
    };

    customPlugins.lsp = {
      "plugin/lsp.lua" = # lua
        ''
          vim.opt.signcolumn = "yes"
          vim.opt.completeopt = { "fuzzy", "menu", "menuone", "noinsert", "popup" }

          vim.diagnostic.config({ virtual_text = true })

          vim.lsp.config('*', {
            root_markers = { '.git' },
            on_attach = function(client, bufnr)
              vim.lsp.completion.enable(true, client.id, bufnr, {})
            end,
          })

          vim.keymap.set({ 'n', 'v' }, 'gqb', vim.lsp.buf.format)
          vim.keymap.set({ 'n', 'v' }, '<C-W>a', vim.diagnostic.setloclist)

          vim.lsp.enable(${
            lib.generators.toLua { } (builtins.attrNames config.programs.neovim.languageServers)
          })
        '';
    }
    // (lib.mapAttrs' (name: config: {
      name = "lsp/${name}.lua";
      value = "return ${lib.generators.toLua { } config}";
    }) config.programs.neovim.languageServers);
  };
}
