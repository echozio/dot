{
  lib,
  pkgs,

  pinentry-fuzzel,
  user,
  email,
  ...
}:
{
  environment.persistence."/fix".users.${user} = {
    files = [
      {
        file = ".local/share/rbw/device_id";
        parentDirectory.mode = "0700";
      }
    ];
    directories = [
      {
        directory = ".cache/rbw";
        mode = "0700";
      }
    ];
  };

  home-manager.users.${user} =
    { config, ... }:
    {
      home.sessionVariables = {
        SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/rbw/ssh-agent-socket";
      };

      programs.rbw = {
        enable = true;
        # rbw with a working ssh-rsa (SHA-1) signing path, for prehistoric
        # sshds (JunOS 12.3 / OpenSSH 6.0 and friends).
        #
        # Two fixes:
        #  1. rbw signs the flags=0 case with new_unprefixed, omitting the
        #     PKCS#1 v1.5 DigestInfo prefix that RFC 4253 ssh-rsa signatures
        #     require. new() needs the sha1 crate's "oid" feature for
        #     AssociatedOid.
        #  2. ssh-key 0.6.7's Signature::new refuses
        #     Algorithm::Rsa { hash: None } entirely (falls through to
        #     Err(Length)); every constructor funnels through it, and
        #     Algorithm::Other only takes name@domain labels, so the only way
        #     out is relaxing the vendored crate's match arm — the same change
        #     upstream made on master.
        package = pkgs.rbw.overrideAttrs (old: {
          postPatch =
            (old.postPatch or "")
            + ''
              substituteInPlace Cargo.toml \
                --replace-fail \
                  'sha1 = "0.10.6"' \
                  'sha1 = { version = "0.10.6", features = ["oid"] }'

              substituteInPlace src/bin/rbw-agent/ssh_agent.rs \
                --replace-fail \
                  'rsa::pkcs1v15::SigningKey::<sha1::Sha1>::new_unprefixed(rsa_key)' \
                  'rsa::pkcs1v15::SigningKey::<sha1::Sha1>::new(rsa_key)'

              substituteInPlace \
                "$(find /build -path '*/ssh-key-0.6.7/src/signature.rs')" \
                --replace-fail \
                  'Algorithm::Rsa { hash: Some(_) } => (),' \
                  'Algorithm::Rsa { .. } => (),'
            '';
        });
        settings = {
          email = email;
          # rbw-agent spawns this with the calling client's WAYLAND_DISPLAY,
          # which can name a socket that no longer exists.
          pinentry = pkgs.writeShellScriptBin "rbw-pinentry-wrapper" ''
            case "$WAYLAND_DISPLAY" in
              "") sock="" ;;
              /*) sock="$WAYLAND_DISPLAY" ;;
              *) sock="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/$WAYLAND_DISPLAY" ;;
            esac
            if [ -n "$sock" ] && [ -S "$sock" ]; then
              exec ${lib.getExe pinentry-fuzzel} "$@"
            else
              exec ${lib.getExe pkgs.pinentry-tty} "$@"
            fi
          '';
        };
      };
    };
}
