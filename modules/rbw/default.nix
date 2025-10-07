{
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
        settings = {
          email = email;
          pinentry = config.programs.wayprompt.package;
        };
      };
    };
}
