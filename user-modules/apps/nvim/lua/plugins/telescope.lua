local actions = require("telescope.actions")

require("telescope").setup({
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
})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
vim.keymap.set("n", "<leader>fa", "<cmd>Telescope<CR>", opts)
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)

vim.keymap.set("n", "<leader>fr", require("telescope.builtin").resume, opts)
