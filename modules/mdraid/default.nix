{ pkgs, ... }:
{
  boot.swraid = {
    enable = true;

    # Silence warning.
    # This is only here for reading external drives anyway.
    mdadmConf = ''
      PROGRAM ${pkgs.coreutils}/bin/true
    '';
  };
}
