local function config()
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
  })

  local function on_attach(_, bufnr)
    local function keymap_set(mode, new, prev)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set(mode, new, prev, opts)
    end
    local buf = vim.lsp.buf

    keymap_set("n", "K", buf.hover)
    keymap_set("n", "gd", buf.definition)
    keymap_set("n", "gD", buf.declaration)
    keymap_set("n", "gt", buf.type_definition)
    keymap_set("n", "gr", buf.references)
    keymap_set("n", "gi", buf.implementation)
    keymap_set("n", "<leader>rn", buf.rename)
    keymap_set("n", "<leader>ca", buf.code_action)
    keymap_set("n", "gR", "<cmd>Telescope lsp_references<CR>")

    keymap_set("n", "<leader>xd", "<cmd>Lspsaga show_line_diagnostics<CR><cmd>set wrap<CR>")
    keymap_set("n", "<leader>xj", "<cmd>Lspsaga diagnostic_jump_next<CR>")
    keymap_set("n", "<leader>xk", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
  end

  local capabalities = vim.lsp.protocol.make_client_capabilities()
  capabalities = require("cmp_nvim_lsp").default_capabilities(capabalities)

  local function default_setup(servers)
    for _, server in ipairs(servers) do
      vim.lsp.config(server, {
        capabalities = capabalities,
        on_attach = on_attach,
      })
    end
  end

  default_setup({
    "lua_ls",
    "nil_ls",
    "bashls",
    "pyright",
    "gopls",
    "rust_analyzer",
    "zls",
    "tinymist",
    "ts_ls",
  })

  vim.lsp.config("clangd", {
    cmd = {
      "clangd",
      "--clang-tidy",
      "--background-index",
      "--completion-style=bundled",
    },
    capabalities = capabalities,
    on_attach = on_attach,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      {
        "glepnir/lspsaga.nvim",
        opts = {
          ui = { code_action = "" },
          symbol_in_winbar = { enable = false },
        },
      },
    },
    config = config,
  },
}
