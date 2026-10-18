{
  fetchurl,
  linkFarm,
  writeShellApplication,
}:
let
  version = "2.1.0";
  release = "https://github.com/Dingo-Shenanigans/ReSkate/releases/download/v${version}";

  reskate = linkFarm "reskate-${version}" {
    "ReSkate.dll" = fetchurl {
      url = "${release}/ReSkate.dll";
      hash = "sha256-MQ3vBGg2dy7w3qks/t4Q5ST0t/4wJVtHDoXy3Lq4xSA=";
    };
    "ReSkateLauncher.exe" = fetchurl {
      url = "${release}/ReSkateLauncher.exe";
      hash = "sha256-9d3VNyAEf4iBt2jb47YikrP+XAzdsck4HD5UbtGc2E4=";
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
