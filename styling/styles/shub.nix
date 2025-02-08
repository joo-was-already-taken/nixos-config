let
  colorschemes = import ../colors.nix;
  addHash = colors: builtins.mapAttrs (_name: val: "#${val}") colors;
in rec {
  # wallpaper = ../wallpapers/nicola-samori-nature-of-fear.jpg;
  # colorscheme = ../colorschemes/gruvbox.yaml;
  # editorColors = import ../editor-colors/shub.nix;
  # polarity = "dark";
  colors = colorschemes.shub;
  editorColors = colorschemes.shub;
  withHash = {
    colors = addHash colors;
    editorColors = addHash editorColors;
  };
  wallpaper = ../wallpapers/nicola-samori-nature-of-fear.jpg;
  polarity = "dark";
}
