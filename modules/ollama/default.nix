{ user, pkgs, ... }: {
  home-manager.users.${user}.services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = toString (256 * 1024);
      OLLAMA_KEEP_ALIVE = "150";
    };
  };

  environment.persistence."/fix".users.${user}.directories = [ ".ollama/models" ];
}
