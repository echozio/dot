{
  lib,
  p7zip,
  unrar-free,
  writeShellApplication,
  fetchzip,
}:
let
  fusion-fix = fetchzip {
    url = "https://github.com/ThirteenAG/GTAIV.EFLC.FusionFix/releases/download/v4.0.5/GTAIV.EFLC.FusionFix.zip";
    hash = "sha256-bi6/TteAsIciihzDHbhMt4+RrO1N0Dydd7ZI44xloUM=";
    stripRoot = false;
  };

  radio-restorer = fetchzip {
    url = "https://github.com/Tomasak/GTA-Downgraders/releases/download/iv-latest/Radio.Restoration.Mod.23-05-2025.rar";
    hash = "sha256-PpXXootagsYdFMR1EOoRS0PPijNlV6IJeFg1Ae5GLXs=";
    nativeBuildInputs = [ unrar-free ];
    stripRoot = false;
  };
in
writeShellApplication {
  name = "install-mods-gta-iv";
  runtimeInputs = [
    p7zip
  ];
  text = ''
    out="''${1:-}"
    if [ -z "$out" ]; then
      out="$HOME/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/common/Grand Theft Auto IV/GTAIV"
      printf "Defaulting to: %s\n" "$out" >&2
    fi
    pushd "$out"
    cp -vr --no-preserve=all ${lib.escapeShellArg fusion-fix}/. .
    7z x ${lib.escapeShellArg radio-restorer}/"Resources/Radio Restorer/data1.dat" -y
    7z x ${lib.escapeShellArg radio-restorer}/"Resources/Radio Restorer/opVANILLA.dat" -y
  '';
}
