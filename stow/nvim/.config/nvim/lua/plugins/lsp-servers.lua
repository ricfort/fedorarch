return {
  "neovim/nvim-lspconfig",
  ---@class LspOpts
  opts = function(_, opts)
    -- Extend servers list properly
    opts.servers = opts.servers or {}
    
    -- Add our servers
    opts.servers.pyright = opts.servers.pyright or {}
    opts.servers.ruff_lsp = opts.servers.ruff_lsp or {}
    opts.servers.bashls = opts.servers.bashls or {}
    
    -- Setup function for pyright
    opts.setup = opts.setup or {}
    opts.setup.pyright = function(_, server_opts)
      server_opts.cmd = { "pyright-langserver", "--stdio" }
      server_opts.settings = {
        python = {
          venvPath = ".venv",
          analysis = {
            typeCheckingMode = "basic",
          },
        },
      }
      return true -- Return true to indicate that we handled the setup
    end
    
    return opts
  end,
}
