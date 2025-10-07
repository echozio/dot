{
  lib,
  pkgs,
  ...
}:
{
  config = {
    users = {
      defaultUserShell = pkgs.zsh;
      users.root.shell = pkgs.zsh;
    };

    environment.systemPackages = [ pkgs.fzf ];

    programs = {
      # Use this and remove other fzf-related config if this is made to work together with
      # zsh-vi-mode (currently breaks ^r binding):
      # fzf.keybindings = true;
      # fzf.fuzzyCompletion = true;
      git.enable = true;
      direnv.enable = true;
    };

    programs.zsh = {
      enable = true;

      shellInit = ''
        # Silence new user configuration prompt
        zsh-newuser-install() { :; }
      '';

      interactiveShellInit = ''
        zvm_after_init() {
          source <(fzf --zsh)
        }
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=200
        ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c200,)"
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      '';

      promptInit = ''
        source ${pkgs.liquidprompt}/bin/liquidprompt
      '';
    };

    environment.etc."liquidpromptrc".source = ./liquidpromptrc;

    home-manager.sharedModules = lib.singleton {
      programs.zsh.enable = true;
    };
  };
}
