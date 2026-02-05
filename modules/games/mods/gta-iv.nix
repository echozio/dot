{
  lib,
  fetchzip,
  p7zip,
  runCommand,
  symlinkJoin,
  unrar-free,
  writeShellApplication,
  writeText,
}:
let
  fusion-fix = fetchzip {
    url = "https://github.com/ThirteenAG/GTAIV.EFLC.FusionFix/releases/download/v4.0.5/GTAIV.EFLC.FusionFix.zip";
    hash = "sha256-bi6/TteAsIciihzDHbhMt4+RrO1N0Dydd7ZI44xloUM=";
    stripRoot = false;
  };

  radio-restorer-release = fetchzip {
    url = "https://github.com/Tomasak/GTA-Downgraders/releases/download/iv-latest/Radio.Restoration.Mod.23-05-2025.rar";
    hash = "sha256-PpXXootagsYdFMR1EOoRS0PPijNlV6IJeFg1Ae5GLXs=";
    nativeBuildInputs = [ unrar-free ];
    stripRoot = false;
  };

  radio-restorer = runCommand "radio-restorer" {
    buildInputs = [ p7zip ];
  } ''
    mkdir $out && pushd $out
    7z x ${lib.escapeShellArg radio-restorer-release}/"Resources/Radio Restorer/data1.dat" -y
    7z x ${lib.escapeShellArg radio-restorer-release}/"Resources/Radio Restorer/opVANILLA.dat" -y
    7z x ${lib.escapeShellArg radio-restorer-release}/"Resources/Radio Restorer/opSPLITbase.dat" -y
    7z x ${lib.escapeShellArg radio-restorer-release}/"Resources/Radio Restorer/opSPLITVANILLA.dat" -y
  '';

  mods = symlinkJoin {
    name = "gta-iv-mods";
    paths = [
      fusion-fix
      radio-restorer
    ];
  };

  help = writeText "gta-iv-mods-info" ''
    Remember to add to launch options:

    WINEDLLOVERRIDES="dinput8=n,b" %command%
  '';
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
    cp -vriL --no-preserve=mode ${mods}/. .
    cat ${help}
  '';
}
