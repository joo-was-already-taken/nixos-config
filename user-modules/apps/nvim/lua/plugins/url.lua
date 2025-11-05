return {
  "sontungexpt/url-open",
  opts = {
    open_app = "xdg-open",
    open_only_when_cursor_on_url = false,
  },
  config = function(_, opts)
    local status_ok, url_open = pcall(require, "url-open")
    if not status_ok then
      return
    end
    url_open.setup(opts)
  end,
  keys = {
    { "<CR>", "<cmd>URLOpenUnderCursor<CR>", mode = "n" },
  },
}
