require("neo-tree").setup({
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  window = { position = "current" },
})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", "<cmd>Neotree filesystem toggle reveal float<CR>", opts)
vim.keymap.set("n", "<leader>g", "<cmd>Neotree git_status toggle reveal float<CR>", opts)
