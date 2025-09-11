args:
let
  colorschemes = import ../colors.nix args;
in {
  colors = colorschemes.tokyonight;
  editorColors = colorschemes.tokyonight;
  wallpaper = ../wallpapers/pompeii.png;
  polarity = "dark";

  nvim = vimPlugins: {
    plugin = vimPlugins.catppuccin-nvim;
    config = /*lua*/ ''
      require("catppuccin").setup({
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
      })
      vim.cmd.colorscheme("catppuccin")
    '';
  };
}
