return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  config = function()
    local keymap_set = require("utils").keymap_set
    local create_submap = require("utils").create_submap

    local splits = require("smart-splits")
    splits.setup({
      default_amount = 5,
    })

    keymap_set("n", "<leader>s", create_submap("n", {
      ["-"] = { "<cmd>split<CR>", exit = true },
      ["|"] = { "<cmd>vsplit<CR>", exit = true },
      ["="] = { "<C-w>=", exit = true },

      ["h"] = splits.resize_left,
      ["j"] = splits.resize_down,
      ["k"] = splits.resize_up,
      ["l"] = splits.resize_right,

      ["H"] = { splits.swap_buf_left, exit = true },
      ["J"] = { splits.swap_buf_down, exit = true },
      ["K"] = { splits.swap_buf_up, exit = true },
      ["L"] = { splits.swap_buf_right, exit = true },
    }))
  end,
}
