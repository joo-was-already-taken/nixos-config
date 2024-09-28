-- return {
--   "folke/tokyonight.nvim",
--   lazy = false,
--   name = "tokyonight",
--   priority = 1000,
--   opts = {},
--   config = function()
-- 	  vim.cmd.colorscheme("tokyonight")
--   end,
-- }

return {
  "ellisonleao/gruvbox.nvim",
  name = "gruvbox",
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd.colorscheme("gruvbox")
  end,
}
