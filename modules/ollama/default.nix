{ user, pkgs, ... }: {
  home-manager.users.${user}.services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = toString (64 * 1024);
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q5_0";
      VK_LOADER_LAYERS_DISABLE = "~implicit~";
      OLLAMA_KEEP_ALIVE = "150";
    };
  };

  environment.persistence."/fix".users.${user}.directories = [ ".ollama/models" ];
}
