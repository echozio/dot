{
  fetchurl,
  linkFarm,
  writeShellApplication,
}:
let
  version = "2.0.8";
  release = "https://github.com/Dingo-Shenanigans/ReSkate/releases/download/v${version}";

  reskate = linkFarm "reskate-${version}" {
    "ReSkate.dll" = fetchurl {
      url = "${release}/ReSkate.dll";
      hash = "sha256-7yN+E7LFreTiSnu914JGgMt5/WvfjRwTNAoNN13dL9o=";
    };
    "ReSkateLauncher.exe" = fetchurl {
      url = "${release}/ReSkateLauncher.exe";
      hash = "sha256-n8dDkh89UjWv52hrftXExzeHUjcKQpN8UPl6Dg3RcFE=";
    };
  };
in
writeShellApplication {
  name = "install-reskate";
  text = ''
    out="''${1:-}"
    if [ -z "$out" ]; then
      out="$HOME/.var/app/com.valvesoftware.Steam/.local/share/ReSkate"
      printf "Defaulting to: %s\n" "$out" >&2
    fi

    # The launcher refuses to run from anywhere under steamapps/common.
    out="$(realpath -m "$out")"
    mkdir -p "$out"
    cp -vL --no-preserve=mode ${reskate}/* "$out/"

    cat <<EOF

    Remember to set launch options:

    bash -c 'exec "\''${@/*EAAntiCheat.GameServiceLauncher.exe/$out/ReSkateLauncher.exe}"' -- %command%
    EOF
  '';
}
