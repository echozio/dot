{
  lib,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure.customLuaRC = builtins.readFile ./neovim.lua;
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

  environment.systemPackages = with pkgs; [
    nixd
    gopls
    typescript-language-server
  ];
}
