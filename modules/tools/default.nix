{ pkgs, ... }:
{
  environment = {
    shellAliases = {
      lsusb = "cyme";
    };

    systemPackages = with pkgs; [
      bat
      cyme
      ddrescue
      dig
      file
      inetutils
      lm_sensors
      nmap
      p7zip
      scc
      sc-im
      sqlite
      tree
      unzip
      wdiff
      xxd
      yq-go
      zip
    ];
  };
}
