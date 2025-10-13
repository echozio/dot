{
  user,
  ...
}:
{
  home-manager.users.${user}.programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  environment.persistence."/fix".users.${user}.files = [
    {
      file = ".config/gh/hosts.yml";
      parentDirectory.mode = "0700";
    }
  ];
}
