local function dismiss_notifications()
  require("notify").dismiss({ silent = true, padding = true })
end

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {},
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        render = "compact",
        top_down = false,
      },
      keys = {
        { "<leader>cn", dismiss_notifications },
      },
    },
  },
}
