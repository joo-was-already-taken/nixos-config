local value_difference = function(a, b)
	local b_set = {}
	for _, val in pairs(b) do
		b_set[val] = true
	end
	local diff = {}
	for _, val in pairs(a) do
		if b_set[val] == nil then
			table.insert(diff, val)
		end
	end
	return diff
end

local ensure_installed = {
	-- "bashls",
	"clangd",
	"cmake", -- or "neocmake"
	-- "cssls",
	-- "html",
	-- "jsonls",
	-- -- "tsserver",
	-- -- "ltex",
	"lua_ls",
	"marksman",
	-- -- "pylsp",
  -- "pyright",
	"rust_analyzer",
	"taplo",
	-- "lemminx",
	-- "yamlls",
}

local mason_lspconfig_config = function()
	require("mason-lspconfig").setup({
		ensure_installed = ensure_installed,
	})
end

local nvim_lspconfig_config = function()
	local lspconfig = require("lspconfig")
	local cmp_nvim_lsp = require("cmp_nvim_lsp")

	local default_capabilities = cmp_nvim_lsp.default_capabilities()

	---@diagnostic disable-next-line: unused-local
	local on_attach = function(client, bufnr)
		local keymap = vim.keymap
		local opts = { noremap = true, silent = true, buffer = bufnr }

		keymap.set("n", "K", vim.lsp.buf.hover, opts)
		keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		keymap.set("n", "gr", vim.lsp.buf.references, opts)
    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

		keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
		keymap.set("n", "<leader>xd", "<cmd>Lspsaga show_line_diagnostics<CR>" .. "<cmd>set wrap<CR>", opts)
		keymap.set("n", "<leader>xj", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
		keymap.set("n", "<leader>xk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
		-- keymap.set("n", "<leader>K", "<cmd>Lspsaga hover_doc<CR>", opts)
	end

	local default_setup = function(servers)
		for _, server in ipairs(servers) do
			lspconfig[server].setup({
				capabilities = default_capabilities,
				on_attach = on_attach,
			})
		end
	end

	local custom_setup = {
		"lua_ls",
    -- "pyright",
  }

	-- Create a default setup for every element in `ensure_installed`,
	-- not present in `custom_setup`
	default_setup(value_difference(ensure_installed, custom_setup))

	lspconfig.lua_ls.setup({
		capabilities = default_capabilities,
		on_attach = on_attach,
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
			},
		},
	})

	-- lspconfig.pyright.setup({
	-- 	capabilities = default_capabilities,
	-- 	on_attach = on_attach,
	-- 	settings = {
 --      python = {
 --        pythonPath = "/usr/bin/python3.12",
 --        -- analysis = {
 --        --   reportPrivateImportUsage = false,
 --        -- },
 --      },
	-- 	},
	-- })
end

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = mason_lspconfig_config,
	},
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
					move_in_saga = { prev = "<C-k>", next = "<C-j>" },
					-- finder_action_keys = { open = "<CR>" },
					-- definition_action_keys = { edit = "<CR>" },
				},
			},
		},
		config = nvim_lspconfig_config,
	},
}
