-- [[ Globals ]]
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.loaded_perl_provider = 0 -- Don't load perl LSP Provider
vim.g.loaded_ruby_provider = 0 -- Don't load ruby LSP Provider
vim.g.python3_host_prog = vim.fn.expand "~/.asdf/shims/python3"
vim.g.netrw_nogx = 1           -- Disable netrw 'gx' mapping

-- [[ Options ]]
vim.opt.autoindent = true                     -- Enable autoindent
vim.opt.breakindent = true                    -- Enable break indent
-- vim.opt.cmdheight = 0 -- Height of the command bar
vim.opt.completeopt = 'menu,menuone,noselect' -- Set completeopt for a custom experience
-- vim.opt.expandtab = true                      -- Use spaces instead of tabs
-- vim.opt.foldlevel = 99
-- vim.o.foldcolumn = "1"
-- -- vim.o.foldlevelstart = 99
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = true
vim.opt.hlsearch = false     -- Disable highlight on search
vim.opt.incsearch = true     -- Incremental search
vim.opt.ignorecase = true    -- Case insensitive searching...
vim.opt.list = true          -- Show some invisible characters
vim.opt.mouse = 'a'          -- Enable mouse mode
vim.opt.number = true        -- Make line numbers default
vim.opt.path = '**/**'       -- Search in subdirectories
vim.opt.pumheight = 10       -- Pop-up menu height
vim.opt.scrolloff = 8        -- Lines of context
-- vim.opt.shiftwidth = 2       -- Size of an indent
vim.opt.signcolumn = 'yes'   -- Always show sign column
vim.opt.smartcase = true     -- ...UNLESS /C or capital in search
-- vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,terminal,globals"
vim.opt.softtabstop = 2      -- Number of spaces tabs count for
vim.opt.syntax = 'enable'    -- Enable syntax highlighting
-- vim.opt.tabstop = 4          -- Number of spaces tabs count for
vim.opt.termguicolors = true -- Set term gui colors
vim.opt.undofile = true      -- Save undo history
vim.opt.updatetime = 100     -- Decrease update time
vim.opt.wrap = false         -- Disable line wrap
vim.opt.wildmode = "longest:full:full"
vim.opt.wildignore = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx,*DS_STORE"
