return {
  -- UI Plugins
  { -- File Icons for Tree UI's
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").get_icons()
      require("nvim-web-devicons").setup({ color_icons = true })
    end,
  },
  { -- Visual Indentation Lines
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "┊",
        smart_indent_cap = true,
        highlight = {
          "Conditional",
          "Function",
          "Label",
        },
      },
      whitespace = {
        highlight = {
          "Whitespace",
          "NonText",
        },
      },
      scope = {
        enabled = true,
        char = "|",
        highlight = {
          "Conditional",
          "Function",
          "Label",
        },
        show_start = true,
        show_end = false,
      },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
    end,
  },
}
