{
  lib,
  pkgs,
  ...
}:
let
  runtime = luaRuntime // lspRuntime // ftpluginRuntime // treesitterRuntime;

  initLua = generateInitLua runtime {
    cheat-sheet.file = ./cheat-sheet.txt;
    init = { };
  };

  luaRuntime = importLuaDir "lua" ./lua;
  ftpluginRuntime = importLuaDir "ftplugin" ./ftplugin;

  lspRuntime = generateLspRuntime {
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
        "gowork"
        "gotmpl"
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

    ruff = {
      cmd = [
        (lib.getExe pkgs.ruff)
        "server"
      ];
      filetypes = [ "python" ];
      root_markers = [
        "pyproject.toml"
        "ruff.toml"
        ".ruff.toml"
        ".git"
      ];
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

  treesitterRuntime =
    let
      languages = [
        "typescript"
        "javascript"
        "nix"
        "lua"
        "go"
        "python"
      ];

      grammars = pkgs.symlinkJoin {
        name = "neovim-grammars";
        paths = lib.mapAttrsToList (_: grammar: pkgs.neovimUtils.grammarToPlugin grammar) (
          lib.filterAttrs (
            _: drv:
            lib.isDerivation drv
            && builtins.elem (builtins.head (builtins.match "^tree-sitter-(.*)$" drv.pname)) languages
          ) pkgs.tree-sitter-grammars
        );
      };
    in
    {
      parser.source = grammars + "/parser";
      queries.source = grammars + "/queries";
    };

  generateLspRuntime =
    lsps:
    (lib.mapAttrs' (name: config: {
      name = "lsp/${name}.lua";
      value.text = "return ${lib.generators.toLua { } config}";
    }) lsps)
    // {
      "lua/lsp.lua".text = ''
        local M = {}
        function M.setup()
          vim.lsp.enable(${lib.generators.toLua { indent = "  "; } (builtins.attrNames lsps)})
        end
        return M
      '';
    };

  importLuaDir =
    prefix: path:
    lib.pipe (builtins.readDir path) [
      (lib.mapAttrs' (
        name: type: {
          name = "${prefix}/${name}";
          value =
            if type == "regular" && builtins.match "^.*.lua$" name != null then
              { source = path + "/${name}"; }
            else
              null;
        }
      ))
      (lib.filterAttrs (_: value: value != null))
    ];

  generateInitLua =
    runtime: args:
    lib.pipe runtime [
      builtins.attrNames
      (builtins.map (builtins.match "^lua/(.*).lua$"))
      (builtins.filter builtins.isList)
      (builtins.map builtins.head)
      (builtins.map (name: "require('${name}').setup(${lib.generators.toLua { } (args.${name} or { })})"))
      (builtins.concatStringsSep "\n")
    ];
in
{
  programs.neovim = {
    enable = true;

    inherit runtime;
    configure.customLuaRC = initLua;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withRuby = lib.mkDefault false;
    withPython3 = lib.mkDefault false;
    withNodeJs = lib.mkDefault false;

    package = pkgs.neovim-unwrapped.overrideAttrs {
      version = "v0.12.0-dev";
      src = pkgs.fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "e4ce0c7270e52ecaf586a0ddcee262e2f1adaabc";
        hash = "sha256-orLpmRiDOsxYOOm8hYvpy7bgDURC/gzvGgy/hz4aDHs=";
      };
    };
  };
}
