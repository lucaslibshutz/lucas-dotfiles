return {
  "kkoomen/vim-doge",
  build = ":call doge#install()",
  init = function()
    vim.g.doge_doc_standard_python = "google"
  end,
  config = function()
    vim.api.nvim_create_user_command("Docstring", function()
      vim.cmd("DogeGenerate")
    end, {})

    vim.keymap.set("n", "<leader>cd", "<cmd>DogeGenerate<CR>", { desc = "Generate Docstring (doge)" })
  end,
}
