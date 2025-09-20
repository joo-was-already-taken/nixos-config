return {
  {
    "nvim-neorg/neorg",
    dependencies = {
      "shortcuts/no-neck-pain.nvim",
    },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.integrations.treesitter"] = {},
        ["core.concealer"] = {
          config = {
            icon_preset = "basic",
            folds = true,
            init_open_folds = "auto",
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              wisdom = "~/wisdom",
            },
            default_workspace = "wisdom",
          },
        },
      },
    },
    config = function(_, opts)
      require("neorg").setup(opts)

      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*.norg",
        callback = function()
          vim.cmd("set wrap")
          vim.cmd("NoNeckPain")
        end,
      })
    end,
  },
}
