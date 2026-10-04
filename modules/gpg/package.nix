{
  lib,
  stdenv,
  rustc,
  rbw,
  pinentry-fuzzel,
  pinentry-tty,
  entry ? "gpg",
}:
stdenv.mkDerivation {
  pname = "pinentry-rbw";
  version = "0.1.0";

  dontUnpack = true;

  nativeBuildInputs = [ rustc ];

  env = {
    RBW = lib.getExe rbw;
    RBW_ENTRY = entry;
    FALLBACK_GUI = lib.getExe pinentry-fuzzel;
    FALLBACK_TTY = lib.getExe pinentry-tty;
  };

  buildPhase = ''
    runHook preBuild
    rustc --edition=2021 -O -o pinentry-rbw ${./pinentry-rbw.rs}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 pinentry-rbw $out/bin/pinentry-rbw
    runHook postInstall
  '';

  meta.mainProgram = "pinentry-rbw";
}
