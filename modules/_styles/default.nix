lib:
let
  colors = import ./colors.nix lib;
in {
  evergarden = {
    colors = colors.evergarden;
    wallpaper = ./wallpapers/white-mountain-cold.jpg;
    polarity = "dark";
  };
}
