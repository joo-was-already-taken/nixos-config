{
  flake.modules.homeManager.tmux = { pkgs, ... }@args: {
    home.packages = import ./_scripts.nix args;

    programs.tmux = let
      resurrectDirPath = "~/.tmux/resurrect/";
    in {
      enable = true;
      
      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
        open
        {
          plugin = yank;
          extraConfig = /*bash*/ ''
            bind -T copy-mode-vi v send-keys -X begin-selection
            bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
            bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
          '';
        }
        {
          plugin = resurrect;
          extraConfig = /*bash*/ ''
            set -g @resurrect-strategy-vim session
            set -g @resurrect-strategy-nvim session
            set -g @resurrect-capture-pane-contents on
            set -g @resurrect-dir ${resurrectDirPath}
          '';
        }
        {
          plugin = continuum;
          extraConfig = /*bash*/ ''
            set -g @continuum-restore on
            set -g @continuum-save-interval 15
          '';
        }
      ];

      extraConfig = builtins.readFile ./tmux.conf;
    };
  };
}
