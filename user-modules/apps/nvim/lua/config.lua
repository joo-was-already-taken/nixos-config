vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd.colorscheme("catppuccin")

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
opt.background = "dark"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.scrolloff = 10
opt.completeopt = "menuone,noinsert,noselect"
opt.cursorline = true
opt.cursorlineopt = "number"
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
local function keymap_set(mode, new, prev)
  local opts = { noremap = true, silent = true }
  vim.keymap.set(mode, new, prev, opts)
end

-- Exiting
keymap_set("n", "<leader>qq", "<cmd>qa<CR>")
keymap_set("n", "<leader>qw", "<cmd>wa<CR><cmd>qa<CR>")

-- Navigation
keymap_set({ "n", "v" }, "<C-d>", "<C-d>zz")
keymap_set({ "n", "v" }, "<C-u>", "<C-u>zz")
keymap_set({ "n", "v" }, "<C-f>", "<C-f>zz")
keymap_set({ "n", "v" }, "<C-b>", "<C-b>zz")

-- Window and Pane Navigation
keymap_set("n", "<C-h>", "<C-w>h")
keymap_set("n", "<C-l>", "<C-w>l")
keymap_set("n", "<C-j>", "<C-w>j")
keymap_set("n", "<C-k>", "<C-w>k")
keymap_set("t", "<C-h>", "<cmd>wincmd h<CR>")
keymap_set("t", "<C-l>", "<cmd>wincmd l<CR>")
keymap_set("t", "<C-j>", "<cmd>wincmd j<CR>")
keymap_set("t", "<C-k>", "<cmd>wincmd k<CR>")
keymap_set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
keymap_set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>")
keymap_set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>")
keymap_set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>")

-- Window Management
keymap_set("n", "<leader>s-", "<cmd>split<CR>")
keymap_set("n", "<leader>s|", "<cmd>vsplit<CR>")
keymap_set("n", "<leader>s+", "<C-w>+")
keymap_set("n", "<leader>s-", "<C-w>-")
keymap_set("n", "<leader>s>", "<C-w>>")
keymap_set("n", "<leader>s<", "<C-w><")
keymap_set("n", "<leader>s=", "<C-w>=")

-- Indenting
keymap_set("v", "<", "<gv")
keymap_set("v", ">", ">gv")

-- Editing
keymap_set("i", "<C-bs>", "<C-w>")
keymap_set("i", "<C-h>", "<C-w>")
keymap_set("n", "<leader>o", "o<ESC>")
keymap_set("n", "<leader>O", "O<ESC>")

-- Delete trailing whitespace
keymap_set("n", "<leader>wt", function()
  local cursor = vim.fn.getpos(".")
  pcall(function() vim.cmd([[%s/\s\+$//e]]) end)
  vim.fn.setpos(".", cursor)
end)

-- REQUIRE
local function load_from(dir)
  local files = vim.fn.readdir(dir)
  for _, file in ipairs(files) do
    if file:match("%.lua$") then
      local chunk, _ = loadfile(dir .. "/" .. file)
      if chunk then chunk() end
    end
  end
end

load_from(vim.fn.stdpath("config") .. "/lua/plugins")
