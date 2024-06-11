return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- enable mason and configure icons
		mason.setup({
			ensure_installed = {
				-- Python
				"black",
				"ruff",
				-- Golang
				"goimmports",
				"gofumpt",
			},
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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
					desc = "LSP: " .. desc
				end

				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
			end

			nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
			-- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

			nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
			nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
			nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
			nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
			nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
			nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

			-- See `:help K` for why this keymap
			nmap("K", vim.lsp.buf.hover, "Hover Documentation")
			nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

			-- Lesser used LSP functionality
			nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
			nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
			nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
			nmap("<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, "[W]orkspace [L]ist Folders")

			-- Create a command `:Format` local to the LSP buffer
			vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
				vim.lsp.buf.format()
			end, { desc = "Format current buffer with LSP" })
		end

		-- Enable the following language servers
		local servers = {
			clangd = {},
			cssls = {},
			gopls = {},
			diagnosticls = {
				plugins = {
					pylsp = {
						plugins = {
							pycodestyle = {
								enabled = false,
							},
						},
					},
				},
			},
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
			tailwindcss = {},
			tsserver = {},
			terraformls = {},
		}

		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
		})

		mason_lspconfig.setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
				})
				require("lsp_signature").setup({
					bind = true, -- This is mandatory, otherwise border config won't get registered.
				})
			end,
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"cssls",
				"diagnosticls",
				"emmet_ls",
				"graphql",
				"html",
				"lua_ls",
				"prismals",
				"pyright",
				"ruff_lsp",
				"tailwindcss",
				"tsserver",
			},
		})

		local mason_tool_installer = require("mason-tool-installer")

		mason_tool_installer.setup({
			ensure_installed = {
				"black", -- python formatter
				"eslint_d", -- js linter
				"isort", -- python formatter
				"prettier", -- prettier formatter
				"ruff", -- python linter
				"stylua", -- lua formatter
			},
		})
	end,
}
