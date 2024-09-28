local keymap = vim.keymap

local telescope_config = function()
	local telescope = require("telescope")
	telescope.setup({
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
				},
			},
		},
		-- pickers = {
		--   -- find_files = {
		--   --   theme = "dropdown",
		--   --   previewer = false,
		--   --   hidden = true,
		--   -- },
		--   -- live_grep = {
		--   --   theme = "dropdown",
		--   --   previewer = false,
		--   -- },
		--   -- find_buffers = {
		--   --   theme = "dropdown",
		--   --   previewer = false,
		--   -- },
		-- },
	})
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = telescope_config,
    keys = {
      keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<CR>"),
      keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>"),
      keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>"),
      keymap.set("n", "<leader>fa", "<cmd>Telescope <CR>"),
      keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>"),
      keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>"),
    },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
