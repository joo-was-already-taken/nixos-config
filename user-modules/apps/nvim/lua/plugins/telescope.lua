local function find_files()
  local telescope = require("telescope.builtin")
  local is_in_git_repo = pcall(telescope.git_files, { show_untracked = true })
  if not is_in_git_repo then
    telescope.find_files({ find_command = {
      "fd",
      "--type=f",
      "--hidden",
      "--strip-cwd-prefix",
      "--no-require-git",
    } })
  end
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    defaults = {
      preview = {
        treesitter = true,
      },
      mappings = {
        n = {
          ["p"] = require("telescope.actions").cycle_history_prev,
          ["n"] = require("telescope.actions").cycle_history_next,
        },
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading", -- required
        "--with-filename", -- required
        "--line-number", -- required
        "--column", -- required
        "--smart-case",
        -- use rules from .gitignore, even if not in a git repo
        "--no-require-git",
      },
    },
  },
  keys = {
    { "<leader>fh", "<cmd>Telescope help_tags<CR>" },
    { "<leader>ff", find_files },
    { "<leader>fa", "<cmd>Telescope<CR>" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>" },

    { "<leader>fr", require("telescope.builtin").resume },
  },
}
