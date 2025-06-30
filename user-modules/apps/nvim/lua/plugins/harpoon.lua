local function config()
  local harpoon = require("harpoon")
  harpoon:setup()

  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>ha", function()
    harpoon:list():add()
    vim.notify("Harpooned current buffer", "info")
  end, opts)
  vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, opts)
  vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, opts)
  vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, opts)
end

return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    name = "harpoon2",
    config = config,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
