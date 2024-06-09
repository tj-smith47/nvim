return {
  -- Theme
  { -- Dracula
    'Mofiqul/dracula.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('dracula').setup()
      vim.cmd [[colorscheme dracula]]
    end,
  },

  -- Vim UX Plugins
  { -- Use "gc" to comment visual regions/lines
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },
  { -- Format on Save
    "elentok/format-on-save.nvim",
    config = function()
      require("format-on-save").setup({
        experiments = {
          partial_update = 'diff', -- or 'line-by-line'
        }
      })
    end,
  },
  { -- Move Selection
    'echasnovski/mini.move',
    config = function()
      require('mini.move').setup()
    end,
  },
  { -- Dim Unused Objects
    'zbirenbaum/neodim',
    event = 'LspAttach',
    config = function()
      require('neodim').setup({
        refresh_delay = 75, -- time in ms to wait after typing before refresh diagnostics
        alpha = .75,
        blend_color = "#000000",
        hide = { underline = true, virtual_text = true, signs = true },
        disable = {}, -- table of filetypes to disable neodim
      })
    end,
  },
  { -- Open URL under cursor w/ `gx`
    "sontungexpt/url-open",
    event = "VeryLazy",
    cmd = "URLOpenUnderCursor",
    config = function()
      local status_ok, url_open = pcall(require, "url-open")
      if not status_ok then
        return
      end
      url_open.setup({})
    end,
  },
  { 'rrethy/vim-illuminate' },
  { -- Detect / adjust tabbing automatically
    -- (expandtab, shiftwidth, tabstop, textwidth,
    --  endofline, fileformat, filenencoding, bomb)
    'tpope/vim-sleuth',
  },
}
