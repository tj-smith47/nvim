return {
  -- Autocompletion Plugins
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdLineEnter" },
  dependencies = {
    "amarakon/nvim-cmp-buffer-lines",
    {
      "David-Kunz/cmp-npm",
      dependencies = { "nvim-lua/plenary.nvim" },
      ft = "json",
      opts = {},
    },
    "dmitmel/cmp-cmdline-history",
    "FelipeLema/cmp-async-path",
    -- TODO: Lookup https://github.com/garyhurtz/cmp_kitty
    -- {
    --   "garyhurtz/cmp_kitty",
    --   dependencies = {
    --     { "hrsh7th/nvim-cmp" },
    --   },
    --   init = function()
    --     require("cmp_kitty"):setup()
    --   end,
    -- },
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-copilot",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lua",
    { -- Snippets engine
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = {
        "saadparwaiz1/cmp_luasnip", -- for autocompletion
        {
          "doxnit/cmp-luasnip-choice",
          opts = {
            auto_open = false,
          },
        },
        "rafamadriz/friendly-snippets",
      },
    },
    { -- Autocomplete for new nvim plugins as deps
      "KadoBOT/cmp-plugins",
      opts = {
        files = {
          ".*\\.lua",
        },
      },
    },
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    "SergioRibera/cmp-dotenv",
    "rcarriga/nvim-dap-ui",
    {
      "ray-x/lsp_signature.nvim",
      opts = {
        auto_open = false,
        bind = true,
        doc_lines = 2,
        floating_window = true,
        handler_opts = {
          border = "single",
        },
        hint_enable = true,
        hint_prefix = " ",
        hint_scheme = "String",
        hi_parameter = "Search",
        max_height = 12,
        max_width = 120,
        transpancy = 50,
        zindex = 200,
      },
    },
    { -- vs-code like pictograms
      "onsails/lspkind.nvim",
    },
    { -- Python package versions completions
      "vrslev/cmp-pypi",
      dependencies = { "nvim-lua/plenary.nvim" },
      ft = "toml",
    },
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_lua").load()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("dapui").setup()

    cmp.setup({
      experimental = {
        ghost_text = false,
      },
      completion = { completeopt = "menu,menuone" },
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        fields = {
          "abbr",
          "kind",
          "menu",
        },
        expandable_indicator = true,
        format = function(entry, item)
          if vim.tbl_contains({ "path" }, entry.source.name) then
            local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
            if icon then
              item.kind = icon
              item.kind_hl_group = hl_group
              return item
            end
          end
          if vim.tbl_contains({ "cmdline" }, entry.source.name) then
            local buffer = vim.api.nvim_get_current_buf()
            if type(buffer) == "noice" then
              -- Get the completion entry text shown in the completion window.
              local content = item.abbr
              local icon = item.kind

              -- Set the fixed completion window width.
              local fixed_width = 119
              local kind_offset = 10
              local scrollbar_offset = 1
              vim.o.pumwidth = fixed_width

              -- Get the width of the current window.
              local win_width = vim.api.nvim_win_get_width(0)

              -- Set the max content width based on either: 'fixed_width'
              -- or a percentage of the window width, in this case 20%.
              -- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
              local max_content_width = fixed_width and fixed_width - kind_offset or math.floor(win_width * 0.2)

              -- Truncate the completion entry text if it's longer than the
              -- max content width. We subtract 3 from the max content width
              -- to account for the "..." that will be appended to it.
              if #content > max_content_width then
                item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
              else
                item.abbr = content .. (" "):rep(max_content_width - #content)
              end

              if icon and #icon < kind_offset then
                item.kind = (" "):rep(kind_offset - #icon - scrollbar_offset) .. icon
              end
            end
          end
          return lspkind.cmp_format()(entry, item)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<Shift-Shift>"] = cmp.mapping.close(),
        ["<C-C"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion

        -- Copilot integration
        -- ["<C-g>"] = cmp.mapping(function(fallback)
        ["<Tab>"] = cmp.mapping(function(fallback)
          vim.api.nvim_feedkeys(
            vim.fn["copilot#Accept"](vim.api.nvim_replace_termcodes("<Tab>", true, true, true)),
            "n",
            true
          )
        end),

        -- Custom Mappings
        ["<PageDown>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<PageUp>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      -- configure how nvim-cmp interacts with snippet engine
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp",                priority = 9 },
        { name = "luasnip",                 priority = 8 },
        { name = "luasnip_choice",          priority = 7 },
        { name = "nvim_lsp_signature_help", priority = 6 },
        { name = "nvim_lua",                priority = 5, ft = "lua" },
        { name = "copilot",                 priority = 3 },
        { name = "nvim_dap_python",         priority = 5, ft = "python" },
        { name = "nvim_dap",                priority = 5 },
        { name = "lazydev",                 priority = 4, ft = "lua" },
        { name = "plugins",                 priority = 5, ft = "lua" },
      }, {
        { name = "dotenv" },
        { name = "emoji" },
      }, {
        { name = "pypi", keyword_length = 4, ft = "toml" },
        { name = "npm",  keyword_length = 4, ft = "json" },
      }, {
        -- { name = "cmp_kitty" },
        { name = "cmdline" }, -- command line history
        { name = "buffer" },  -- text within current buffer
        -- { name = "async_path" }, -- file system paths
      }),

      view = {
        -- docs = {
        --   auto_open = true,
        -- },
      },
      window = {
        completion = cmp.config.window.bordered({
          winhighlight =
          "Normal:NoiceCompletionItemMenu,FloatBorder:NoiceCmdLinePopupBorder,CursorLine:PmenuSel,Search:None",
          col_offset = -2,
          side_padding = 0,
        }),
        documentation = cmp.config.window.bordered({
          winhighlight =
          "Normal:NoiceCompletionItemMenu,FloatBorder:NoiceCmdLinePopupBorder,CursorLine:PmenuSel,Search:None",
        }),
      },
    })

    -- local api = require("cmp.utils.api")
    -- local config = require("cmp.config")
    -- local window = require("cmp.utils.window")
    -- local completion = config.get().window.completion
    -- local border_info = window.get_border_info({ style = completion })
    --
    -- local delta = 0
    -- if not config.get().view.entries.follow_cursor then
    --   local cursor_before_line = api.get_cursor_before_line()
    --   delta = vim.fn.strdisplaywidth(cursor_before_line:sub(-4))
    -- end
    -- local pos = api.get_screen_cursor()
    -- local row, col = pos[1], pos[2] - delta - 1

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
      sources = {
        { name = "nvim_lsp_document_symbol" },
        {
          name = "buffer",
          option = { keyword_pattern = [[\k\+]] },
        },
        { name = "buffer-lines" },
      },
      view = {
        docs = {
          max_width = 120,
          min_width = 60,
        },
      },
    })

    cmp.setup.cmdline({ ":" }, {
      mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
      sources = {
        { name = "cmdline" },
        { name = "cmdline_history" },
        { name = "async_path" },
      },
      view = {
        docs = {
          max_width = 120,
          min_width = 60,
        },
      },
    })

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
