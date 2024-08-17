return {
  -- Vim UX Plugins
  { -- Format on Save
    "elentok/format-on-save.nvim",
    config = function()
      local fmt_on_save = require("format-on-save")
      local formatters = require("format-on-save.formatters")

      fmt_on_save.setup({
        stderr_loglevel = vim.log.levels.OFF,
        formatter_by_ft = {
          python = {
            formatters.remove_trailing_whitespace,
            formatters.black,
            formatters.ruff,
          },
          -- go = {
          --   formatters.shell({
          --     cmd = { "goimports-reviser", "-rm-unused", "-set-alias", "-format", "%" },
          --     tempfile = function()
          --       return vim.fn.expand("%") .. ".formatter-temp"
          --     end,
          --   }),
          --   formatters.shell({ cmd = { "gofumpt" } }),
          -- },
        },
        experiments = {
          partial_update = "diff", -- or 'line-by-line'
        },
      })
    end,
  },
  { -- Open URL under cursor w/ `gx`
    "https://github.com/sontungexpt/url-open",
    event = "VeryLazy",
    cmd = "URLOpenUnderCursor",
    config = function()
      local status_ok, url_open = pcall(require, "url-open")
      if not status_ok then
        return
      end
      url_open.setup({
        extra_patterns = {
          {
            pattern = '["]([^%s]*)["]:%s*"[^"]*%d[%d%.]*"',
            prefix = "https://github.com/",
            suffix = "",
            excluded_file_patterns = nil,
          },
        },
      })
    end,
  },
  { "rrethy/vim-illuminate" },
  { -- Detect / adjust tabbing automatically
    -- (expandtab, shiftwidth, tabstop, textwidth,
    --  endofline, fileformat, filenencoding, bomb)
    "tpope/vim-sleuth",
  },
}
