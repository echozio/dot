{
  lib,
  pkgs,

  user,

  mkNixPak,
  ...
}:
{
  home-manager.users.${user}.programs.aerc.extraConfig.filters = {
    "text/plain" = "colorize";
    "text/calendar" = "calendar";
    "message/rfc822" = "colorize";
    "message/delivery-status" = "colorize";
    ".headers" = "colorize";

    "text/html" = builtins.toString (
      lib.getExe
        (mkNixPak {
          config.app.package = pkgs.writeShellScriptBin "w3m-html-filter" ''
            export LC_ALL=C.UTF-8
            exec ${lib.getExe pkgs.w3m} -dump -T text/html -no-cookie -config /dev/null \
              | ${lib.getExe pkgs.perl} -CS -ne 's/[\p{M}\p{Cf}]//g; s/[ \t\p{Zs}]+$//; print unless /^[ \t\p{Zs}]*$/ && $p; $p=/^[ \t\p{Zs}]*$/;'
          '';
          config.dbus.enable = false;
          config.bubblewrap.network = false;
          config.bubblewrap.bindEntireStore = false;
        }).config.script
    );

    "application/pdf" = builtins.toString (
      lib.getExe
        (mkNixPak {
          config.app.package = pkgs.writeShellScriptBin "w3m-pdf-filter" ''
            exec ${pkgs.poppler-utils}/bin/pdftotext -layout - -
          '';
          config.dbus.enable = false;
          config.bubblewrap.network = false;
          config.bubblewrap.bindEntireStore = false;
        }).config.script
    );

    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = builtins.toString (
      lib.getExe
        (mkNixPak {
          config.app.package = pkgs.writeShellScriptBin "w3m-pdf-filter" ''
            exec ${lib.getExe pkgs.pandoc} -f docx -t plain
          '';
          config.dbus.enable = false;
          config.bubblewrap.network = false;
          config.bubblewrap.bindEntireStore = false;
        }).config.script
    );
  };
}
