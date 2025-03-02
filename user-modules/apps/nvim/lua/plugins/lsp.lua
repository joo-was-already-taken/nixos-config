local function on_attach(_, bufnr)
  local keymap = vim.keymap
  local buf = vim.lsp.buf
  local opts = { noremap = true, silent = true, buffer = bufnr }

  keymap.set("n", "K", buf.hover, opts)
  keymap.set("n", "gd", buf.definition, opts)
  keymap.set("n", "gD", buf.declaration, opts)
  keymap.set("n", "gt", buf.type_definition, opts)
  keymap.set("n", "gr", buf.references, opts)
  keymap.set("n", "gi", buf.implementation, opts)
  keymap.set("n", "<leader>rn", buf.rename, opts)
  keymap.set("n", "<leader>ca", buf.code_action, opts)
  keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

  keymap.set("n", "<leader>xd", "<cmd>Lspsaga show_line_diagnostics<CR><cmd>set wrap<CR>", opts)
  keymap.set("n", "<leader>xj", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
  keymap.set("n", "<leader>xk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
end

local lspconfig = require("lspconfig")

local function default_setup(servers)
  local capabalities = vim.lsp.protocol.make_client_capabilities()
  capabalities = require("cmp_nvim_lsp").default_capabilities(capabalities)
  for _, server in ipairs(servers) do
    lspconfig[server].setup({
      capabalities = capabalities,
      on_attach = on_attach,
    })
  end
end

default_setup({
  "nil_ls",
  "lua_ls",
  "bashls",
  "basedpyright",
  "gopls",
  "rust_analyzer",
  "clangd",
  "zls",
  "jdtls",
})
