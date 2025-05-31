{ lib, config, ... }:
let
  moduleName = "ghostty";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    stylix.targets.ghostty.enable = true;

    programs.ghostty = {
      enable = true;

      enableZshIntegration = true;
      clearDefaultKeybinds = true;

      settings = {
        gtk-single-instance = true;
        confirm-close-surface = false;
        clipboard-paste-protection = false;
        quit-after-last-window-closed = true;
        quit-after-last-window-closed-delay = "10m";
        resize-overlay = "never";

        foreground = config.lib.stylix.colors.withHashtag.base06;

        font-feature = [
          # disable ligatures
          "-calt" "-liga" "-dlig"
        ];

        keybind = [
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+insert=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"
          "shift+insert=paste_from_clipboard"
        ];
      };
    };
  };
}
