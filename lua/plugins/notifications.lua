return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        event = "UIEnter",
        config = function()
          local notify = require("notify")
          notify.setup({
            timeout = 5000,
            top_down = true,
            stages = "slide",
            fps = 60,
          })
          vim.notify = notify
        end,
      },
      -- {
      --   "mrded/nvim-lsp-notify",
      --   dependencies = { "rcarriga/nvim-notify" },
      --   config = function()
      --     require("lsp-notify").setup({
      --       -- notify = require("notify"),
      --     })
      --   end,
      -- },
    },
    condig = function()
      local cmdline_opts = {
        border = {
          style = "rounded",
        },
        size = {
          min_width = 200,
        },
      }
      require("notify").setup()
      require("noice").setup({
        cmdline = {
          view = "cmdline_popup",
          format = {
            cmdline = { pattern = "^:", icon = "", opts = cmdline_opts },
            search_down = { view = "cmdline", kind = "Search", pattern = "^/", icon = "🔎 ", ft = "regex" },
            search_up = { view = "cmdline", kind = "Search", pattern = "^%?", icon = "🔎 ", ft = "regex" },
            input = { icon = "✏️ ", ft = "text", opts = cmdline_opts },
            calculator = { pattern = "^=", icon = "", lang = "vimnormal", opts = cmdline_opts },
            substitute = {
              pattern = "^:%%?s/",
              icon = "🔁",
              ft = "regex",
              opts = { border = { text = { top = " sub (old/new/) " } } },
            },
            filter = { pattern = "^:%s*!", icon = "$", ft = "sh", opts = cmdline_opts },
            filefilter = { kind = "Filter", pattern = "^:%s*%%%s*!", icon = "📄 $", ft = "sh", opts = cmdline_opts },
            selectionfilter = {
              kind = "Filter",
              pattern = "^:%s*%'<,%'>%s*!",
              icon = " $",
              ft = "sh",
              opts = cmdline_opts,
            },
            lua = { pattern = "^:%s*lua%s+", icon = "", conceal = true, ft = "lua", opts = cmdline_opts },
            -- rename = {
            --   pattern = "^:%s*IncRename%s+",
            --   icon = "✏️ ",
            --   conceal = true,
            --   opts = {
            --     relative = "cursor",
            --     size = { min_width = 20 },
            --     position = { row = -3, col = 0 },
            --     buf_options = { filetype = "text" },
            --     border = { text = { top = " rename " } },
            --   },
            -- },
            help = { pattern = "^:%s*h%s+", icon = "💡", opts = cmdline_opts },
          },
        },
        lsp = {
          progress = {
            enabled = true,
            view = "notify",
          },
          hover = {
            enabled = true,
            view = "notify",
          },
          signature = {
            enabled = true,
            view = "notify",
          },
        },
        views = {
          mini = {
            size = {
              width = 120,
            },
            win_options = {
              winblend = 50,
            },
          },
          confirm = {
            size = {
              width = 120,
            },
          },
          cmdline = {
            size = {
              width = 120,
            },
          },
          cmdline_input = {
            size = {
              width = 120,
            },
          },
          cmdline_popup = {
            size = {
              width = 120,
            },
          },
        },
        routes = {
          -- { filter = { find = "E162" }, view = "mini" },
          { filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
          { filter = { event = "msg_show", find = "search hit BOTTOM" }, skip = true },
          { filter = { event = "msg_show", find = "search hit TOP" }, skip = true },
          { filter = { event = "emsg", find = "E23" }, skip = true },
          { filter = { event = "emsg", find = "E20" }, skip = true },
          { filter = { find = "No signature help" }, skip = true },
          { filter = { find = "E37" }, skip = true },
        },
      })
    end,
  },
  -- {
  --   "j-hui/fidget.nvim",
  --   config = function()
  --     require("fidget").setup({
  --       integration = {
  --         ["nvim-tree"] = {
  --           enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
  --         },
  --       },
  --       notification = {
  --         override_vim_notify = true,
  --         -- Conditionally redirect notifications to another backend
  --         redirect = function(msg, level, opts)
  --           if opts and opts.on_open then
  --             return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
  --           end
  --         end,
  --         window = {
  --           align = "bottom",
  --           border = "rounded",
  --           winblend = 50,
  --           x_padding = 4,
  --           y_padding = 2,
  --         },
  --       },
  --     })
  --   end,
  -- },
}
