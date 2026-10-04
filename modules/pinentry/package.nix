{
  lib,
  stdenv,
  rustc,
  fuzzel,
  fuzzelArgs ? [ ],
  mesgColor,
  mesgErrorColor,
}:
stdenv.mkDerivation {
  pname = "pinentry-fuzzel";
  version = "0.1.0";

  dontUnpack = true;

  nativeBuildInputs = [ rustc ];

  env = {
    FUZZEL = lib.getExe fuzzel;
    FUZZEL_ARGS = lib.concatStringsSep "\n" fuzzelArgs;
    MESG_COLOR = mesgColor;
    MESG_ERROR_COLOR = mesgErrorColor;
  };

  buildPhase = ''
    runHook preBuild
    rustc --edition=2021 -O -o pinentry-fuzzel ${./pinentry-fuzzel.rs}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 pinentry-fuzzel $out/bin/pinentry-fuzzel
    runHook postInstall
  '';

  meta.mainProgram = "pinentry-fuzzel";
}
