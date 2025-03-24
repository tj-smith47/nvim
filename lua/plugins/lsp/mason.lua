return {
  "williamboman/mason.nvim",
  dependencies = {
    "strozw/github-actions-languageserver.nvim",
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
      -- angularls = {},
      -- arduino_language_server = {},
      awk_ls = {},
      bashls = {},
      biome = {},
      clangd = {},
      cmake = {},
      css_variables = {},
      cssls = {},
      cssmodules_ls = {},
      diagnosticls = {},
      docker_compose_language_service = {},
      -- dockerls = {
      --   settings = {
      --     docker = {
      --       languageserver = {
      --         formatter = {
      --           enable = false,
      --           ignoreMultilineInstructions = true,
      --         },
      --       },
      --     },
      --   },
      -- },
      elixirls = {},
      -- emmet_ls = {},
      erlangls = {},
      eslint = {},
      golangci_lint_ls = {},
      -- github_actions_languageserver = {
      --   init_params = {},
      -- },
      gopls = {},
      graphql = {},
      html = {},
      htmx = {},
      -- jinja_lsp = {},
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
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              "~/.local/share/nvim/lazy/dracula.nvim",
            },
          },
        },
      },
      -- markdown_oxide = {},
      marksman = {},
      -- powershell_es = {},
      -- prismals = {},
      pylsp = {
        pylsp = {
          plugins = {
            pycodestyle = {
              ignore = { "E501", "E711", "E741", "W503" },
            },
          },
        },
      },
      pyright = {
        analysis = {
          autoImport = true,
        },
      },
      rubocop = {},
      ruff = {},
      solargraph = {},
      sqlls = {},
      tailwindcss = {},
      terraformls = {},
      tflint = {},
      vimls = {},
      yamlls = {},
    }

    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    require("github-actions-languageserver").setup()

    mason_lspconfig.setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          settings = servers[server_name],
        })
      end,
    })

    -- [[ Mason Tool Installer ]]
    local mason_tool_installer = require("mason-tool-installer")

    local ensure_installed = {
      { "bash-language-server", auto_update = true },
      { "black", auto_update = true },
      { "editorconfig-checker", auto_update = true },
      { "eslint_d", auto_update = true },
      { "gofumpt", auto_update = true },
      { "golangci-lint", auto_update = true },
      { "golines", auto_update = true },
      { "gomodifytags", auto_update = true },
      { "gopls", auto_update = true },
      { "gotests", auto_update = true },
      { "impl", auto_update = true },
      { "isort", auto_update = true },
      { "json-to-struct", auto_update = true },
      { "lua-language-server", auto_update = true },
      { "luacheck", auto_update = true },
      { "misspell", auto_update = true },
      { "mypy", auto_update = true },
      { "prettier", auto_update = true },
      { "pylint", auto_update = true },
      { "python-lsp-server", auto_update = true },
      { "revive", auto_update = true },
      { "ruff", auto_update = true },
      { "shellcheck", auto_update = true },
      { "shfmt", auto_update = true },
      { "staticcheck", auto_update = true },
      { "stylua", auto_update = true },
      { "tree-sitter-cli", auto_update = true },
      { "typescript-language-server", auto_update = true },
      { "vim-language-server", auto_update = true },
      { "vint", auto_update = true },
    }

    local darwin_install = {
      { "ansible-lint", auto_update = true },
      { "biome", auto_update = true },
      { "js-debug-adapter", auto_update = true },
      { "markmap-cli", auto_update = true },
      { "semgrep", auto_update = true },
      { "sqlfluff", auto_update = true },
    }

    local os = vim.loop.os_uname().sysname
    if os == "Darwin" then
      for _, tool in ipairs(darwin_install) do
        table.insert(ensure_installed, tool)
      end
    end

    mason_tool_installer.setup({
      ensure_installed = ensure_installed,
    })
  end,
}
