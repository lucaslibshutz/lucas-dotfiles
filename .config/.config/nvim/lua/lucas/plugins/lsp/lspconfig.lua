local lspconfig_status, lspconfig = pcall(require,"lspconfig")
if not lspconfig_status then return end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require,"cmp_nvim_lsp")
if not cmp_nvim_lsp_status then return end


local keymap = vim.keymap

-- enable keybinds for available lsp server
local on_attach = function(client,bufnr)
 

  local opts = { buffer = ev.buf }
  -- set keybinds
  keymap.set("n","gf","<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
  keymap.set("n","gD","<Cmd>lua vim.lsp.buf.declaration()<CR>",opts) -- go to delcaration
  keymap.set("n","gd","<cmd>Lspsaga peek_definition<CR>",opts) -- see definition and amke edits in window
  keymap.set("n","gi","<cmd>lua vim.lsp.buf.implementation()<CR>",opts) -- go to implementation
  keymap.set("n","<leader>ca","<cmd> Lspsaga code_action<CR>",opts) -- see available code actions
  keymap.set("n","<leader>rn","<cmd>Lspsaga rename<CR>",opts) -- smart rename 
  keymap.set("n","<leader>d","<cmd>Lspsaga show_line_diagnostics<CR>",opts) -- show diagnostics for line
  keymap.set("n","<leader>d","<cmd>Lspsaga show_cursor_diagnostics<CR>",opts) -- show diagnostics for cursor
  keymap.set("n","[d","<cmd>Lspsaga diagnostic_jump_prev",opts) -- jump to previous diagnostic in buffer
  keymap.set("n","]d","<cmd>Lspsaga diagnostic_jump_next",opts) -- jump to next diagnostic in buffer
  keymap.set("n","K","<cmd>Lspsaga hover_doc<CR>",opts) -- show documentation for what is under the cursor
  keymap.set("n","<leader>o","<cmd>LSoutlineToggle<CR>",opts) -- see outline on right hand side


  if client.name == "pyright" then
    return
  end
end

-- used to enable autocompletion
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig["html"].setup({
  capabilities = capabilities,
  on_attach = on_attach
})

lspconfig["pyright"].setup({
  capabilities = capabilities,
  on_attach = on_attach
})

lspconfig["lua_ls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = { -- custom settings for lua
    Lua = {
      -- make the lanugage server recognize "vim" global
      diagnostics = {
        globals = {"vim"},
      },
      workspace = {
        -- make language server aware of runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})

