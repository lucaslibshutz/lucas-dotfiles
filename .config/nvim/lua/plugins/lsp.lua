-- WSL LSP configuration
-- Assumes Mason manages installations: run :MasonInstall <server> as needed
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Global LSP settings
      inlay_hints = { enabled = true },
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      servers = {
        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ruff = {}, -- fast Python linter/formatter

        -- JavaScript / TypeScript
        ts_ls = {},
        eslint = {},

        -- Lua (for Neovim config itself)
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enabled = false },
              completion = { callSnippet = "Replace" },
            },
          },
        },

        -- Web
        html = {},
        cssls = {},
        tailwindcss = {},

        -- Data / config
        jsonls = {},
        yamlls = {},

        -- Shell
        bashls = {},

        -- C/C++ (useful for WSL dev)
        clangd = {},

        -- Go
        gopls = {},

        -- Markdown
        marksman = {},
      },
    },
  },

  -- Mason: auto-install LSP servers
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP
        "pyright",
        "ruff",
        "typescript-language-server",
        "eslint-lsp",
        "lua-language-server",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "yaml-language-server",
        "bash-language-server",
        "clangd",
        "gopls",
        "marksman",
        -- Formatters
        "stylua",
        "prettier",
        "black",
        "isort",
        "shfmt",
        -- Linters
        "selene",
        "shellcheck",
      },
    },
  },
}
