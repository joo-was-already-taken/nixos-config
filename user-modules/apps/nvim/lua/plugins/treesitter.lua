return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    main = "nvim-treesitter.configs",
    opts = {
      auto_install = false,
      ensure_installed = nil,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    },
  },
}
