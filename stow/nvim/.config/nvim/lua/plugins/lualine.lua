return {
  "nvim-lualine/lualine.nvim",
  opts = {
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
  },
}
