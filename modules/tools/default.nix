{ pkgs, ... }:
{
  environment = {
    shellAliases = {
      lsusb = "cyme";
      watch = "hwatch";
    };

    sessionVariables = {
      LESS = "FR";
      SYSTEMD_LESS = "FRMK";
    };

    systemPackages = with pkgs; [
      bat
      cyme
      d2
      ddrescue
      dig
      exiftool
      file
      google-cloud-sdk
      hwatch
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
