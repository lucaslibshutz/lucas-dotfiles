-- WSL-specific overrides and extra plugins

-- Clipboard: bridge Neovim clipboard to Windows clipboard via clip.exe / powershell.exe
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

return {
  -- Enhanced file tree (snacks explorer handles this in LazyVim, but nvim-tree as alternative)
  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- use treesitter for smarter pairs
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
      },
    },
  },

  -- Comment toggling (LazyVim bundles mini.comment, but ts-comments adds JSX support)
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },

  -- Surround motions
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Better escape
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      timeout = 200,
      default_mappings = false,
      mappings = {
        i = { j = { k = "<Esc>" } },
        c = { j = { k = "<Esc>" } },
        t = { j = { k = "<C-\\><C-n>" } },
        v = { j = { k = "<Esc>" } },
        s = { j = { k = "<Esc>" } },
      },
    },
  },

  -- Tmux navigator (seamless Ctrl+hjkl between nvim splits and tmux panes)
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp", "TmuxNavigateRight", "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
  },

  -- Oil.nvim: edit filesystem like a buffer (great complement to telescope)
  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = false, -- keep snacks/nvim-tree as default
      columns = { "icon", "permissions", "size", "mtime" },
      view_options = { show_hidden = true },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["q"] = "actions.close",
      },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Harpoon v2: quick file marks
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>H", function() require("harpoon"):list():add() end, desc = "Harpoon: add file" },
      { "<leader>h", function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end, desc = "Harpoon: menu" },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon: file 1" },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon: file 2" },
      { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon: file 3" },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon: file 4" },
    },
  },
}
