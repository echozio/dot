{
  pkgs,
  style,
  user,
  ...
}:
{
  _module.args.pinentry-fuzzel = pkgs.callPackage ./package.nix {
    mesgColor = style.colors.fg.hexRgba;
    mesgErrorColor = style.colors.red.hexRgba;
    fuzzelArgs = with style; [
      "--config=/dev/null"
      "--namespace=pinentry"
      "--font=${fonts.mono.family}:size=12"
      "--background-color=${colors.bg.hexRgba}"
      "--text-color=${colors.fg.hexRgba}"
      "--input-color=${colors.lo.hexRgba}"
      "--width=60"
      "--horizontal-pad=40"
      "--vertical-pad=40"
      "--border-width=0"
      "--border-radius=10"
    ];
  };

  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.layer_rule = [
      {
        match.namespace = "pinentry";
        blur = true;
        ignore_alpha = 0.19;
        dim_around = true;
      }
    ];
  };
}
