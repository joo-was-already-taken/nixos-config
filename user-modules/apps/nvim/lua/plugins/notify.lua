local function notify_config()
  local notify = require("notify")
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>cn", function()
    notify.dismiss({ silent = true, padding = true })
  end, opts)
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
      config = notify_config,
    },
  },
}
