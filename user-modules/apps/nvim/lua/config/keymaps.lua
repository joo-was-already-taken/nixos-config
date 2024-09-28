local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Exiting
keymap.set("n", "<leader>qq", "<cmd>qa<CR>", opts)
keymap.set("n", "<leader>qw", "<cmd>wa<CR><cmd>qa<CR>", opts)

-- Navigation
keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", opts)
keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", opts)

-- Window and Pane Navigation
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("t", "<C-h>", "<cmd>wincmd h<CR>", opts)
keymap.set("t", "<C-l>", "<cmd>wincmd l<CR>", opts)
keymap.set("t", "<C-j>", "<cmd>wincmd j<CR>", opts)
keymap.set("t", "<C-k>", "<cmd>wincmd k<CR>", opts)
keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", opts)
keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", opts)
keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", opts)
keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", opts)

-- Window Management
keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", opts)
keymap.set("n", "<leader>sh", "<cmd>split<CR>", opts)

-- Indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Editing
keymap.set("n", "<leader>o", "o<ESC>", opts)
keymap.set("n", "<leader>O", "O<ESC>", opts)

-- Delete trailing whitespace
keymap.set("n", "<leader>wt", function()
  local cursor = vim.fn.getpos(".")
  pcall(function() vim.cmd([[%s/\s\+$//e]]) end)
  vim.fn.setpos(".", cursor)
end, opts)

-- -- Resize windows
-- local resize = function(
-- vim.api.nvim_create_user_command("Resize")
