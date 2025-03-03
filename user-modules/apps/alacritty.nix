{ lib, config, ... }:
let
  moduleName = "alacritty";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        env.TERM = "xterm-256color";

        scrolling.multiplier = 8;

        window.padding = {
          x = 2;
          y = 2;
        };
        window.dimensions = {
          columns = 120;
          lines = 32;
        };

        font = let
          family = config.stylix.fonts.monospace.name;
        in lib.mkForce { # override stylix settings
          normal = {
            inherit family;
            style = "Medium";
          };
          bold = {
            inherit family;
            style = "Bold";
          };
          italic = {
            inherit family;
            style = "MediumItalic";
          };
          bold_italic = {
            inherit family;
            style = "BoldItalic";
          };
        };
      }; # settings
    };
  };
}
