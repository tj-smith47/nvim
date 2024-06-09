return {
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'nvim-lua/plenary.nvim',
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      "tpope/vim-fugitive",
      "folke/trouble.nvim",
    },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    config = function(_, opts)
      require('gitsigns').setup(opts)
    end,
  },
  {
    'kessejones/git-blame-line.nvim',
    opts = {
      git = {
        default_message = 'Not committed yet',
        blame_format = '%an - %ar - %s' -- see https://git-scm.com/docs/pretty-formats
      },
      view = {
        left_padding_size = 5,
        enable_cursor_hold = false
      }
    },
    config = function(_, opts)
      require('git-blame-line').setup()
    end,
  },
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
  }
}
