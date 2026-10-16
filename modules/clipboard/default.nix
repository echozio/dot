{ pkgs, user, ... }:
{
  home-manager.users.${user} = {
    home.packages = [ pkgs.wl-clipboard ];

    services.wl-clip-persist = {
      enable = true;
      extraOptions = [
        "--selection-size-limit"
        (toString (128 * 1024 * 1024))
      ];
    };
  };
}
