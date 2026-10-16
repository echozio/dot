{
  pkgs,
  style,
  user,
  ...
}:
let
  inherit (pkgs) signal-desktop;

  css = pkgs.writeText "signal-custom.css" ''
    :root {
      --axo-color-surface-primary: transparent;
      --axo-color-surface-secondary: transparent;
    }

    html {
      background: ${style.colors.bg.rgba};
    }

    .module-composition-input__input,
    .module-message__container--incoming {
      background: var(--axo-color-fill-primary) !important;
    }

    .module-message__container--outgoing {
      background: var(--axo-color-fill-primary-pressed) !important;
    }
  '';

  signal =
    pkgs.runCommand "signal-desktop-${signal-desktop.version}"
      {
        nativeBuildInputs = [ pkgs.asar ];
        inherit (signal-desktop) meta;
      }
      ''
        cp -rs --no-preserve=mode ${signal-desktop} $out
        rm -r $out/bin $out/share/signal-desktop/app.asar $out/share/signal-desktop/app.asar.unpacked

        asar extract ${signal-desktop}/share/signal-desktop/app.asar app
        cp ${css} app/stylesheets/custom.css
        substituteInPlace app/background.html --replace-fail \
          '<link href="stylesheets/tailwind.css" rel="stylesheet" type="text/css" />' \
          '<link href="stylesheets/tailwind.css" rel="stylesheet" type="text/css" />
            <link href="stylesheets/custom.css" rel="stylesheet" type="text/css" />'

        # The main window is the only BrowserWindow created with sandbox:false.
        sed -i 's/backgroundColor:[A-Za-z0-9_$]*,\(webPreferences:{[^}]*sandbox:!1\)/transparent:!0,backgroundColor:`#00000000`,\1/' \
          app/bundles/main.js
        [ "$(grep -o 'transparent:!0,backgroundColor:`#00000000`' app/bundles/main.js | wc -l)" = 1 ]

        asar pack --unpack '*.node' app $out/share/signal-desktop/app.asar

        mkdir $out/bin
        substitute ${signal-desktop}/bin/signal-desktop $out/bin/signal-desktop \
          --replace-fail ${signal-desktop}/share $out/share \
          --replace-fail '"$@"' '--password-store=gnome-libsecret "$@"'
        chmod +x $out/bin/signal-desktop
      '';
in
{
  home-manager.users.${user}.home.packages = [ signal ];

  environment.persistence."/fix".users.${user}.directories = [ ".config/Signal" ];
}
