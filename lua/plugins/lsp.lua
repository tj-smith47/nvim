return {
  -- LSP Plugins
  {
    'VonHeikemen/lsp-zero.nvim',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'mhartington/formatter.nvim',
      'neovim/nvim-lspconfig',
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "ruff", "black", "goimports", "gofumpt" })
        end,
      },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            "luvit-meta/library", -- see below
          },
        },
      },
      { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
      {                                        -- optional completion source for require statements and module annotations
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
          opts.sources = opts.sources or {}
          table.insert(opts.sources, {
            name = "lazydev",
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
          })
        end,
      },
      "folke/trouble.nvim"
    },
    config = function()
      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/main/advance-usage.md
      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#you-might-not-need-lsp-zero
      local lsp_zero = require('lsp-zero')

      lsp_zero.configure('lua_ls', {
        cmd = { 'lua-language-server' },
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
            runtime = {
              version = 'LuaJIT',
              path = vim.split(package.path, ';'),
            },
            telemetry = { enable = false },
            workspace = { checkThirdParty = false },
          },
        },
      })

      lsp_zero.configure('pylsp', {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = { enabled = false },
            }
          }
        }
      })

      require('fidget').setup({})
      require('formatter').setup()
      require('trouble').setup()

      require("lspconfig")["yamlls"].setup({})
      require('lspconfig')["pylsp"].setup({
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                enabled = false,
              }
            }
          }
        }
      })
      -- require("nvim-dap-virtual-text").setup({})

      local function diag_signs(signs)
        for _, sign in ipairs(signs) do
          local sign_name = ("DiagnosticSign" .. sign)
          vim.fn.sign_define(sign_name, { numhl = sign_name, text = "\226\151\143", texthl = sign_name })
        end
        return nil
      end

      diag_signs({ "Error", "Warn", "Hint", "Info" })
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help,
        { border = "rounded" })
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          underline = false,
          update_in_insert = false,
          virtual_text = false,
        }
      )
      vim.lsp.handlers['workspace/diagnostic/refresh'] = function(_, _, ctx)
        local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
        local bufnr = vim.api.nvim_get_current_buf()
        vim.diagnostic.reset(ns, bufnr)
        return true
      end

      -- Turn on lsp status information

      -- LSP settings.
      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(_, bufnr)
        -- NOTE: Remember that lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself
        -- many times.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Enable the following language servers
      local servers = {
        clangd = {},
        gopls = {},
        -- erlangls = {},
        lua_ls = {},
        pyright = {},
        pylsp = {
          plugins = {
            pycodestyle = {
              enabled = false,
            },
          },
        },
        tsserver = {},
        terraformls = {},
      }

      -- Setup mason so it can manage external tooling
      require('mason').setup({
        ensure_installed = {
          'black',
          'goimports',
          'gofumpt',
        },
      })
      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
          }
          require "lsp_signature".setup({
            bind = true, -- This is mandatory, otherwise border config won't get registered.
          })
        end,
      }

      local cmp = require('cmp')
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered()
        },
        mapping = cmp.mapping.preset.insert {
          --["<Tab>"] = vim.schedule_wrap(function(fallback)
          --  if cmp.visible() and has_words_before() then
          --    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          --  else
          --    fallback()
          --  end
          --end),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-C'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Shift-Shift>'] = cmp.mapping.close(),
          ['<PageDown>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<PageUp>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lua' },
          { name = 'path' },
          { name = 'luasnip' },
          { name = 'buffer' },
        },
      }

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
        sources = { { name = "buffer" } }
      })

      cmp.setup.cmdline({ ":" }, {
        mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
        sources = { { name = "cmdline" }, { name = "path" } }
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
  },
  { -- Autocompletion Plugins
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
      'rcarriga/nvim-dap-ui',
      -- 'theHamsta/nvim-dap-virtual-text',
      'mfussenegger/nvim-dap',
      'rafamadriz/friendly-snippets',
      'ray-x/lsp_signature.nvim',
      'saadparwaiz1/cmp_luasnip',
    },
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end,
  },
}
