{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gradle_8,
  jdk17,
  electron,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  gradle = gradle_8.override { java = jdk17; };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "circuitjs1";
  version = "2.2.3-unstable-2026-09-23";

  src = fetchFromGitHub {
    owner = "pfalstad";
    repo = "circuitjs1";
    rev = "5a707168778216bb6ed01bfdd62e8bbf7ae0a032";
    hash = "sha256-ulpVRsgDw7yVngg4fhAsa57yWAl84lkQ/2hxDcY328c=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
    copyDesktopItems
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  patches = [ ./dark-theme.patch ];

  # Launched as `electron <appdir>`, argv[1] is the app directory rather than a file to open.
  postPatch = ''
    substituteInPlace app/main.js --replace-fail \
      "function getFileFromArgv(argv) {
      for (var i = 1;" \
      "function getFileFromArgv(argv) {
      for (var i = process.defaultApp ? 2 : 1;"

    cp ${./dark.css} war/dark.css
  '';

  gradleBuildTask = "compileGwt";

  installPhase = ''
    runHook preInstall

    app=$out/share/circuitjs1
    mkdir -p $app
    cp app/main.js app/preload.js app/renderer.js app/package.json $app
    cp -r war $app/war
    rm -r $app/war/WEB-INF
    cp -r build/gwt/out/circuitjs1 $app/war/circuitjs1

    install -Dm644 war/icon512.png $out/share/icons/hicolor/512x512/apps/circuitjs1.png

    makeWrapper ${lib.getExe electron} $out/bin/circuitjs1 \
      --add-flags $app \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "circuitjs1";
      desktopName = "CircuitJS";
      comment = "Electronic circuit simulator";
      exec = "circuitjs1 %f";
      icon = "circuitjs1";
      categories = [
        "Education"
        "Electronics"
      ];
    })
  ];

  meta = {
    description = "Electronic circuit simulator";
    homepage = "https://www.falstad.com/circuit/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "circuitjs1";
  };
})
