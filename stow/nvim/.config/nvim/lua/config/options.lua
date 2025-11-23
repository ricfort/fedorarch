-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enable transparency
vim.o.winblend = 20  -- Transparency for floating windows
vim.o.pumblend = 20  -- Transparency for popup menus

-- Force cmdline colors to match theme (override any blue defaults)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "japanese-paper",
  callback = function()
    vim.api.nvim_set_hl(0, "WildMenu", { fg = "#1a1612", bg = "#d4a574" })
    vim.api.nvim_set_hl(0, "CmdLine", { fg = "#d4c4b0", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CommandLine", { fg = "#d4c4b0", bg = "NONE" })
  end,
})