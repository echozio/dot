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

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      wiremix
      crosspipe
      coppwr
    ];

    xdg.configFile."wiremix/wiremix.toml".source = pkgs.writers.writeTOML "wiremix.toml" {
      names.endpoint = [ "{node:node.description}" ];
      names.device = [ "{node:node.description}" ];
      filters = [
        { matches = [ { "node.virtual" = "true"; "media.class" = "Stream/Output/Audio"; } ]; }
      ];
    };
  };
}
