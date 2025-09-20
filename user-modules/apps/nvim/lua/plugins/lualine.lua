local codeium_status = {
  function()
    if vim.g.codeium_enabled then
      return "󰚩 codeium"
    else
      return "󱚢 no clankers"
    end
  end,
  color = function()
    if vim.g.codeium_enabled then
      local function get_fg(hl_group)
        return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl_group)), "fg#")
      end
      return { fg = get_fg("Keyword") }
    else
      return nil
    end
  end,
}

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", opt = true },
      "folke/noice.nvim",
    },
    opts = function(_, _)
      local noice = require("noice")

      return {
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
          lualine_x = {
            codeium_status,
            "encoding",
            "fileformat",
            "filetype",
          },
        },
      }
    end,
  },
}
