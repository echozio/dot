{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = lib.pipe ./plugins [
    builtins.readDir
    (lib.filterAttrs (name: type: type == "regular"))
    builtins.attrNames
    (builtins.filter (name: !isNull (builtins.match "^.*\.nix$" name)))
    (map (name: ./plugins + "/${name}"))
  ];

  options.programs.neovim = {
    plugins = lib.mkOption {
      type = with lib.types; listOf pathInStore;
    };

    customPlugins = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf str);
    };
  };

  config.programs.neovim = {
    enable = true;

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
        rev = "ea3942f222789c0ad16befc61071f883052d8099";
        hash = "sha256-d5KmAKiqhiXtfQDTzlp0Ci7s0hkX4pfA0KTXora8LEk=";
      };
    };

    configure.packages.plugins.start =
      let
        writeVimPlugin =
          name: files:
          pkgs.vimUtils.toVimPlugin (
            pkgs.symlinkJoin {
              inherit name;
              paths = lib.mapAttrsToList pkgs.writeTextDir files;
            }
          );
      in
      config.programs.neovim.plugins
      ++ (lib.mapAttrsToList writeVimPlugin config.programs.neovim.customPlugins);
  };
}
