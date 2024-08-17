return {
  { -- File Explorer
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        -- filters = {
        --   git_ignored = false,
        -- },
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
