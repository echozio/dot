{ pkgs, ... }:
{
  environment = {
    shellAliases = {
      lsusb = "cyme";
    };

    systemPackages = with pkgs; [
      cyme
      ddrescue
      dig
      file
      inetutils
      p7zip
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
