return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function(_, _)
    local actions = require("telescope.actions")

    return {
      defaults = {
        preview = {
          treesitter = true,
        },
        mappings = {
          n = {
            ["p"] = actions.cycle_history_prev,
            ["n"] = actions.cycle_history_next,
          },
        },
      },
    }
  end,
  keys = {
    { "<leader>fh", "<cmd>Telescope help_tags<CR>" },
    { "<leader>ff", "<cmd>Telescope find_files<CR>" },
    { "<leader>fa", "<cmd>Telescope<CR>" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>" },

    { "<leader>fr", require("telescope.builtin").resume },
  },
}
