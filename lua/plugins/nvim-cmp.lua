return {
  -- Autocompletion Plugins
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- TODO: Lookup https://github.com/garyhurtz/cmp_kitty
    "amarakon/nvim-cmp-buffer-lines",
    {
      "David-Kunz/cmp-npm",
      dependencies = { "nvim-lua/plenary.nvim" },
      ft = "json",
      config = function()
        require("cmp-npm").setup({})
      end,
    },
    "dmitmel/cmp-cmdline-history",
    "FelipeLema/cmp-async-path",
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
    "hrsh7th/cmp-copilot",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lua",
    -- "hrsh7th/cmp-path", -- source for file system paths
    { -- Snippets engine
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = {
        "saadparwaiz1/cmp_luasnip", -- for autocompletion
        {
          "doxnit/cmp-luasnip-choice",
          config = function()
            require("cmp_luasnip_choice").setup({
              -- Automatically open nvim-cmp on choice node (default: true)
              auto_open = false,
            })
          end,
        },
        "rafamadriz/friendly-snippets",
      },
    },
    { -- Autocomplete for new nvim plugins as deps
      "KadoBOT/cmp-plugins",
      config = function()
        require("cmp-plugins").setup({
          files = { ".*\\.lua" }, -- default
        })
      end,
    },
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    "SergioRibera/cmp-dotenv",
    "rcarriga/nvim-dap-ui",
    "ray-x/lsp_signature.nvim",
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
    require("luasnip.loaders.from_vscode").lazy_load()
    require("dapui").setup()

    cmp.setup({
      -- completion = {
      --   completeopt = "menu,menuone,preview,noselect",
      -- },
      experimental = {
        ghost_text = false,
      },
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        fields = {
          "abbr",
          "kind",
          "menu",
        },
        expandable_indicator = true,
        format = function(entry, vim_item)
          if vim.tbl_contains({ "path" }, entry.source.name) then
            local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
            if icon then
              vim_item.kind = icon
              vim_item.kind_hl_group = hl_group
              return vim_item
            end
          end
          return lspkind.cmp_format()(entry, vim_item)
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
        ["<C-g>"] = cmp.mapping(function(fallback)
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
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "luasnip_choice" },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lua" },
        { name = "copilot" },
        { name = "lazydev" },
      }, {
        { name = "nvim_dap" },
        { name = "nvim_dap_python" },
      }, {
        { name = "plugins" },
        { name = "dotenv" },
      }, {
        { name = "pypi", keyword_length = 4 },
        { name = "npm", keyword_length = 4 },
      }, {
        -- { name = "cmp_kitty" },
        { name = "cmdline" }, -- command line history
        { name = "buffer" }, -- text within current buffer
        { name = "async_path" }, -- file system paths
      }),

      view = {
        docs = {
          auto_open = true,
        },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    })

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

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
    })

    cmp.setup.cmdline({ ":" }, {
      mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
      sources = {
        { name = "cmdline" },
        { name = "cmdline_history" },
        { name = "async_path" },
      },
    })

    vim.diagnostic.config({
      float = {
        border = "rounded",
        source = true,
        style = "minimal",
      },
      severity_sort = true,
      underline = true,
      update_in_insert = false,
      virtual_text = false,
    })
  end,
}
