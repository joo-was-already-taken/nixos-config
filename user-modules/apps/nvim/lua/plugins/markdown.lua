local number_line_width = 6
local code_width = 70
local buffer_width = 90

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "shortcuts/no-neck-pain.nvim",
    },
    opts = {
      render_modes = true,
      heading = {
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
        position = "inline",
      },
      code = {
        style = "normal",
        sign = false,
        border = "thin",
        width = "block",
        min_width = code_width,
        left_margin = 2,
        left_pad = 2,
        right_pad = 2,
      },
      latex = { enable = false },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- vim.treesitter.language.register("markdown", "vimwiki")

      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*.md",
        callback = function()
          vim.cmd("set wrap")
          vim.cmd("NoNeckPain")
        end,
      })
    end,
  },

  {
    "epwalsh/obsidian.nvim",
    lazy = false,
    opts = {
      ui = { enable = false },
      disable_frontmatter = true,
      follow_url_func = function(url)
        vim.fn.jobstart({ "xdg-open", url })
      end,
      workspaces = {
        {
          name = "wisdom",
          path = "~/wisdom",
        },
      },
      templates = {
        folder = ".templates",
      },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  {
    "shortcuts/no-neck-pain.nvim",
    opts = {
      width = buffer_width + number_line_width,
    },
  },
}
