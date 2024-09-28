local notify_config = function()
  local notify = require("notify")
  local keymap = vim.keymap
  local opts = { noremap = true, silent = true }

  keymap.set("n", "<leader>c", function() notify.dissmiss({ silent = true, pending = true }) end, opts)
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
        top_down = false,
      },
      config = notify_config,
    },
  },
}
