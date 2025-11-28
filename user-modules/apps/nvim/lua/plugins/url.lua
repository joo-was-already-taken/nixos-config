return {
  "sontungexpt/url-open",
  opts = {
    open_app = "xdg-open",
    open_only_when_cursor_on_url = false,
    highlight_url = {
      all_urls = { enabled = false },
      cursor_move = { enabled = false },
    }
  },
  config = function(_, opts)
    local status_ok, url_open = pcall(require, "url-open")
    if not status_ok then
      return
    end
    url_open.setup(opts)
  end,
  keys = {
    { "<leader>go", "<cmd>URLOpenUnderCursor<CR>", mode = "n" },
  },
}
