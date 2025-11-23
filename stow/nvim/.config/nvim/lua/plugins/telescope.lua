-- Telescope configuration with transparency
return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        -- Transparency for floating windows
        winblend = 20,
      },
    },
  },
}

