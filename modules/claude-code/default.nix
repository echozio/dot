{ user, ... }:
{
  environment.persistence."/fix".users.${user} = {
    directories = [ ".claude" ];
    files = [ ".claude.json" ];
  };

  home-manager.users.${user} = {
    nixpkgs.config.allowUnfree = true;

    programs.claude-code = {
      enable = true;
      settings = {
        permissions = {
          allow = [
            "Read(//nix/store*)"
          ];
        };
        sandbox = {
          enabled = true;
          filesystem = {
            denyRead = [ "/" ];
            allowRead = [ "/nix/store" ];
          };
        };
      };
      mcpServers.agentgateway = {
        type = "http";
        url = "https://mcp.stafftastic.com/mcp/http";
      };
    };

    home.file.".claude/settings.json" = {
      mutable = true;
      force = true;
    };
  };
}
