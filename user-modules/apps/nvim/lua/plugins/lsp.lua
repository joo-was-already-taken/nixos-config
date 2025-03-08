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

local lspconfig = require("lspconfig")
local capabalities = vim.lsp.protocol.make_client_capabilities()
capabalities = require("cmp_nvim_lsp").default_capabilities(capabalities)

local function default_setup(servers)
  for _, server in ipairs(servers) do
    lspconfig[server].setup({
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
  "clangd",
  "zls",
  "jdtls",
})
