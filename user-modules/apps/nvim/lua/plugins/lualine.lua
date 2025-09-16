return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", opt = true },
      "folke/noice.nvim",
      "nomnivore/ollama.nvim",
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
            {
              function()
                local status = require("ollama").status()
                if status == "IDLE" then
                  return "󱙺" -- nf-md-robot-outline
                elseif status == "WORKING" then
                  return "󰚩" -- nf-md-robot
                end
              end,
              cond = function()
                return package.loaded["ollama"] and require("ollama").status() ~= nil
              end,
            },
            "encoding",
            "fileformat",
            "filetype",
          },
        },
      }
    end,
  },
}
