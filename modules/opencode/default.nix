{ user, ... }: {
  home-manager.users.${user}.programs.opencode = {
    enable = true;
    settings = {
      autoupdate = false;
      share = "disabled";
      permission."*" = "ask";
      model = "ollama/gpt-oss:20b";
      enabled_providers = [ "ollama" ];
      provider.ollama = {
        name = "Ollama";
        npm = "@ai-sdk/openai-compatible";
        options.baseURL = "http://127.0.0.1:11434/v1";
        models = {
          "qwen3-coder:30b".limit = {
            context = 256 * 1024;
            input = 128 * 1024;
            output = 8 * 1024;
          };
          "gpt-oss:20b" = {
            limit = {
              context = 128 * 1024;
              input = 64 * 1024;
              output = 8 * 1024;
            };
            options.extraBody.think = "high";
          };
          "qwen3.5:27b".limit = {
            context = 256 * 1024;
            input = 128 * 1024;
            output = 8 * 1024;
          };
          "qwen3.6:27b".limit = {
            context = 256 * 1024;
            input = 128 * 1024;
            output = 8 * 1024;
          };
        };
      };
    };
  };
}
