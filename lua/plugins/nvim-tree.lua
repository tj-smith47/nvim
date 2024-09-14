return {
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").get_icons()
      require("nvim-web-devicons").setup({ color_icons = true })
    end,
  },
  { -- File Explorer
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        -- filters = {
        --   git_ignored = false,
        -- },
        renderer = {
          icons = {
            web_devicons = {
              file = {
                enable = true,
                color = true,
              },
              folder = {
                enable = true,
                color = true,
              },
            },
            -- glyphs = {
            --   git = {
            --     {
            --       unstaged = "✗",
            --       staged = "✓",
            --       unmerged = "",
            --       renamed = "➜",
            --       untracked = "★",
            --       deleted = "",
            --       ignored = "◌",
            --     },
            --   },
            -- },
          },
        },
        view = {
          width = 35,
        },

        -- For project.nvim (Telescope)
        respect_buf_cwd = true,
        -- sync_root_with_cwd = true,
        update_focused_file = {
          -- enable = true,
          -- update_root = true,
        },
      })
    end,
  },
}
