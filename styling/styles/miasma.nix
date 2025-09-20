args:
let
  colorschemes = import ../colors.nix args;
in {
  colors = colorschemes.miasma;
  editorColors = colorschemes.miasma;
  wallpaper = ../wallpapers/misty-forest.jpg;
  polarity = "dark";

  nvim = pkgs: {
    plugins = with pkgs.vimPlugins; [
      lush-nvim
    ];
    config = /*lua*/ ''
      vim.cmd.colorscheme("miasma2")
    '';
  };
}
