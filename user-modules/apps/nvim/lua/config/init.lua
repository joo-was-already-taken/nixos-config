local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("config.globals")
require("config.options")
require("config.keymaps")

local function concurrent_tasks()
  local available_parallelism = 64;
  if vim.uv ~= nil then
    available_parallelism = vim.uv.available_prallelism()
  end
  return math.min(available_parallelism, 4)
end

local opts = {
  concurrency = concurrent_tasks(),
}

require("lazy").setup({
	{ import = "plugins" },
}, opts)
