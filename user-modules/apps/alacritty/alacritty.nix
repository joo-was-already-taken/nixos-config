{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  fonts.fontconfig.enable = true;

  programs.alacritty = {
    enable = true;

    settings = {
      import = [
        ./themes/gruvbox_material_medium_dark.toml
      ];

      scrolling.multiplier = 8;

      window.opacity = 0.85;
      window.padding = {
        x = 10;
        y = 10;
      };
      window.dimensions = {
        columns = 120;
        lines = 32;
      };

      font = let
        family = "JetBrainsMonoNLNerdFont";
      in {
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
}
