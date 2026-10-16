{ user, mkAgentSandbox, ... }:
{
  home-manager.users.${user} =
    { config, lib, pkgs, ... }:
    let
      ollamaContext = lib.toInt config.services.ollama.environmentVariables.OLLAMA_CONTEXT_LENGTH;
      sandboxContext = pkgs.writeText "opencode-sandbox-context.md" ''
        ## Sandboxed environment

        You are running inside a bubblewrap container. Only the current project
        directory, opencode's own config, data, state and cache directories,
        `/tmp`, and the nix store exist; the rest of the filesystem is absent.
        Network access works and nix builds work through the nix daemon.

        There are no SSH keys or GitHub credentials in this environment, and
        `gh` is not installed. `git push`, `git fetch` and `gh` cannot
        authenticate — do not attempt them and do not spend time diagnosing
        this. Instead, commit your work to a new branch and finish by giving
        the user a copy-pasteable command to run outside the sandbox to push
        and open a PR. Keep every line under typical terminal width (~80
        columns), using backslash continuations — wrapped lines don't copy
        correctly:

            git push -u origin <branch> && \
              gh pr create --head <branch> --title "..." --fill
      '';
    in
    {
      programs.opencode = {
        enable = true;
        package = mkAgentSandbox {
          package = pkgs.opencode;
          homeDirs = [
            ".config/opencode"
            ".local/share/opencode"
            ".local/state/opencode"
            ".cache/opencode"
          ];
          env.OPENCODE_CONFIG_CONTENT = builtins.toJSON {
            instructions = [ "${sandboxContext}" ];
          };
        };
        settings = {
          autoupdate = false;
          share = "disabled";
          permission = {
            "*" = "allow";
            bash = {
              "*" = "allow";
              "git push *" = "deny";
            };
          };
          model = "ollama/qwen3.8:27b";
          enabled_providers = [ "ollama" ];
          provider.ollama = {
            name = "Ollama";
            npm = "@ai-sdk/openai-compatible";
            options.baseURL = "http://127.0.0.1:11434/v1";
            models = {
              "qwen3.8:27b".limit = rec {
                context = ollamaContext;
                output = 8 * 1024;
                input = context - output;
              };
            };
          };
        };
      };
    };
}
