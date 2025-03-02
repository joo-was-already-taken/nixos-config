require("telescope").setup({
  defaults = {
    preview = {
      treesitter = true,
    },
  },
})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
vim.keymap.set("n", "<leader>fa", "<cmd>Telescope<CR>", opts)
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
