{ pkgs, user, ... }:
{
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
      obs-vkcapture
    ];
  };

  environment.persistence."/fix".users.${user}.directories = [ ".config/obs-studio" ];
}
