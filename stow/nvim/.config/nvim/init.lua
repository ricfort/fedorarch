local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "nvim-lualine/lualine.nvim" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "lewis6991/gitsigns.nvim" },
	{ "williamboman/mason.nvim", version = "*" },
	{ "williamboman/mason-lspconfig.nvim", version = "*" },
})

vim.cmd.colorscheme("japanese-paper")
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Configure lualine with Japanese Paper theme
require("lualine").setup({
	options = {
		theme = {
			normal = {
				a = { bg = "#3a2e26", fg = "#d4c4b0", gui = "bold" },
				b = { bg = "#3a2e26", fg = "#d4c4b0" },
				c = { bg = "#1a1612", fg = "#d4c4b0" },
			},
			insert = {
				a = { bg = "#3a2e26", fg = "#9db5a0", gui = "bold" },
				b = { bg = "#3a2e26", fg = "#9db5a0" },
				c = { bg = "#1a1612", fg = "#d4c4b0" },
			},
			visual = {
				a = { bg = "#3a2e26", fg = "#d4a574", gui = "bold" },
				b = { bg = "#3a2e26", fg = "#d4a574" },
				c = { bg = "#1a1612", fg = "#d4c4b0" },
			},
			replace = {
				a = { bg = "#3a2e26", fg = "#c49460", gui = "bold" },
				b = { bg = "#3a2e26", fg = "#c49460" },
				c = { bg = "#1a1612", fg = "#d4c4b0" },
			},
			command = {
				a = { bg = "#3a2e26", fg = "#8b9db5", gui = "bold" },
				b = { bg = "#3a2e26", fg = "#8b9db5" },
				c = { bg = "#1a1612", fg = "#d4c4b0" },
			},
			inactive = {
				a = { bg = "#1a1612", fg = "#5c4a3a", gui = "bold" },
				b = { bg = "#1a1612", fg = "#5c4a3a" },
				c = { bg = "#1a1612", fg = "#5c4a3a" },
			},
		},
		component_separators = { left = "│", right = "│" },
		section_separators = { left = "", right = "" },
	},
})

-- Modern LSP setup using Neovim 0.11+ API (vim.lsp.start)
-- LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Try to enhance capabilities with nvim-cmp if available
local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- LSP attach handler
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	
	-- Mappings
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
	vim.keymap.set("n", "<C-k>", function() vim.lsp.buf.signature_help() end, opts)
	vim.keymap.set("n", "<space>wa", function() vim.lsp.buf.add_workspace_folder() end, opts)
	vim.keymap.set("n", "<space>wr", function() vim.lsp.buf.remove_workspace_folder() end, opts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	vim.keymap.set("n", "<space>D", function() vim.lsp.buf.type_definition() end, opts)
	vim.keymap.set("n", "<space>rn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "<space>ca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
end

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "pyright", "ruff", "bashls" },
	automatic_installation = true,
	handlers = {
		-- Default handler for all servers
		function(server_name)
			vim.lsp.start({
				name = server_name,
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end,
		-- Custom handler for pyright
		pyright = function()
			vim.lsp.start({
				name = "pyright",
				cmd = { "pyright-langserver", "--stdio" },
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					python = {
						venvPath = ".venv",
						analysis = {
							typeCheckingMode = "basic",
						},
					},
				},
			})
		end,
	},
})
