let
  colorschemes = import ../colors.nix;
  addHash = colors: builtins.mapAttrs (_name: val: "#${val}") colors;
in rec {
  colors = colorschemes.gruvbox;
  editorColors = colorschemes.gruvbox;
  withHash = {
    colors = addHash colors;
    editorColors = addHash editorColors;
  };
  wallpaper = ../wallpapers/nicola-samori-nature-of-fear.jpg;
  polarity = "dark";

  nvim = vimPlugins: {
    plugin = vimPlugins.gruvbox-material-nvim;
    config = /*lua*/ ''
      require("gruvbox-material").setup({
        contrast = "soft",
        customize = function(g, o)
          if g == "Comment" then
            o.fg = "#888888"
          end
          return o
        end,
      })
      vim.cmd.colorscheme("gruvbox-material")
    '';
  };
}
