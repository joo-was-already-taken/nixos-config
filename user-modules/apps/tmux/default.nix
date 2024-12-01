{ lib, pkgs, config, ... }:
let
  moduleName = "tmux";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.tmux = let
      resurrectDirPath = "~/.tmux/resurrect/";
    in {
      enable = true;
      
      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
        {
          plugin = yank;
          extraConfig = ''
            bind -T copy-mode-vi v send-keys -X begin-selection
            bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
            bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
          '';
        }
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-dir ${resurrectDirPath}
          '';
        }
      ];

      extraConfig = builtins.readFile ./tmux.conf;
    };
  };
}
