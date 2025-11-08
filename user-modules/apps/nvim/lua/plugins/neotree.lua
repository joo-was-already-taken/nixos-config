return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    opts = {
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      default_component_configs = {
        last_modified = { format = "%Y-%m-%d %H:%M" },
        created = { format = "%Y-%m-%d %H:%M" },
      },

      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },

      buffers = {
        show_unloaded = true,
      },

      window = { position = "current" },
    },
    keys = {
      { "<leader>e", "<cmd>Neotree filesystem toggle reveal float<CR>" },
      { "<leader>g", "<cmd>Neotree git_status toggle reveal float<CR>" },
      { "<leader>b", "<cmd>Neotree buffers toggle reveal float<CR>" },
    },
  },
}
