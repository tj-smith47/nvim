return {
	-- UI Plugins
	{ -- File Icons for Tree UI's
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").get_icons()
			require("nvim-web-devicons").setup({ color_icons = true })
		end,
	},
	{ -- File Explorer
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				disable_netrw = true,
			})
		end,
	},
	{ -- Visual Indentation Lines
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		-- events = { "VimEnter", "BufReadPre", "BufNewFile" },
		opts = {
			indent = {
				char = "┊",
				smart_indent_cap = true,
				highlight = {
					"Conditional",
					"Function",
					"Label",
				},
			},
			whitespace = {
				highlight = {
					"Whitespace",
					"NonText",
				},
			},
			scope = {
				enabled = true,
				char = "|",
				highlight = {
					"Conditional",
					"Function",
					"Label",
				},
				show_start = true,
				show_end = false,
			},
		},
		config = function(_, opts)
			require("ibl").setup(opts)
		end,
	},
	-- {
	--   "stevearc/oil.nvim",
	--   opts = {},
	--   dependencies = { "nvim-tree/nvim-web-devicons" },
	--   config = function()
	--     require("oil").setup({
	--       default_file_explorer = true,
	--       delete_to_trash = true,
	--       skip_confirm_for_simple_edits = true,
	--     })
	--   end,
	-- },
	{ -- Fancier statusline
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				icons_enabled = true,
				theme = "dracula-nvim",
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_a = {
					"mode",
				},
				lualine_b = {
					"branch",
					"diff",
					"diagnostics",
				},
				lualine_c = {
					{
						"filename",
						path = 1,
					},
				},
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = { fg = "#ff9e64" },
					},
				},
			},
		},
		config = function(_, opts)
			require("lualine").setup(opts)
		end,
	},
	{ -- Terminal Plugin w/ Vim bindings
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<C-t>]],
			})
		end,
	},
}
