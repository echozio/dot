{ user, ... }:
{
  services.flatpak.enable = true;

  environment.persistence."/fix" = {
    directories = [ "/var/lib/flatpak" ];
    users.${user}.directories = [
      ".local/share/flatpak"
      ".var/app"
    ];
  };
}
