-- japanese-paper colorscheme
local colors = {
  -- Base colors
  bg = "#1a1612",           -- Background (aged paper)
  fg = "#d4c4b0",           -- Foreground (text)
  accent = "#d4a574",       -- Accent (warm gold)
  border = "#5c4a3a",       -- Border/separator
  dark_bg = "#3a2e26",      -- Darker background

  -- Terminal colors (from alacritty config)
  black = "#5c4a3a",
  red = "#c49460",
  green = "#9db5a0",
  yellow = "#d4a574",
  blue = "#8b9db5",
  magenta = "#b5a5b5",
  cyan = "#a5b5b5",
  white = "#d4c4b0",

  -- Bright variants
  bright_black = "#6c5a4a",
  bright_red = "#d4a480",
  bright_green = "#adc5b0",
  bright_yellow = "#e4b480",
  bright_blue = "#9badc5",
  bright_magenta = "#c5b5b5",
  bright_cyan = "#b5c5c5",
  bright_white = "#e4d4c0",
}

vim.g.colors_name = "japanese-paper"

-- Clear existing highlights
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

-- Basic highlights with transparency
vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.fg, bg = "NONE", blend = 20 })
vim.api.nvim_set_hl(0, "NormalNC", { fg = colors.fg, bg = "NONE" })

-- Cursor and selection with transparency
vim.api.nvim_set_hl(0, "Cursor", { fg = colors.bg, bg = colors.accent })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE", blend = 10 })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.accent, bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "Visual", { bg = colors.border, blend = 30 })
vim.api.nvim_set_hl(0, "VisualNOS", { bg = colors.border, blend = 30 })

-- Line numbers
vim.api.nvim_set_hl(0, "LineNr", { fg = colors.border, bg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })

-- Status line
vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.border, bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineTerm", { fg = colors.fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineTermNC", { fg = colors.border, bg = "NONE" })

-- Windows and splits
vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.border, bg = "NONE" })
vim.api.nvim_set_hl(0, "VertSplit", { fg = colors.border, bg = "NONE" })

-- Search
vim.api.nvim_set_hl(0, "Search", { fg = colors.bg, bg = colors.accent })
vim.api.nvim_set_hl(0, "IncSearch", { fg = colors.bg, bg = colors.accent })
vim.api.nvim_set_hl(0, "CurSearch", { fg = colors.bg, bg = colors.accent })

-- Messages
vim.api.nvim_set_hl(0, "ErrorMsg", { fg = colors.red, bg = "NONE" })
vim.api.nvim_set_hl(0, "WarningMsg", { fg = colors.yellow, bg = "NONE" })
vim.api.nvim_set_hl(0, "ModeMsg", { fg = colors.accent, bg = "NONE" })
vim.api.nvim_set_hl(0, "MoreMsg", { fg = colors.accent, bg = "NONE" })

-- Popup menu with transparency
vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.fg, bg = "NONE", blend = 20 })
vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.bg, bg = colors.accent, blend = 0 })
vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "NONE", blend = 20 })
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = colors.border, blend = 20 })

-- Tabs
vim.api.nvim_set_hl(0, "TabLine", { fg = colors.border, bg = "NONE" })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TabLineSel", { fg = colors.accent, bg = "NONE", bold = true })

-- Syntax highlighting
vim.api.nvim_set_hl(0, "Comment", { fg = colors.border, italic = true })
vim.api.nvim_set_hl(0, "Constant", { fg = colors.accent })
vim.api.nvim_set_hl(0, "String", { fg = colors.green })
vim.api.nvim_set_hl(0, "Character", { fg = colors.green })
vim.api.nvim_set_hl(0, "Number", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "Boolean", { fg = colors.accent })
vim.api.nvim_set_hl(0, "Float", { fg = colors.yellow })

vim.api.nvim_set_hl(0, "Identifier", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "Function", { fg = colors.blue })

vim.api.nvim_set_hl(0, "Statement", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "Conditional", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "Repeat", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "Label", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "Operator", { fg = colors.fg })
vim.api.nvim_set_hl(0, "Keyword", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "Exception", { fg = colors.red })

vim.api.nvim_set_hl(0, "PreProc", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "Include", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "Define", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "Macro", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "PreCondit", { fg = colors.yellow })

vim.api.nvim_set_hl(0, "Type", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "StorageClass", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "Structure", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "Typedef", { fg = colors.cyan })

vim.api.nvim_set_hl(0, "Special", { fg = colors.accent })
vim.api.nvim_set_hl(0, "SpecialChar", { fg = colors.accent })
vim.api.nvim_set_hl(0, "Tag", { fg = colors.accent })
vim.api.nvim_set_hl(0, "Delimiter", { fg = colors.fg })
vim.api.nvim_set_hl(0, "SpecialComment", { fg = colors.border })
vim.api.nvim_set_hl(0, "Debug", { fg = colors.red })

vim.api.nvim_set_hl(0, "Underlined", { underline = true, fg = colors.accent })
vim.api.nvim_set_hl(0, "Ignore", { fg = colors.border })
vim.api.nvim_set_hl(0, "Error", { fg = colors.red, bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "Todo", { fg = colors.yellow, bg = "NONE", bold = true })

-- Diff
vim.api.nvim_set_hl(0, "DiffAdd", { fg = colors.green, bg = "NONE", blend = 20 })
vim.api.nvim_set_hl(0, "DiffChange", { fg = colors.yellow, bg = "NONE", blend = 20 })
vim.api.nvim_set_hl(0, "DiffDelete", { fg = colors.red, bg = "NONE", blend = 20 })
vim.api.nvim_set_hl(0, "DiffText", { fg = colors.accent, bg = "NONE", blend = 20 })

-- LSP
vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "NONE", blend = 20 })
vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "NONE", blend = 20 })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "NONE", blend = 20 })
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.red })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.blue })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.red })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = colors.yellow })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = colors.blue })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = colors.cyan })

-- Git signs
vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colors.green })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = colors.red })

-- Fold
vim.api.nvim_set_hl(0, "Folded", { fg = colors.border, bg = "NONE", blend = 10 })
vim.api.nvim_set_hl(0, "FoldColumn", { fg = colors.border, bg = "NONE" })

-- Match parenthesis
vim.api.nvim_set_hl(0, "MatchParen", { fg = colors.accent, bg = colors.dark_bg, bold = true })

-- Non-text
vim.api.nvim_set_hl(0, "NonText", { fg = colors.border })
vim.api.nvim_set_hl(0, "Whitespace", { fg = colors.border })

-- Terminal
vim.api.nvim_set_hl(0, "Terminal", { fg = colors.fg, bg = "NONE" })

-- Spell
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = colors.red })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = colors.yellow })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = colors.cyan })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = colors.blue })

-- Command line and messages
vim.api.nvim_set_hl(0, "MsgArea", { fg = colors.fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "ModeMsg", { fg = colors.accent, bg = "NONE" })
vim.api.nvim_set_hl(0, "MsgSeparator", { fg = colors.border, bg = "NONE" })
vim.api.nvim_set_hl(0, "MoreMsg", { fg = colors.accent, bg = "NONE" })

-- Command line (the blue text when you type :)
vim.api.nvim_set_hl(0, "CommandLine", { fg = colors.fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLine", { fg = colors.fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLineIcon", { fg = colors.accent, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLineIconSearch", { fg = colors.accent, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLineIconCursor", { fg = colors.accent, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePopup", { fg = colors.fg, bg = "NONE", blend = 20 })
vim.api.nvim_set_hl(0, "CmdLinePopupBorder", { fg = colors.border, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePopupTitle", { fg = colors.accent, bg = "NONE" })

-- WildMenu (autocomplete menu in cmdline - often blue)
vim.api.nvim_set_hl(0, "WildMenu", { fg = colors.bg, bg = colors.accent })
vim.api.nvim_set_hl(0, "CmdLinePopupBorderSearch", { fg = colors.accent, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePopupBorderHelp", { fg = colors.blue, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePopupBorderFilter", { fg = colors.yellow, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePopupBorderSubstitute", { fg = colors.green, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePopupBorderCmdline", { fg = colors.magenta, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePopupBorderCalculator", { fg = colors.cyan, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePopupBorderSearchInc", { fg = colors.accent, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePopupBorderScratch", { fg = colors.border, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePopupBorderLua", { fg = colors.blue, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePopupBorderInput", { fg = colors.green, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePopupBorderHistory", { fg = colors.yellow, bg = "NONE" })

-- Additional cmdline highlights
vim.api.nvim_set_hl(0, "CmdLinePrompt", { fg = colors.accent, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePromptSearch", { fg = colors.accent, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePromptFilter", { fg = colors.yellow, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePromptSubstitute", { fg = colors.green, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePromptCmdline", { fg = colors.magenta, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePromptCalculator", { fg = colors.cyan, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePromptSearchInc", { fg = colors.accent, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePromptScratch", { fg = colors.border, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePromptLua", { fg = colors.blue, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePromptInput", { fg = colors.green, bg = "NONE" })
vim.api.nvim_set_hl(0, "CmdLinePromptHistory", { fg = colors.yellow, bg = "NONE" })
