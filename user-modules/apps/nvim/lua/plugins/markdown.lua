local number_line_width = 6
local code_width = 70
local buffer_width = 90

require("render-markdown").setup({
  render_modes = true,
  heading = {
    icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
    position = "inline",
  },
  code = {
    width = "block",
    min_width = code_width,
    left_margin = 2,
    left_pad = 2,
    right_pad = 2,
    language_pad = 0,
  },
  latex = { enable = false },
})

require("obsidian").setup({
  ui = { enable = false },
  disable_frontmatter = true,
  workspaces = {
    {
      name = "wisdom",
      path = "~/wisdom",
    },
  },
  templates = {
    folder = ".templates",
  },
})

require("no-neck-pain").setup({
  width = buffer_width + number_line_width,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.md",
  callback = function()
    vim.cmd("set wrap")
    vim.cmd("NoNeckPain")
  end,
})
