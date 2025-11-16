-- Japanese Paper Theme for Neovim
-- Colors matching the Japanese Paper aesthetic

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
	magenta = "#b5a5a5",
	cyan = "#a5b5b5",
	white = "#d4c4b0",
	
	-- Bright variants
	bright_black = "#6c5a4a",
	bright_red = "#d4a480",
	bright_green = "#adc5b0",
	bright_yellow = "#e4b584",
	bright_blue = "#9badc5",
	bright_magenta = "#c5b5b5",
	bright_cyan = "#b5c5c5",
	bright_white = "#e4d4c0",
}

local function setup()
	vim.g.colors_name = "japanese-paper"
	
	-- Clear existing highlights
	vim.cmd("highlight clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end
	
	-- Basic highlights
	vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
	vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.fg, bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "NormalNC", { fg = colors.fg, bg = colors.bg })
	
	-- Cursor and selection
	vim.api.nvim_set_hl(0, "Cursor", { fg = colors.bg, bg = colors.accent })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.accent, bg = colors.dark_bg, bold = true })
	vim.api.nvim_set_hl(0, "Visual", { bg = colors.border })
	vim.api.nvim_set_hl(0, "VisualNOS", { bg = colors.border })
	
	-- Line numbers
	vim.api.nvim_set_hl(0, "LineNr", { fg = colors.border, bg = colors.bg })
	vim.api.nvim_set_hl(0, "SignColumn", { bg = colors.bg })
	
	-- Status line
	vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.fg, bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.border, bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "StatusLineTerm", { fg = colors.fg, bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "StatusLineTermNC", { fg = colors.border, bg = colors.dark_bg })
	
	-- Windows and splits
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.border, bg = colors.bg })
	vim.api.nvim_set_hl(0, "VertSplit", { fg = colors.border, bg = colors.bg })
	
	-- Search
	vim.api.nvim_set_hl(0, "Search", { fg = colors.bg, bg = colors.accent })
	vim.api.nvim_set_hl(0, "IncSearch", { fg = colors.bg, bg = colors.accent })
	vim.api.nvim_set_hl(0, "CurSearch", { fg = colors.bg, bg = colors.accent })
	
	-- Messages
	vim.api.nvim_set_hl(0, "ErrorMsg", { fg = colors.red, bg = colors.bg })
	vim.api.nvim_set_hl(0, "WarningMsg", { fg = colors.yellow, bg = colors.bg })
	vim.api.nvim_set_hl(0, "ModeMsg", { fg = colors.accent, bg = colors.bg })
	vim.api.nvim_set_hl(0, "MoreMsg", { fg = colors.accent, bg = colors.bg })
	
	-- Popup menu
	vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.fg, bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.bg, bg = colors.accent })
	vim.api.nvim_set_hl(0, "PmenuSbar", { bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "PmenuThumb", { bg = colors.border })
	
	-- Tabs
	vim.api.nvim_set_hl(0, "TabLine", { fg = colors.border, bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "TabLineFill", { bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "TabLineSel", { fg = colors.accent, bg = colors.bg, bold = true })
	
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
	vim.api.nvim_set_hl(0, "Error", { fg = colors.red, bg = colors.bg, bold = true })
	vim.api.nvim_set_hl(0, "Todo", { fg = colors.yellow, bg = colors.bg, bold = true })
	
	-- Diff
	vim.api.nvim_set_hl(0, "DiffAdd", { fg = colors.green, bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "DiffChange", { fg = colors.yellow, bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "DiffDelete", { fg = colors.red, bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "DiffText", { fg = colors.accent, bg = colors.dark_bg })
	
	-- LSP
	vim.api.nvim_set_hl(0, "LspReferenceText", { bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = colors.dark_bg })
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
	vim.api.nvim_set_hl(0, "Folded", { fg = colors.border, bg = colors.dark_bg })
	vim.api.nvim_set_hl(0, "FoldColumn", { fg = colors.border, bg = colors.bg })
	
	-- Match parenthesis
	vim.api.nvim_set_hl(0, "MatchParen", { fg = colors.accent, bg = colors.dark_bg, bold = true })
	
	-- Non-text
	vim.api.nvim_set_hl(0, "NonText", { fg = colors.border })
	vim.api.nvim_set_hl(0, "Whitespace", { fg = colors.border })
	
	-- Terminal
	vim.api.nvim_set_hl(0, "Terminal", { fg = colors.fg, bg = colors.bg })
	
	-- Spell
	vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = colors.red })
	vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = colors.yellow })
	vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = colors.cyan })
	vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = colors.blue })
end

setup()

