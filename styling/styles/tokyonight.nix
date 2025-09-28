args:
let
  colorschemes = import ../colors.nix args;
in {
  colors = colorschemes.tokyonight;
  editorColors = colorschemes.tokyonight;
  wallpaper = ../wallpapers/pompeii.png;
  polarity = "dark";

  nvim = pkgs: {
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
    ];
    config = /*lua*/ ''
      return {
        "catppuccin/nvim",
        name = "catppuccin-nvim",
        opts = {
          flavour = "macchiato",
          transparent_background = false,
          show_end_of_buffer = true,
          term_colors = true,
          background = {
            dark = "macchiato",
            light = "latte",
          },
          default_integrations = true,
          integrations = {
            cmp = true,
            gitsigns = true,
            neotree = true,
            treesitter = true,
            telescope = { enabled = true },
            native_lsp = { enabled = true },
          },
          highlight_overrides = {
            macchiato = function(macchiato)
              return {
                LineNr = { fg = macchiato.lavender },
                CursorLineNr = { fg = macchiato.sky },
              }
            end
          },
        },
        config = function(_, opts)
          require("catppuccin").setup(opts)
          vim.cmd.colorscheme("catppuccin")
        end,
      }
    '';
  };
}
