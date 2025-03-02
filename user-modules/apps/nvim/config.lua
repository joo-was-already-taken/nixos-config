vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- OPTIONS
local opt = vim.opt

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
-- Appearance
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.scrolloff = 10
opt.completeopt = "menuone,noinsert,noselect"
-- Behaviour
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.autochdir = false
opt.mouse:append("a")
opt.clipboard:append("unnamedplus")
opt.modifiable = true
opt.encoding = "UTF-8"


-- KEYMAPS
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
keymap.set("n", "<leader>s-", "<cmd>split<CR>", opts)
keymap.set("n", "<leader>s|", "<cmd>vsplit<CR>", opts)

-- Indenting
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- Editing
keymap.set("n", "<leader>o", "o<ESC>", opts)
keymap.set("n", "<leader>O", "O<ESC>", opts)

-- Delete trailing whitespace
keymap.set("n", "<leader>wt", function()
  local cursor = vim.fn.getpos(".")
  pcall(function() vim.cmd([[%s/\s\+$//e]]) end)
  vim.fn.setpos(".", cursor)
end, opts)

-- Clear search highlight
keymap.set("n", "<leader>h", "<cmd>noh<CR>", opts)


-- -- REQUIRE
-- local function require_from(dir)
--   local files = vim.fn.readdir(dir)
--   for _, file in ipairs(files) do
--     local lua_pattern = "%.lua$"
--     if file:match(lua_pattern) then
--       require(file:gsub(lua_pattern, ""))
--     end
--   end
-- end
--
-- require("options")
-- require("keymaps")
-- require_from("plugins")
