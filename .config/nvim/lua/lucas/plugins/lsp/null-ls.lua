local setup, null_ls = pcall(require,"null-ls")
if not setup then return end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  sources = {
    diagnostics.eslint_d,
    diagnostics.pylint,
  }
})
