args:
let
  colorschemes = import ../colors.nix args;
in {
  colors = colorschemes.gruvbox;
  editorColors = colorschemes.gruvbox;
  wallpaper = ../wallpapers/nicola-samori-nature-of-fear.jpg;
  polarity = "dark";

  nvim = pkgs: {
    plugins = with pkgs.vimPlugins; [
      gruvbox-material-nvim
    ];
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
