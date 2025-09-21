local M = {}

function M.keymap_set(mode, new, prev)
  local opts = { noremap = true, silent = true }
  vim.keymap.set(mode, new, prev, opts)
end

local function submap(mode, callbacks)
  local function execute(callback)
    if type(callback) == "function" then
      callback()
    elseif type(callback) == "string" then
      local keys = vim.api.nvim_replace_termcodes(callback, true, false, true)
      vim.api.nvim_feedkeys(keys, mode, true)
    else
      error("Submap: invalid callback")
    end
  end

  while true do
    local key = vim.fn.getcharstr()
    local callback = callbacks[key]

    if callback == nil then
      return
    elseif type(callback) == "table" then
      execute(callback[1])
      if callback.exit then return end
    else
      execute(callback)
    end

    vim.cmd.redraw()
  end
end

function M.create_submap(mode, callbacks)
  return function() submap(mode, callbacks) end
end

return M
