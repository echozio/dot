{
  lib,
  config,
  pkgs,

  user,
  ...
}:
{
  home-manager.users.${user} =
    let
      cfg = config.home-manager.users.${user}.programs.kubectl;
    in
    {
      options.programs.kubectl.clusters = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              rbwSecret = lib.mkOption {
                type = lib.types.str;
              };

              server = lib.mkOption {
                type = lib.types.str;
              };

              caBase64 = lib.mkOption {
                type = lib.types.str;
              };
            };
          }
        );
      };

      config.programs.kubecolor = {
        enable = true;
        enableAlias = true;
        settings = {
          kubectl = lib.getExe pkgs.kubectl;
          preset = "dark";
          theme.data.string = "green";
        };
      };

      config.home = {
        packages = with pkgs; [
          kubectl
          kubectx
          (writeShellScriptBin "kubectl-reveal" ''
            exec ${lib.getExe yq-go} '.data |= map_values(@base64d)'
          '')
        ];

        file.".kube/config" = {
          force = true;
          mutable = true;
          text = builtins.toJSON {
            apiVersion = "v1";
            kind = "Config";
            current-context = "";
            preferences = { };

            clusters = lib.mapAttrsToList (name: cluster: {
              inherit name;
              cluster = {
                inherit (cluster) server;
                certificate-authority-data = cluster.caBase64;
              };
            }) cfg.clusters;

            contexts = lib.mapAttrsToList (name: cluster: {
              inherit name;
              context = {
                cluster = name;
                user = name;
                namespace = "default";
              };
            }) cfg.clusters;

            users = lib.mapAttrsToList (name: cluster: {
              inherit name;
              user.exec = {
                apiVersion = "client.authentication.k8s.io/v1beta1";
                command = pkgs.writeShellScript "kubectl-credential-helper-${name}" ''
                  set -e -o pipefail
                  token="$(${lib.getExe pkgs.rbw} get "${cluster.rbwSecret}")"
                  expiration="$(date -ud '1 hour' '+%Y-%m-%dT%H:%M:%SZ')"
                  ${lib.getExe pkgs.jq} -n --arg token "$token" --arg expiration "$expiration" '{
                    "apiVersion": "client.authentication.k8s.io/v1beta1",
                    "kind": "ExecCredential",
                    "status": {
                      "token": $token,
                      "expirationTimestamp": $expiration,
                    },
                  }'
                '';
              };
            }) cfg.clusters;
          };
        };
      };
    };
}
