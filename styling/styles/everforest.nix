args:
let
  colorschemes = import ../colors.nix args;
in {
  colors = colorschemes.evergarden;
  editorColors = colorschemes.evergarden;
  wallpaper = ../wallpapers/white-mountain-cold.jpg;
  polarity = "dark";

  nvim = pkgs: {
    plugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "everforest";
        version = "2025-09-28";
        src = pkgs.fetchFromGitHub {
          owner = "neanias";
          repo = "everforest-nvim";
          rev = "557bce9";
          sha256 = "sha256-nOMUb55P5mqUKD5w5xppJ94+gGnZbllJBoAiQLFFLA0=";
        };
      })
    ];

    config = /*lua*/ ''
      return {
        "neanias/everforest-nvim",
        name = "everforest",
        priority = 1000,
        opts = {},
        config = function(_, opts)
          require("everforest").setup(opts)
          vim.cmd.colorscheme("everforest")
        end,
      }
    '';
  };
}
