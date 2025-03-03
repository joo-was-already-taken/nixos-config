let
  colorschemes = import ../colors.nix;
  addHash = colors: builtins.mapAttrs (_name: val: "#${val}") colors;
in rec {
  colors = colorschemes.tokyonight;
  editorColors = colorschemes.tokyonight;
  withHash = {
    colors = addHash colors;
    editorColors = addHash editorColors;
  };
  wallpaper = ../wallpapers/pompeii.png;
  polarity = "dark";
}
