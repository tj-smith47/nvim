return {
  { -- Fancier statusline
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "Mofiqul/dracula.nvim" },
    opts = {
      options = {
        icons_enabled = true,
        theme = "dracula-nvim",
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = {
          "mode",
        },
        lualine_b = {
          "branch",
          "diff",
          "diagnostics",
        },
        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },
        lualine_x = {
          "encoding",
          "fileformat",
          "filetype",
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = "#ff9e64" },
          },
        },
      },
    },
    config = function(_, opts)
      require("lualine").setup(opts)
    end,
  },
}
