{
  lib,
  fetchzip,
  symlinkJoin,
  writeShellApplication,
  writeText,
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
        hash = "sha256-8uhdgPEJtcwt3ow0/9CXqvv5ikqbzvs37CRsAbVFpj0=";
        stripRoot = false;
      })
      (fetchzip {
        url = "https://github.com/jac3km4/redscript/releases/download/v0.5.31/redscript-v0.5.31-windows.zip";
        hash = "sha256-8uhdgPEJtcwt3ow0/9CXqvv5ikqbzvs37CRsAbVFpj0=";
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
    ];
  };
  help = writeText "cyberpunk-2077-info" ''
    Remember to add to launch options:

    WINEDLLOVERRIDES="winmm,version=n,b" %command%
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
    cp -vriL --no-preserve=mode ${mods}/. .
    cat ${help}
  '';
}
