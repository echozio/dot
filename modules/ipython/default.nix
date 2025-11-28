{ pkgs, ... }:
{
  environment = {
    systemPackages = [ pkgs.python3Packages.ipython ];

    etc."ipython/ipython_config.py".source = ./config.py;

    shellAliases.ipy = "ipython";
  };
}
