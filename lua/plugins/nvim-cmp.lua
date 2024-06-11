return {
	-- Autocompletion Plugins
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-nvim-lua",
		"mfussenegger/nvim-dap",
		"rcarriga/nvim-dap-ui",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-path", -- source for file system paths
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
		},
		"ray-x/lsp_signature.nvim",
		"saadparwaiz1/cmp_luasnip",   -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim",       -- vs-code like pictograms
	},
	config = function()
		local cmp = require("cmp")

		local luasnip = require("luasnip")

		local lspkind = require("lspkind")

		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		-- require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-e>"] = cmp.mapping.abort(),        -- close completion window
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-C"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<Shift-Shift>"] = cmp.mapping.close(),
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
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp_signature_help" },
				{ name = "lazydev" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lua" },
				{ name = "path" }, -- file system paths
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
			}),

			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				-- expandable_indicator = true,
				format = lspkind.cmp_format({
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
			sources = { { name = "buffer" } },
		})

		cmp.setup.cmdline({ ":" }, {
			mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
			sources = { { name = "cmdline" }, { name = "path" } },
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
