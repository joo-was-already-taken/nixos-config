---@param file_name string
---@return string?
local function template_from_file(file_name)
  local source_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
  local path = source_dir .. file_name
  local f = io.open(path, "r")
  if f == nil then
    return nil
  end
  local content = f:read("all")
  f:close()
  return content
end

local templates = {
  jupyter_flake = template_from_file("insert_templates/jupyter_flake.nix")
}

vim.api.nvim_create_user_command("Insert", function(opts)
  local text = templates[opts.args]
  if text == nil then
    vim.notify(
      "Could not find \"" .. text .. "\" template for insertion",
      vim.log.levels.ERROR
    )
  end
  local lines = vim.split(text, "\n")
  vim.api.nvim_put(lines, "l", true, false)
end, { nargs = 1 })
