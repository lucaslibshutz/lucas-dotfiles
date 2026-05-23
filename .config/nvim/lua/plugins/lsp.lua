return {
    {
        "neovim/nvim-lspconfig",
        opts = {
          servers = {
            pyright = {
              mason = false, -- Prevent Mason from managing/reinstalling Pyright
              autostart = false, -- Prevent Pyright from automatically starting
            },
            ruff = {},
            arduino_language_server = {
              cmd = {
                "arduino-language-server",
                "--cli", "arduino-cli",
                "--cli-config", "/Users/lucaslibshutz/Library/Arduino15/arduino-cli.yaml",
                "--clangd", "/usr/bin/clangd",
                "-fqbn", "arduino:avr:uno"
              },
            },
            texlab = {
              settings = {
                texlab = {
                  inlayHints = {
                    labelDefinitions = false,
                    labelReferences = false,
                  },
                },
              },
            },
          },
        },
      },
    }
