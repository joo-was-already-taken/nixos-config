require("lualine").setup({
  options = {
    globalstatus = true,
    component_separators = "|",
    section_separators = "",
  },
  sections = {
    lualine_b = {
      "branch",
      "diff",
      {
        "diagnostics",
        symbols = {
          error = "E",
          warn = "W",
          info = "I",
          hint = "H",
        },
      },
    },
  },
})
