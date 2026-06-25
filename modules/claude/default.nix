{ user, ... }:
{
  environment.persistence."/fix".users.${user} = {
    directories = [ ".claude" ];
    files = [ ".claude.json" ];
  };

  home-manager.users.${user} =
    { config, ... }:
    {
      nixpkgs.config.allowUnfree = true;

      programs.claude-code = {
        enable = true;
        context = ''
          ## Git workflow

          Always create a feature branch for any code change — never commit directly to the default branch.

          When merging a PR: squash merge, then delete both the remote and local branch.

          Don't add a PR body unless the change genuinely warrants explanation beyond the title.
        '';
        settings = {
          permissions = {
            allow = [
              "Read(//nix/store/*)"
            ];
          };
          sandbox = {
            enabled = true;
            excludedCommands = [
              "nix *"
              "gh *"
              "git push"
              "git push *"
              "git pull"
              "git pull *"
              "git commit *"
              "git fetch"
              "git fetch *"
            ];
            filesystem = {
              denyRead = [ "/" ];
              allowRead = [
                "/nix"
                "/run/current-system"
              ];
            };
          };
          effortLevel = "medium";
          model = "opusplan";
        };
        mcpServers.agentgateway = {
          type = "http";
          url = "https://mcp.stafftastic.com/mcp/http";
        };
      };

      home.file."${config.programs.claude-code.configDir}/settings.json" = {
        mutable = true;
        force = true;
      };
    };
}
