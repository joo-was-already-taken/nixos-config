{ pkgs, ... }:
let
  style = import ./current-settings.nix;
in {
  stylix = {
    enable = true;

    base16Scheme = style.colors;
    image = style.wallpaper;
    polarity = style.polarity;

    cursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 32;
    };

    fonts = {
      monospace = {
        # package = pkgs.nerd-fonts.dejavu-sans-mono;
        # name = "DejaVuSansM Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
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
