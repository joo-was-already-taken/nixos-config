local config = function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "markdown",
      "json",
      "javascript",
      "typescript",
      "yaml",
      "toml",
      "html",
      "css",
      "bash",
      "lua",
      "gitignore",
      "python",
      "rust",
      "cmake",
      "c",
      "cpp",
      "haskell",
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
    },
    indent = {
      enable = true,
    },
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  config = config,
}
