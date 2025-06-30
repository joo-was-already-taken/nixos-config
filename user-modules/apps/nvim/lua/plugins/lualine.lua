local function config()
  local noice = require("noice")

  require("lualine").setup({
    options = {
      globalstatus = true,
      component_separators = "│",
      section_separators = "",
    },
    sections = {
      lualine_b = {
        "branch",
        "diff",
      },
      lualine_c = {
        "filename",
        {
          function()
            -- return everything after a mode indicator
            -- for example "-- INSERT --recording @a" -> "recording @a"
            return noice.api.statusline.mode.get():gsub("^%-%-.-%-%-", "")
          end,
          cond = noice.api.statusline.mode.has,
        },
        {
          "diagnostics",
          symbols = {
            error = "E",
            warn = "W",
            info = "I",
            hint = "H",
          },
        },
      },
    },
  })
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", opt = true },
      "folke/noice.nvim",
    },
    config = config,
  },
}
