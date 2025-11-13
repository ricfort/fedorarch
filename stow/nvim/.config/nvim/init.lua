local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "nvim-lualine/lualine.nvim" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "lewis6991/gitsigns.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
})

vim.cmd.colorscheme("catppuccin-mocha")
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "pyright", "ruff", "bashls" },
	automatic_installation = true,
})

local lsp = require("lspconfig")
lsp.pyright.setup({ settings = { python = { venvPath = ".venv" } } })
lsp.ruff.setup({})
lsp.bashls.setup({})
