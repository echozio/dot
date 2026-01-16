{
  lib,
  pkgs,

  user,
  email,
  ...
}:
{
  home-manager.users.${user} =
    { config, ... }:
    {
      services.pass-secret-service = {
        enable = true;
        storePath = "${config.xdg.dataHome}/keyrings";
      };

      systemd.user.services.pass-secret-service.Service.ExecStartPre =
        pkgs.writeShellScript "pass-secret-service-init" ''
          storePath=${lib.escapeShellArg config.services.pass-secret-service.storePath}
          mkdir -p "$storePath"
          [ -e "$storePath/.gpg-id" ] \
            || printf "%s\n" ${lib.escapeShellArg email} \
              > "$storePath/.gpg-id"
          exit 0
        '';
    };

  environment.persistence."/fix" = {
    users.${user}.directories = [ ".local/share/keyrings" ];
  };
}
