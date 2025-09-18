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
      ((pkgs.vimUtils.buildVimPlugin {
        pname = "evergarden";
        version = "2025-09-18";
        src = pkgs.fetchFromGitHub {
          owner = "everviolet";
          repo = "nvim";
          rev = "951d0c4";
          sha256 = "sha256-JwJeuTN3cDM9vjPh/In8/L6trT73cwaf8NnidvASKw0=";
        };
      })
        .overrideAttrs {
          nvimSkipModules = [
            "minidoc"
            "evergarden.extras"
          ];
        })
    ];

    config = /*lua*/ ''
      return {
        "everviolet/nvim",
        name = "evergarden",
        priority = 1000,
        opts = {
          theme = {
            variant = "winter", -- "winter"|"fall"|"spring"|"summer"
            accent = "green",
          },
          editor = {
            transparent_background = false,
            sign = { color = "none" },
            float = {
              color = "mantle",
              solid_border = false,
            },
            completion = {
              color = "surface0",
            },
          },
        },
        config = function(_, opts)
          require("evergarden").setup(opts)
          vim.cmd.colorscheme("evergarden")
        end,
      }
    '';
  };
}
