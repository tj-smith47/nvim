return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- [[ Setup Mason ]]
    local mason = require("mason")

    mason.setup({
      ensure_installed = {
        -- Golang
        "goimmports",
        "gofumpt",
        -- Python
        "black",
        "ruff",
        "isort",
        "python-lsp-server",
        -- JavaScript
        "eslint",
        "prettier",
        -- Lua
        "stylua",
      },
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- [[ LSP Settings ]]
    local mason_lspconfig = require("mason-lspconfig")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- Language Servers
    local servers = {
      angularls = {},
      arduino_language_server = {},
      awk_ls = {},
      bashls = {},
      clangd = {},
      cmake = {},
      -- csharp_ls = {},
      css_variables = {},
      cssls = {},
      cssmodules_ls = {},
      diagnosticls = {
        -- init_options = {
        --   linters = {
        --     pycodestyle = {
        --       ignore = { "E501", "W503" },
        --     },
        --     pylsp = {
        --       plugins = {
        --         pycodestyle = {
        --           ignore = { "E501", "W503" },
        --         },
        --       },
        --     },
        --     pyright = {
        --       plugins = {
        --         pycodestyle = {
        --           ignore = { "E501", "W503" },
        --         },
        --       },
        --     },
        --   },
        --   formatters = {
        --     pycodestyle = {
        --       ignore = { "E501", "W503" },
        --     },
        --   },
        -- },
      },
      docker_compose_language_service = {},
      dockerls = {},
      elixirls = {},
      emmet_ls = {},
      erlangls = {},
      eslint = {},
      golangci_lint_ls = {},
      gopls = {},
      graphql = {},
      html = {},
      htmx = {},
      jinja_lsp = {},
      jqls = {},
      jsonls = {},
      lua_ls = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
          runtime = {
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
          },
          telemetry = { enable = false },
          workspace = { checkThirdParty = false },
        },
      },
      -- markdown_oxide = {},
      marksman = {},
      powershell_es = {},
      prismals = {},
      pylsp = {
        pylsp = {
          plugins = {
            pycodestyle = {
              ignore = { "E501", "W503" },
            },
          },
        },
      },
      pyright = {},
      rubocop = {},
      ruby_lsp = {},
      ruff = {},
      ruff_lsp = {},
      solargraph = {},
      sorbet = {},
      sqlls = {},
      tailwindcss = {},
      terraformls = {},
      tflint = {},
      tsserver = {},
      vimls = {},
      yamlls = {},
    }

    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    mason_lspconfig.setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          settings = servers[server_name],
        })
        -- require("lsp_signature").setup({
        --   bind = true, -- This is mandatory, otherwise border config won't get registered.
        -- })
      end,
    })

    -- [[ Mason Tool Installer ]]
    local mason_tool_installer = require("mason-tool-installer")

    mason_tool_installer.setup({
      ensure_installed = {
        { "bash-language-server", auto_update = true },
        { "black", auto_update = true },
        { "eslint_d", auto_update = true },
        { "editorconfig-checker", auto_update = true },
        { "isort", auto_update = true },
        { "gofumpt", auto_update = true },
        { "golangci-lint", auto_update = true },
        { "golines", auto_update = true },
        { "gomodifytags", auto_update = true },
        { "gopls", auto_update = true },
        { "gotests", auto_update = true },
        { "impl", auto_update = true },
        -- { "json-to-struct", auto_update = true },
        { "lua-language-server", auto_update = true },
        { "luacheck", auto_update = true },
        { "misspell", auto_update = true },
        { "prettier", auto_update = true },
        { "revive", auto_update = true },
        { "ruff", auto_update = true },
        { "stylua", auto_update = true },
        { "shellcheck", auto_update = true },
        { "shfmt", auto_update = true },
        { "staticcheck", auto_update = true },
        { "stylua", auto_update = true },
        { "vim-language-server", auto_update = true },
        { "vint", auto_update = true },
      },
    })
  end,
}
