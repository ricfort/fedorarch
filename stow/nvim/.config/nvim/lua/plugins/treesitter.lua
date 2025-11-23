-- Treesitter configuration
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Extend the default parsers with additional ones
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "lua",
        "python",
        "markdown",
        "markdown_inline",
        "json",
        "yaml",
        "vim",
        "regex",
        "query",
      })
    end,
  },
}

