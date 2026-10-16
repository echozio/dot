{ pkgs, ... }:
{
  programs.zsh.interactiveShellInit = ''
    diff() {
      if [[ -t 1 ]]; then
        command diff -u "$@" | riff
        return ''${pipestatus[1]}
      else
        command diff "$@"
      fi
    }
  '';

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
      libxml2
      lm_sensors
      nmap
      p7zip
      riffdiff
      scc
      sc-im
      sqlite
      tio
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
