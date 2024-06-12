return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    {
      "williamboman/mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "ruff", "black", "goimports", "gofumpt" })
      end,
    },
    "williamboman/mason-lspconfig.nvim",
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          "luvit-meta/library", -- see below
        },
      },
    },
    "j-hui/fidget.nvim",
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    lspconfig["lua_ls"].setup({
      cmd = { "lua-language-server" },
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          runtime = {
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
          },
          telemetry = { enable = false },
          workspace = { checkThirdParty = false },
        },
      },
    })
    lspconfig["yamlls"].setup({})

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- Useful status updates for LSP
    require("fidget").setup({})

    -- import mason_lspconfig plugin
    -- local mason_lspconfig = require("mason-lspconfig")

    -- -- import cmp-nvim-lsp plugin
    -- local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- -- used to enable autocompletion (assign to every lsp server config)
    -- local capabilities = cmp_nvim_lsp.default_capabilities()

    -- mason_lspconfig.setup_handlers({
    -- 	-- default handler for installed servers
    -- 	function(server_name)
    -- 		lspconfig[server_name].setup({
    -- 			capabilities = capabilities,
    -- 		})
    -- 	end,
    -- 	["diagnosticls"] = function()
    -- 		lspconfig["diagnosticls"].setup({
    -- 			capabilities = capabilities,
    -- 			settings = {
    -- 				pycodestyle = { enabled = false },
    -- 				pylsp = {
    -- 					plugins = {
    -- 						pycodestyle = {
    -- 							enabled = false,
    -- 						},
    -- 					},
    -- 				},
    -- 			},
    -- 		})
    -- 	end,
    -- 	["svelte"] = function()
    -- 		-- configure svelte server
    -- 		lspconfig["svelte"].setup({
    -- 			capabilities = capabilities,
    -- 			on_attach = function(client, bufnr)
    -- 				vim.api.nvim_create_autocmd("BufWritePost", {
    -- 					pattern = { "*.js", "*.ts" },
    -- 					callback = function(ctx)
    -- 						-- Here use ctx.match instead of ctx.file
    -- 						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
    -- 					end,
    -- 				})
    -- 			end,
    -- 		})
    -- 	end,
    -- 	["graphql"] = function()
    -- 		-- configure graphql language server
    -- 		lspconfig["graphql"].setup({
    -- 			capabilities = capabilities,
    -- 			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    -- 		})
    -- 	end,
    -- 	["emmet_ls"] = function()
    -- 		-- configure emmet language server
    -- 		lspconfig["emmet_ls"].setup({
    -- 			capabilities = capabilities,
    -- 			filetypes = {
    -- 				"html",
    -- 				"typescriptreact",
    -- 				"javascriptreact",
    -- 				"css",
    -- 				"sass",
    -- 				"scss",
    -- 				"less",
    -- 				"svelte",
    -- 			},
    -- 		})
    -- 	end,
    -- 	["lua_ls"] = function()
    -- 		-- configure lua server (with special settings)
    -- 		lspconfig["lua_ls"].setup({
    -- 			cmd = { "lua-language-server" },
    -- 			capabilities = capabilities,
    -- 			settings = {
    -- 				Lua = {
    -- 					-- make the language server recognize "vim" global
    -- 					diagnostics = {
    -- 						globals = { "vim" },
    -- 					},
    -- 					completion = {
    -- 						callSnippet = "Replace",
    -- 					},
    -- 					runtime = {
    -- 						version = "LuaJIT",
    -- 						path = vim.split(package.path, ";"),
    -- 					},
    -- 					telemetry = { enable = false },
    -- 					workspace = { checkThirdParty = false },
    -- 				},
    -- 			},
    -- 		})
    -- 	end,
    -- 	["pylsp"] = function()
    -- 		-- configure python server (with special settings)
    -- 		lspconfig["pylsp"].setup({
    -- 			capabilities = capabilities,
    -- 			settings = {
    -- 				pylsp = {
    -- 					plugins = {
    -- 						pycodestyle = {
    -- 							enabled = false,
    -- 						},
    -- 					},
    -- 				},
    -- 			},
    -- 		})
    -- 	end,
    -- 	["yamlls"] = function()
    -- 		-- configure yaml server
    -- 		lspconfig["yamlls"].setup({
    -- 			capabilities = capabilities,
    -- 		})
    -- 	end,
    -- })

    -- -- Change the Diagnostic symbols in the sign column (gutter)
    -- -- (not in youtube nvim video)
    -- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    -- for type, icon in pairs(signs) do
    -- 	local hl = "DiagnosticSign" .. type
    -- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    -- end

    -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    -- vim.lsp.handlers["textDocument/signatureHelp"] =
    -- 	vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    -- 	underline = false,
    -- 	update_in_insert = false,
    -- 	virtual_text = false,
    -- })
    -- vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
    -- 	local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
    -- 	local bufnr = vim.api.nvim_get_current_buf()
    -- 	vim.diagnostic.reset(ns, bufnr)
    -- 	return true
    -- end

    -- vim.diagnostic.config({
    -- 	float = {
    -- 		border = "rounded",
    -- 		source = true,
    -- 		style = "minimal",
    -- 	},
    -- 	severity_sort = true,
    -- 	underline = true,
    -- 	update_in_insert = false,
    -- 	virtual_text = false,
    -- })
  end,
}