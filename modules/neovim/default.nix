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
  };

  environment.systemPackages = with pkgs; [
    nixd
  ];
}
