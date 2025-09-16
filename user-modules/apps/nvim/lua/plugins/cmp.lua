local function opts()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  return {
    completion = {
      completeopt = "menu,menuone,preview",
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-y>"] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources({
      { name = "cmp_ai" },
      { name = "nvim_lsp" },
      { name = "render-markdown" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    }),
  }
end

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "tzachar/cmp-ai",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        name = "luasnip",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
          "rafamadriz/friendly-snippets",
        },
      },
    },
    opts = opts,
  },
  {
    "tzachar/cmp-ai",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("cmp_ai.config"):setup({
        max_lines = 100,
        provider = "OpenAI",
        provider_options = {
          model = "gpt-oss-120b",
          -- api_key = os.getenv("OPENROUTER_API_KEY"),
          endpoint = "https://openrouter.ai/v1/completions",
        },
        run_on_every_keystroke = true,
        notify = true,
        notify_callback = vim.notify,
      })
    end,
  },
}
