args:
let
  colorschemes = import ../colors.nix args;
in {
  colors = colorschemes.miasma;
  editorColors = colorschemes.miasma;
  wallpaper = ../wallpapers/nicola-samori-nature-of-fear.jpg;
  polarity = "dark";

  nvim = vimPlugins: {
    plugins = [ vimPlugins.lush-nvim ];
    config = /*lua*/ ''
      return {
        "rktjmp/lush.nvim",
        lazy = false,
        config = function()
          vim.cmd.colorscheme("miasma")
        end,
      }
    '';
  };
}
