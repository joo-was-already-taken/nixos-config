local notify = require("notify")

notify.setup({
  render = "compact",
  top_down = false,
})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>cn", function()
  notify.dismiss({ silent = true, padding = true })
end, opts)
