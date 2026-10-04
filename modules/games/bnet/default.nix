{
  bash,
  bubblewrap,
  cacert,
  coreutils,
  curl,
  dxvk,
  gnugrep,
  lib,
  makeDesktopItem,
  pkgsCross,
  symlinkJoin,
  wine,
  wineWow64Packages,
  writeShellApplication,
}:

let
  winePkg = wineWow64Packages.stagingFull;

  vkd3dProton =
    (pkgsCross.mingwW64.vkd3d-proton.override { inherit wine; }).overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        pkgsCross.mingwW64.windows.pthreads
      ];
      meta = old.meta // { platforms = lib.platforms.windows; };
    });

  inner = writeShellApplication {
    name = "bnet-inner";
    runtimeInputs = [ winePkg curl coreutils bash gnugrep ];
    text = ''
      export WINEPREFIX="$HOME/prefix"
      export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

      if [ ! -e "$WINEPREFIX/.setup-done" ]; then
        echo "Initializing wineprefix" >&2
        wineboot -u
        wineserver -w

        echo "Downloading Battle.net installer" >&2
        curl -Lo /tmp/Battle.net-Setup.exe \
          'https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe'
        wine /tmp/Battle.net-Setup.exe
        wineserver -w

        touch "$WINEPREFIX/.setup-done"
      fi

      # Nix store mtimes are all 1, so wine's own wine.inf timestamp check never
      # notices a new wine; track the store path instead.
      if [ "$(cat "$WINEPREFIX/.wine-version" 2>/dev/null)" != "${winePkg}" ]; then
        echo "Updating wineprefix for ${winePkg}" >&2
        wineboot -u
        wineserver -w
        echo "${winePkg}" > "$WINEPREFIX/.wine-version"
      fi

      ln -sf ${dxvk.dxvk64}/bin/*.dll ${vkd3dProton}/bin/*.dll "$WINEPREFIX/drive_c/windows/system32/"
      ln -sf ${dxvk.dxvk32}/bin/*.dll "$WINEPREFIX/drive_c/windows/syswow64/"
      for dll in d3d8 d3d9 d3d10core d3d11 d3d12 d3d12core dxgi; do
        wine reg add 'HKCU\Software\Wine\DllOverrides' /v "$dll" /d native /f
      done

      wine reg add 'HKCU\Software\Wine\Explorer' /v ShowSystray /t REG_DWORD /d 0 /f

      wine "$WINEPREFIX/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe" "$@"
      exec wineserver -w
    '';
  };

  launcher = writeShellApplication {
    name = "bnet";
    runtimeInputs = [ bubblewrap coreutils ];
    text = ''
      data="''${XDG_DATA_HOME:-$HOME/.local/share}/bnet"
      mkdir -p "$data"
      run="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

      args=(
        --unshare-all --share-net
        --die-with-parent
        --proc /proc
        --dev /dev
        --tmpfs /tmp
        --ro-bind /nix /nix
        --ro-bind /sys /sys
        --dev-bind /dev/dri /dev/dri
        --ro-bind /etc/resolv.conf /etc/resolv.conf
        --ro-bind-try /etc/ssl /etc/ssl
        --ro-bind-try /etc/pki /etc/pki
        --ro-bind-try /etc/static /etc/static
        --ro-bind-try /etc/hosts /etc/hosts
        --ro-bind-try /etc/localtime /etc/localtime
        --ro-bind-try /etc/fonts /etc/fonts
        --ro-bind-try /etc/machine-id /etc/machine-id
        --ro-bind-try /run/opengl-driver /run/opengl-driver
        --ro-bind-try /run/opengl-driver-32 /run/opengl-driver-32
        --bind "$data" "$HOME"
        --dir "$run"
        --setenv XDG_RUNTIME_DIR "$run"
      )

      if [ -n "''${DISPLAY:-}" ]; then
        args+=( --ro-bind-try /tmp/.X11-unix /tmp/.X11-unix --setenv DISPLAY "$DISPLAY" )
        if [ -n "''${XAUTHORITY:-}" ]; then
          args+=( --ro-bind-try "$XAUTHORITY" "$XAUTHORITY" --setenv XAUTHORITY "$XAUTHORITY" )
        fi
      fi

      if [ -n "''${WAYLAND_DISPLAY:-}" ] && [ -e "$run/$WAYLAND_DISPLAY" ]; then
        args+=( --bind "$run/$WAYLAND_DISPLAY" "$run/$WAYLAND_DISPLAY" \
                --setenv WAYLAND_DISPLAY "$WAYLAND_DISPLAY" )
      fi

      for sock in pulse/native pipewire-0; do
        if [ -e "$run/$sock" ]; then
          args+=( --bind "$run/$sock" "$run/$sock" )
        fi
      done

      exec bwrap "''${args[@]}" ${inner}/bin/bnet-inner "$@"
    '';
  };

  desktopItem = makeDesktopItem {
    name = "bnet";
    desktopName = "Battle.net";
    comment = "Battle.net launcher";
    exec = "${launcher}/bin/bnet";
    icon = "${./icon.svg}";
    categories = [ "Game" ];
    startupWMClass = "battle.net.exe";
  };
in
symlinkJoin {
  name = "bnet";
  paths = [ launcher desktopItem ];
}
