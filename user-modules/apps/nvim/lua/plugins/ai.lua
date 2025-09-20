return {
  "Exafunction/windsurf.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    vim.api.nvim_set_hl(0, "CodeiumSuggestion", { link = "Comment" })

    local codeium_enabled = false

    vim.api.nvim_create_user_command("EnableCodeium", function()
      require("codeium").setup({
        enable_cmp_source = false,

        virtual_text = {
          enabled = true,
          idle_delay = 0,
          key_bindings = {
            accept = "<C-l>",
          },
          accept_fallback = function()
            require("codeium.virtual_text").complete()
          end,
        },
      })

      codeium_enabled = true
      print("Codeium enabled")
    end, {})

    vim.api.nvim_create_user_command("DisableCodeium", function()
      if codeium_enabled then
        vim.cmd("Codeium Toggle")
        codeium_enabled = false
      end
    end, {})
  end,
}
