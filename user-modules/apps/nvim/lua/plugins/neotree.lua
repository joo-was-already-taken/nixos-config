local function config()
  require("neo-tree").setup({
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,

    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },

    window = { position = "current" },
  })

  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>e", "<cmd>Neotree filesystem toggle reveal float<CR>", opts)
  vim.keymap.set("n", "<leader>g", "<cmd>Neotree git_status toggle reveal float<CR>", opts)
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    config = config,
  },
}
