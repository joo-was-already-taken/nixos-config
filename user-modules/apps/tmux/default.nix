{ lib, pkgs, config, ... }:
let
  moduleName = "tmux";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.tmux = {
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
      ];

      extraConfig = builtins.readFile ./tmux.conf;
    };
  };
}
