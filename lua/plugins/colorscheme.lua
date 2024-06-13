return {
  -- Theme
  { -- Dracula
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1025,
    event = { "VimEnter", "BufReadPre", "BufNew", "BufNewFile" },
    config = function()
      require("dracula").setup()
      vim.cmd([[colorscheme dracula]])
    end,
  },
}
