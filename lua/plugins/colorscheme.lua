return {
  -- Theme
  { -- Dracula
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1025,
    event = { "VimEnter", "BufRead", "BufNew", "BufNewFile", "UIEnter", "BufEnter" },
    config = function()
      require("dracula").setup()
      vim.cmd([[
        syntax enable
        colorscheme dracula
      ]])
    end,
  },
}
