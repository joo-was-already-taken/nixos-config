local config = function()
  local notify = require("notify")
  local ui = require("harpoon.ui")
  local mark = require("harpoon.mark")

  local keymap = vim.keymap
  local opts = { noremap = true, silent = true }

  keymap.set("n", "<leader>a", function()
    mark.add_file()
    notify(
      "File marked",
      "notification",
      { title = "Harpoon" }
    )
  end, opts)
  keymap.set("n", "<leader>m", function() ui.toggle_quick_menu() end, opts)
  keymap.set("n", "<leader>h", function() ui.nav_next() end, opts)
  keymap.set("n", "<leader>l", function() ui.nav_prev() end, opts)
end

return {
  "ThePrimeagen/harpoon",
  config = config,
  dependencies = {
    "nvim-lua/plenary.nvim",
  }
}
