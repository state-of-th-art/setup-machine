-- Basic vim options
local opt = vim.opt

-- Indentation
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Performance
opt.lazyredraw = true
opt.updatetime = 300

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes:1"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true
opt.cursorcolumn = false
opt.colorcolumn = "120"
opt.showmatch = true
opt.matchtime = 2

-- Clipboard
opt.clipboard = "unnamedplus"

-- File handling
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- Terminal
opt.termguicolors = true

-- Window
opt.splitbelow = true
opt.splitright = true

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Wildmenu
opt.wildmenu = true
opt.wildmode = "longest:full,full"

-- Other
opt.hidden = true
opt.mouse = "a"
opt.showcmd = true
opt.laststatus = 2
opt.ruler = true
opt.visualbell = true
opt.errorbells = false
opt.wrap = false
opt.linebreak = true
opt.textwidth = 140

-- Prevent "Press ENTER to continue" prompts
opt.cmdheight = 2
opt.shortmess = "aoOTIc"
opt.confirm = false


