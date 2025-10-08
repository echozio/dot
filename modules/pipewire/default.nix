{ pkgs, user, ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  home-manager.users.${user}.home.packages = [
    pkgs.pulsemixer
    pkgs.helvum
  ];
}
