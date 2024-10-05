{ pkgs, ... }:

{
  stylix = {
    enable = true;

    base16Scheme = ./colorschemes/gruvbox.yaml;
    polarity = "dark";
    image = ./wallpapers/tstudler_switzerland.jpg;

    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrains Nerd Font Mono";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
    };

    opacity = {
      applications = 1.0;
      terminal = 0.8;
      desktop = 1.0;
      popups = 1.0;
    };
  };
}
