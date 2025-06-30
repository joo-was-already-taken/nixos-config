return {
  "tpope/vim-obsession",
  { "lewis6991/gitsigns.nvim", opts = {} },
  {
    "Enter-tainer/typst-preview",
    name = "typst-preview.nvim",
    opts = {},
  },
  {
    "alexghergh/nvim-tmux-navigation",
    name = "vim-tmux-navigator",
  },
  {
    "numToStr/Comment.nvim",
    name = "comment.nvim",
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      scope = { enabled = false },
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      render = "virtual",
      virtual_symbol = "●",
      virtual_symbol_prefix = " ",
      virtual_symbol_suffix = "",
      virtual_symbol_position = "eol",
    },
  },
}
