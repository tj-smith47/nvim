-- [[ Globals ]]
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.loaded_perl_provider = 0 -- Don't load perl LSP Provider
vim.g.loaded_ruby_provider = 0 -- Don't load ruby LSP Provider
vim.g.python3_host_prog = vim.fn.expand("~/.asdf/shims/python3")
vim.g.netrw_nogx = 1 -- Disable netrw 'gx' mapping

local opt = vim.opt -- for conciseness

-- [[ System Options ]]
-- vim.opt.cmdheight = 0 -- Height of the command bar
opt.clipboard:append("unnamedplus") -- use system clipboard as default register
opt.completeopt = "menu,menuone,noselect" -- Set completeopt for a custom experience
opt.list = true -- Show some invisible characters
opt.mouse = "a" -- Enable mouse mode
opt.path = "**/**" -- Search in subdirectories
opt.syntax = "enable" -- Enable syntax highlighting
opt.undofile = true -- Save undo history
opt.swapfile = false -- Disable swap file

-- [[ General Options ]]
-- UI
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.pumheight = 10 -- Pop-up menu height
opt.signcolumn = "yes" -- show sign column so that text doesn't shift
opt.termguicolors = true

-- context
opt.scrolloff = 8 -- Lines of context
opt.number = true -- shows absolute line numbers

-- tabs & indentation
opt.autoindent = true -- copy indent from current line when starting new one
opt.breakindent = true -- enable break indent
opt.expandtab = true -- expand tab to spaces
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.softtabstop = 2 -- Number of spaces tabs count for
-- vim.opt.shiftwidth = 2       -- Size of an indent

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- search options
opt.hlsearch = false -- Disable highlight on search
opt.incsearch = true -- Incremental search

-- misc
-- vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,terminal,globals"
vim.opt.updatetime = 100 -- Decrease update time
vim.opt.wildmode = "longest:full:full"
vim.opt.wildignore = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx,*DS_STORE"

-- folding
-- vim.opt.expandtab = true                      -- Use spaces instead of tabs
-- vim.opt.foldlevel = 99
-- vim.o.foldcolumn = "1"
-- -- vim.o.foldlevelstart = 99
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = true

vim.diagnostic.virtual_text = false
