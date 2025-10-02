local number_line_width = 6
local code_width = 70
local buffer_width = 90

local function mix_colors(c1, c2, ratio)
  local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1,2)) / 255,
      tonumber("0x" .. hex:sub(3,4)) / 255,
      tonumber("0x" .. hex:sub(5,6)) / 255
  end

  local function rgb_to_hex(r, g, b)
    return string.format("#%02x%02x%02x", r*255, g*255, b*255)
  end

  local r1, g1, b1 = hex_to_rgb(c1)
  local r2, g2, b2 = hex_to_rgb(c2)
  local r = r1 + (r2 - r1) * ratio
  local g = g1 + (g2 - g1) * ratio
  local b = b1 + (b2 - b1) * ratio
  return rgb_to_hex(r, g, b)
end

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "vimwiki" },
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

      local get_hl_property = require("utils").get_hl_property
      for i = 1, 6 do
        local base_hl = "RenderMarkdownH" .. tostring(i)
        local fg = get_hl_property(base_hl, "fg#")
        local normal_bg = get_hl_property("Normal", "bg#")
        local bg = mix_colors(fg, normal_bg, 0.8)
        local hl_args = { fg = fg, bg = bg }
        vim.api.nvim_set_hl(0, base_hl .. "Bg", hl_args)
      end

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
