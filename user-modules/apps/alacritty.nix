{ pkgs, lib, stylix, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  fonts.fontconfig.enable = true;

  programs.alacritty = {
    enable = true;

    settings = {
      scrolling.multiplier = 8;

      window.padding = {
        x = 2;
        y = 2;
      };
      window.dimensions = {
        columns = 120;
        lines = 32;
      };

      # font = let
      #   family = "JetBrainsMonoNLNerdFont";
      # in lib.mkForce { # override stylix settings
      #   normal = {
      #     inherit family;
      #     style = "Medium";
      #   };
      #   bold = {
      #     inherit family;
      #     style = "Bold";
      #   };
      #   italic = {
      #     inherit family;
      #     style = "MediumItalic";
      #   };
      #   bold_italic = {
      #     inherit family;
      #     style = "BoldItalic";
      #   };
      # };
    }; # settings
  };
}
