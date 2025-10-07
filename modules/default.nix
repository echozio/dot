{
  lib,
  config,
  ...
}:
{
  imports = lib.mapAttrsToList (path: _: ./. + "/${path}") (
    lib.filterAttrs (path: type: type == "directory") (builtins.readDir ./.)
  );

  system.stateVersion = lib.mkDefault "25.05";

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "@wheel" ];
  };

  users.mutableUsers = false;

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
