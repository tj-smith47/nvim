return {
  -- Theme
  { -- Dracula
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    event = { "VimEnter" },
    config = function()
      require("dracula").setup()
      vim.cmd([[colorscheme dracula]])
    end,
  },
}
