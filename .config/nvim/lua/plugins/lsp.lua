return {
    {
        "neovim/nvim-lspconfig",
        opts = {
          servers = {
            pyright = {
              mason = false, -- Prevent Mason from managing/reinstalling Pyright
              autostart = false, -- Prevent Pyright from automatically starting
            },
            ruff = {}
          },
        },
      },
    }
