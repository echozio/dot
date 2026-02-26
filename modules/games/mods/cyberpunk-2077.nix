{
  fetchzip,
  symlinkJoin,
  writeShellApplication,
  writeText,
  writeTextDir,
}:
let
  mods = symlinkJoin {
    name = "cyberpunk-2077-mods";
    paths = [
      (fetchzip {
        url = "https://github.com/jackhumbert/let_there_be_flight/releases/download/v0.3.17/let_there_be_flight_v0.3.17.zip";
        hash = "sha256-FJt67+GvHHuUnqFCriHcCmR1FmuhOks0/q+NX/5NMEo=";
        stripRoot = false;
      })
      (fetchzip {
        url = "https://github.com/psiberx/cp2077-archive-xl/releases/download/v1.26.2/ArchiveXL-1.26.2.zip";
        hash = "sha256-Wv1neeovyRULJDb3RotTp9G7IbRfOrlapGfpsUVOgyk=";
        stripRoot = false;
      })
      (fetchzip {
        url = "https://github.com/psiberx/cp2077-tweak-xl/releases/download/v1.11.3/TweakXL-1.11.3.zip";
        hash = "sha256-QotqOBPoro1DHa6cL+NDYpoiXduXltAoEl0utIGNlDc=";
        stripRoot = false;
      })
      (fetchzip {
        url = "https://github.com/jackhumbert/cyberpunk2077-input-loader/releases/download/v0.2.3/input_loader_v0.2.3.zip";
        hash = "sha256-DQxXWxam7OsUqjxPUCBaepiyRqMkpjr+L5mJEJNeW2Y=";
        stripRoot = false;
      })
      (fetchzip {
        url = "https://github.com/jac3km4/redscript/releases/download/v0.5.31/redscript-v0.5.31-windows.zip";
        hash = "sha256-IJySRAtmY685XAe3amDLgcrQjiSe6OIKPi5hyOGnBw4=";
        stripRoot = false;
      })
      (fetchzip {
        url = "https://github.com/jackhumbert/mod_settings/releases/download/v0.2.21/mod_settings_v0.2.21.zip";
        hash = "sha256-8uhdgPEJtcwt3ow0/9CXqvv5ikqbzvs37CRsAbVFpj0=";
        stripRoot = false;
      })
      (fetchzip {
        url = "https://github.com/wopss/RED4ext/releases/download/v1.29.1/red4ext_1.29.1.zip";
        hash = "sha256-O2x0STCR8pe8hg3YkLm8b1/j3RZXppfBljX5xYhPcbY=";
        stripRoot = false;
      })
      (fetchzip {
        url = "https://github.com/maximegmd/CyberEngineTweaks/releases/download/v1.37.1/cet_1.37.1.zip";
        hash = "sha256-thf/UU3sLlYO/yBYgRk97j6LGosICHoV/Jgqs9KnqgQ=";
        stripRoot = false;
      })
      (fetchzip {
        url = "https://github.com/jackhumbert/in_world_navigation/releases/download/v0.1.20/in_world_navigation_v0.1.20.zip";
        hash = "sha256-LD3MAENqkP6GHk3eYjGnEkzFlqPePE80X76QN4fspR8=";
        stripRoot = false;
      })
      (writeTextDir "/bin/x64/plugins/cyber_engine_tweaks/mods/utils/init.lua" (
        builtins.readFile ./cyberpunk-2077-utils.lua
      ))
    ];
  };

  settings = writeText "cyberpunk-2077-mod-settings.json" (
    builtins.toJSON {
      InWorldNavigation = {
        enabled = true;
        mode = "Driving";
        distanceToFade = 100.0;
        spacing = 10.0;
        maxPoints = 200;
      };
      FlightModeHoverFly = {
        enabled = true;
        heightDampening = 1.0;
        heightCorrectionFactor = 1.0;
      };
      FlightModeStandard = {
        standardModeYawFactor = 1.0;
        standardModeSurgeFactor = 15.0;
        standardModePitchInputAngle = 10.0;
        standardModeRollInputAngle = 30.0;
        standardModeSwayFactor = 45.0;
        standardModeHoverFactor = 10.0;
        standardModeRollFactor = 2.0;
        standardModeLiftFactor = 50.0;
        standardModePitchFactor = 0.5;
      };
      FlightSettings = {
        autoActivationEnabled = false;
        drivingDirectionCompensationAngleSmooth = 120.0;
        drivingDirectionCompensationSpeedCoef = 0.1;
        tppCameraCenterOnMass = true;
        fpvCameraPitchOffset = 0.0;
        tppCameraPitchOffset = 20.0;
        generalYawDirectionalityFactor = 5.0;
        generalPitchDirectionalityFactor = 15.0;
        generalYawAeroFactor = 0.0;
        generalDampFactorAngularMax = 3.5;
        generalDampFactorLinear = 0.0;
        generalPitchAeroFactor = 0.0;
        generalApplyFlightPhysicsWhenDeactivated = false;
        generalDampFactorAngular = 2.0;
        brakeFactorAngular = 1.0;
        brakeFactorLinear = 1.0;
      };
      FlightAudio = {
        windVolume = 1.0;
        engineVolume = 0.5;
        warningVolume = 0.5;
      };
      FlightComponent = {
        isQuickHackable = true;
        explosionThreshold = 0.5;
      };
      FlightController = {
        vehicleFlight = "IK_B";

        vehicleFlightYawRight = "IK_D";
        vehicleFlightRollRight = "IK_D";
        vehicleFlightSwayRight = "IK_D";

        vehicleFlightYawLeft = "IK_A";
        vehicleFlightRollLeft = "IK_A";
        vehicleFlightSwayLeft = "IK_A";

        vehicleFlightPitchForward = "IK_W";
        vehicleFlightPitchBackward = "IK_S";

        vehicleFlightLinearBrake = "IK_Space";
        vehicleFlightAngularBrake = "IK_Space";

        vehicleFlightLiftUp = "IK_LShift";
        vehicleFlightLiftDown = "IK_LControl";

        vehicleFlightModeSwitchForward = "IK_None";
        vehicleFlightModeSwitchBackward = "IK_None";
        vehicleFlightOptions = "IK_None";
        vehicleFlightUIToggle = "IK_None";
      };
      FlightModeAutomatic.enabled = false;
      FlightModeDroneAntiGravity.agEnabled = false;
      FlightModeFly.enabled = false;
      FlightModeDrone.enabled = false;
      FlightModeHover.enabled = false;
      IFlightConfiguration.areThrustersDetachable = true;
      hudFlightController.enabled = true;
    }
  );

  cetConfig = writeText "cyberpunk-2077-cet-config.json" (
    builtins.toJSON {
      patches.disable_boundary_teleport = true;
    }
  );

  cetBindings = writeText "cyberpunk-2077-cet-config.json" (
    builtins.toJSON {
      cet.overlay_key = 2251838468390912; # Backspace+Tab
    }
  );

  help = writeText "cyberpunk-2077-mod-info" ''
    Remember to add to launch options:

    WINEDLLOVERRIDES="winmm,version=n,b" %command% -modded --launcher-skip -skipStartScreen
  '';
in
writeShellApplication {
  name = "install-mods-cyberpunk-2077";
  text = ''
    out="''${1:-}"
    if [ -z "$out" ]; then
      out="$HOME/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/common/Cyberpunk 2077"
      printf "Defaulting to: %s\n" "$out" >&2
    fi
    pushd "$out"
    cp -vrL --no-preserve=mode ${mods}/. .

    settings="$out/red4ext/plugins/mod_settings/user.ini"
    if [ ! -f "$settings" ]; then
      touch "$settings"
    fi
    yq -io=i '. *= load("${settings}")' "$settings"

    cetConfig="$out/bin/x64/plugins/cyber_engine_tweaks/config.json"
    if [ ! -f "$cetConfig" ]; then
      touch "$cetConfig"
    fi
    yq -io=j '. *= load("${cetConfig}")' "$cetConfig"

    cetBindings="$out/bin/x64/plugins/cyber_engine_tweaks/bindings.json"
    if [ ! -f "$cetBindings" ]; then
      touch "$cetBindings"
    fi
    yq -io=j '. *= load("${cetBindings}")' "$cetBindings"

    flatpak run com.github.Matoking.protontricks 1091500 -q d3dcompiler_47 vcrun2022

    cat ${help}
  '';
}
