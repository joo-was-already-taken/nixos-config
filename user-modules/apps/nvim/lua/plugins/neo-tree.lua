local function config()
  require("neo-tree").setup({
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
      file_size = {
        enabled = true,
        required_width = 54,
      },
      type = {
        enabled = true,
        required_width = 112,
      },
      last_modified = {
        enabled = true,
        required_width = 78,
      },
      created = {
        enabled = true,
        required_width = 100,
      },
      symlink_target = {
        enabled = false,
      },
    },
    window = {
      position = "current",
      mappings = {
        ["P"] = function(state)
          local node = state.tree:get_node()
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end,
      },
    },
    filesystem = {
      window = {
        fuzzy_finder_mappings = {
          ["<C-j>"] = "move_cursor_down",
          ["<C-k>"] = "move_cursor_up",
        },
      },
    },
  })

  vim.keymap.set("n", "<leader>e", "<cmd>Neotree filesystem toggle reveal float<CR>", {})
  vim.keymap.set("n", "<leader>g", "<cmd>Neotree git_status toggle reveal float<CR>", {})
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = config,
}
