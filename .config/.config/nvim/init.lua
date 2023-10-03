require("lucas.core.options")
require("lucas.core.keymaps")
require("lucas.core.colorscheme")
require("lucas.plugins-setup")
require("lucas.plugins.comment")
require("lucas.plugins.nvim-tree")
require("lucas.plugins.lualine")
require("lucas.plugins.telescope")
require("lucas.plugins.nvim-cmp")
require("lucas.plugins.lsp.mason")
require("lucas.plugins.lsp.lspconfig")
require("lucas.plugins.autoclose")

vim.cmd[[ autocmd FileType markdown setlocal wrap ]]
vim.cmd[[ autocmd Filetype markdown setlocal linebreak ]]
