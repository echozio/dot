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
      exiftool
      file
      google-cloud-sdk
      inetutils
      jq
      lm_sensors
      nmap
      p7zip
      riffdiff
      scc
      sc-im
      sqlite
      tree
      unzip
      vulkan-tools
      wdiff
      xxd
      yq-go
      yt-dlp
      zip
      zx
    ];
  };
}
