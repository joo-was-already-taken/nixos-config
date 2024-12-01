return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      render = 'background',
      highlight_named_colors = true,
    },
  },
  {
    "machakann/vim-highlightedyank",
    lazy = false,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  {
    "tpope/vim-obsession"
  },
  {
    "RRethy/vim-illuminate",
    lazy = false,
    config = function()
      require("illuminate").configure({})
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    config = function()
      require("nvim-ts-autotag").setup({})
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
