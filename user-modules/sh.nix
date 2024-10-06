{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    eza
  ];

  programs.zsh = {
    enable = true;

    defaultKeymap = "viins";
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      ignoreAllDups = true;
      share = false; # do not share history between zsh sessions
      extended = true; # save timestamps
      save = 1000;
      size = 1000;
      path = "$HOME/.cache/zsh_history";
    };
    
    shellAliases = {
      ls = "eza --icons";
      la = "ls -a";
      ll = "ls -lah";
      tree = "eza --tree --icons";
      mkdir = "mkdir --verbose --parents";
      grep = "grep --color=auto";
      ip = "ip -color=auto";
    };

    initExtra = ''
      # accept autosuggestions with Ctrl+Y
      bindkey '^Y' autosuggest-accept
    '';
  };

  programs.starship = {
    enable = true;

    # enableZshIntegration = true;

    settings = {
      add_newline = true;
      right_format = "$cmd_duration";
    };
  };
}
