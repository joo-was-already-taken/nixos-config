args:
let
  colorschemes = import ../colors.nix args;
in {
  # wallpaper = ../wallpapers/nicola-samori-nature-of-fear.jpg;
  # colorscheme = ../colorschemes/gruvbox.yaml;
  # editorColors = import ../editor-colors/shub.nix;
  # polarity = "dark";
  colors = colorschemes.shub;
  editorColors = colorschemes.shub;
  wallpaper = ../wallpapers/nicola-samori-nature-of-fear.jpg;
  polarity = "dark";
}
