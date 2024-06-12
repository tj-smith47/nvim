return {
  -- Vim UX Plugins
  { -- Format on Save
    "elentok/format-on-save.nvim",
    config = function()
      require("format-on-save").setup({
        experiments = {
          partial_update = "diff", -- or 'line-by-line'
        },
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
  { "rrethy/vim-illuminate" },
  { -- Detect / adjust tabbing automatically
    -- (expandtab, shiftwidth, tabstop, textwidth,
    --  endofline, fileformat, filenencoding, bomb)
    "tpope/vim-sleuth",
  },
}
