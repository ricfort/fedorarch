-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Fix cmdline colors to match japanese-paper theme
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    if vim.g.colors_name == "japanese-paper" then
      vim.api.nvim_set_hl(0, "CmdLine", { fg = "#d4c4b0", bg = "NONE" })
      vim.api.nvim_set_hl(0, "CommandLine", { fg = "#d4c4b0", bg = "NONE" })
      vim.api.nvim_set_hl(0, "WildMenu", { fg = "#1a1612", bg = "#d4a574" })
      vim.api.nvim_set_hl(0, "CmdLineIcon", { fg = "#d4a574", bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmdLineIconSearch", { fg = "#d4a574", bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmdLineIconCursor", { fg = "#d4a574", bg = "NONE" })
    end
  end,
})
