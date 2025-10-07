{
  lib,
  pkgs,

  user,
  ...
}:
{
  home-manager.users.${user} =
    { config, ... }:
    {
      systemd.user.services = {
        ${config.services.syncthing.tray.package.pname}.Unit.Requires = [ "syncthingtray-init.service" ];
        syncthingtray-init = {
          Unit = {
            Description = "Generate syncthingtray config";
            After = [
              "syncthing.service"
              "graphical-session.target"
            ];
            Requires = [ "syncthing.service" ];
            Before = [ "${config.services.syncthing.tray.package.pname}.service" ];
            PartOf = [ "graphical-session.target" ];
          };

          Install.WantedBy = [ "default.target" ];

          Service = {
            Type = "oneshot";
            RuntimeDirectory = "syncthingtray-init";
            RemainAfterExit = true;
            ExecStart = pkgs.writeShellScript "syncthingtray-init" ''
              while
                ! ${pkgs.libxml2}/bin/xmllint \
                  --xpath 'string(configuration/gui/apikey)' \
                  "''${XDG_STATE_HOME:-$HOME/.local/state}/syncthing/config.xml" \
                  >"$RUNTIME_DIRECTORY/api_key"
              do ${lib.getExe' pkgs.coreutils "sleep"} 1; done
              cat >"''${XDG_CONFIG_HOME:-$HOME/.config}/syncthingtray.ini" <<EOF
              [General]
              v=${config.services.syncthing.tray.package.version}

              [tray]
              connections\\1\\apiKey=@ByteArray($(cat "$RUNTIME_DIRECTORY/api_key"))
              connections\\1\\syncthingUrl=http://127.0.0.1:8384
              connections\\1\\authEnabled=false
              connections\\1\\autoConnect=true
              connections\\1\\httpsCertPath=''${XDG_STATE_HOME:-$HOME/.local/state}/syncthing/https-cert.pem
              connections\\1\\label=localhost
              connections\size=1
              EOF
            '';
          };
        };
      };
    };
}
