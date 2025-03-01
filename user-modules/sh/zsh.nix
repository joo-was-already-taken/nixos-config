{ pkgs, lib, config, sessionVariables, ... }:
let
  moduleName = "zsh";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = with pkgs; [
      zsh-fzf-tab
      eza
      sl
    ];

    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        add_newline = true;
        right_format = "$cmd_duration";
        battery.disabled = true;
        nix_shell = { # remove 'impure' clatter and additional spaces
          format = ''via [$symbol$state(\($name\))]($style) '';
          symbol = "❄️";
          impure_msg = "";
        };
      };
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.zsh = {
      enable = true;

      defaultKeymap = "viins";
      enableCompletion = false; # let zsh-fzf-tab take care of it
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = rec {
        ignoreAllDups = true;
        share = false; # share history between zsh sessions
        extended = true; # save timestamps
        size = 5000;
        save = size;
        path = "$HOME/.cache/zsh_history";
      };

      inherit sessionVariables;

      shellAliases = {
        ls = "eza --icons";
        la = "ls -a";
        ll = "ls -lah";
        tree = "eza --tree --icons";
        mkdir = "mkdir --verbose --parents";
        grep = "grep --color=auto";
        ip = "ip -color=auto";
        open = "xdg-open";
      };

      initExtra = /*bash*/ '' # jk it's zsh
        # init zsh-fzf-tab
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=auto $realpath'

        # accept autosuggestions with Ctrl+Y
        bindkey '^Y' autosuggest-accept

        # remap fzf command history
        bindkey -M vicmd '/' fzf-history-widget

        # remove Alt-C binding (set by fzf (cd history))
        # it interferes with 'C' key in vicmd mode, for some reason
        bindkey -rM vicmd '\ec'
        bindkey -rM viins '\ec'
        bindkey -rM emacs '\ec' # just in case, not that I'd use it

        export DEFAULT_ZLE_LINE_INIT="$(which zle-line-init)"
        set-pref() {
          case "$#" in
            0) eval "$DEFAULT_ZLE_LINE_INIT";;
            1)
              prefix="$1"
              zle-line-init() { [ -n "$BUFFER" ] || LBUFFER="$prefix "; }
              zle -N zle-line-init
              ;;
            *)
              echo 'Error: Expected zero or one argument' >&2
              return 1
              ;;
          esac
        }
      '';
    };
  };
}
