-- Core keymaps (non-plugin). Plugin-specific keymaps live in their plugin files.
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better window navigation
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

-- Better window resizing
map('n', '<C-Up>', '<cmd>resize +2<CR>', opts)
map('n', '<C-Down>', '<cmd>resize -2<CR>', opts)
map('n', '<C-Left>', '<cmd>vertical resize -2<CR>', opts)
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', opts)

-- Better buffer navigation
map('n', '<S-h>', '<Cmd>BufferPrevious<CR>', { noremap = true, silent = true, desc = "Previous Buffer" })
map('n', '<S-l>', '<Cmd>BufferNext<CR>', { noremap = true, silent = true, desc = "Next Buffer" })

-- Buffer reordering
map('n', '<A-Left>', '<Cmd>BufferMovePrevious<CR>', { noremap = true, silent = true, desc = "Move Buffer Left" })
map('n', '<A-Right>', '<Cmd>BufferMoveNext<CR>', { noremap = true, silent = true, desc = "Move Buffer Right" })

-- Buffer goto
for i = 1, 9 do
  map('n', '<A-' .. i .. '>', '<Cmd>BufferGoto ' .. i .. '<CR>',
    { noremap = true, silent = true, desc = "Go to Buffer " .. i })
end
map('n', '<A-0>', '<Cmd>BufferLast<CR>', { noremap = true, silent = true, desc = "Go to Last Buffer" })

-- Buffer management
map('n', '<A-p>', '<Cmd>BufferPin<CR>', { noremap = true, silent = true, desc = "Pin/Unpin Buffer" })
map('n', '<A-c>', '<Cmd>BufferClose<CR>', { noremap = true, silent = true, desc = "Close Buffer" })

-- Buffer sorting and closing
map('n', '<leader>bn', '<Cmd>BufferOrderByName<CR>', { noremap = true, silent = true, desc = "Sort Buffers by Name" })
map('n', "<leader>bp", "<Cmd>BufferCloseAllButPinned<CR>",
  { noremap = true, silent = true, desc = "Close All But Pinned Buffers" })
map('n', "<leader>bl", "<Cmd>BufferCloseBuffersLeft<CR>",
  { noremap = true, silent = true, desc = "Close Buffers to the Left" })
map('n', "<leader>br", "<Cmd>BufferCloseBuffersRight<CR>",
  { noremap = true, silent = true, desc = "Close Buffers to the Right" })
map('n', '<leader>bD', '<Cmd>BufferOrderByDirectory<CR>',
  { noremap = true, silent = true, desc = "Sort Buffers by Directory" })
map('n', '<leader>bL', '<Cmd>BufferOrderByLanguage<CR>',
  { noremap = true, silent = true, desc = "Sort Buffers by Language" })
map('n', "<leader>bc", "<Cmd>BufferCloseAllButCurrent<CR>",
  { noremap = true, silent = true, desc = "Close All But Current Buffer" })

-- Buffer navigation
map('n', '<leader>bb', '<Cmd>BufferNext<CR>', { noremap = true, silent = true, desc = "Next Buffer" })
map('n', '<leader>bd', '<Cmd>BufferClose<CR>', { noremap = true, silent = true, desc = "Delete Buffer" })

-- Search and replace
map('n', '<leader>s', 'yiw/\\V<C-r>"<CR>', { noremap = true, silent = true, desc = "Search word under cursor" })
map('n', '<leader>S', 'yiw/\\<\\V<C-r>"\\><CR>', { noremap = true, silent = true, desc = "Search whole word under cursor" })
map('v', '<leader>s', 'y/\\V<C-r>=escape(@",\'/\\\')<CR><CR>',
  { noremap = true, silent = true, desc = "Search selection" })

-- Paste without yanking
map('v', '<leader>p', '"_dP', { noremap = true, silent = true, desc = "Paste without yanking" })

-- System clipboard
map('v', '<leader>y', '"+y', { noremap = true, silent = true, desc = "Yank to system clipboard" })
map('n', '<leader>y', '"+y', { noremap = true, silent = true, desc = "Yank line to system clipboard" })

-- Move lines in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Git blame
map('n', '<leader>gb', ':GitBlameToggle<CR>', { noremap = true, silent = true, desc = "Toggle Git blame" })

-- Theme switcher
map("n", "<leader>tt", '<Cmd>Themery<CR>', { desc = "Toggle theme" })

-- Quick file access
map('n', '<leader>fI', ':e $NOTES_PATH/0\\ Inbox/general.md<CR>',
  { noremap = true, silent = true, desc = "Open notes inbox" })

-- Source current file
map("n", "<space>R", "<cmd>source %<CR>", { silent = true, desc = "Source current file" })

-- Diagnostic navigation
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '[e', function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Previous error' })
map('n', ']e', function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Next error' })
map('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map('n', '<leader>lq', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })

-- Open link under cursor with explorer.exe
map('n', '<leader>lo', function()
  local word = vim.fn.expand('<cword>')
  local line = vim.fn.getline('.')
  local col = vim.fn.col('.')
  
  -- Try to find URL patterns
  local url_patterns = {
    'https?://[%w%.%-_]+[%w%.%-_/?#=&%%]*',
    'www%.[%w%.%-_]+[%w%.%-_/?#=&%%]*',
    'ftp://[%w%.%-_]+[%w%.%-_/?#=&%%]*',
    '[%w%.%-_]+@[%w%.%-_]+%.%w+', -- email
  }
  
  local url = nil
  for _, pattern in ipairs(url_patterns) do
    local start, finish = string.find(line, pattern)
    if start and col >= start and col <= finish then
      url = string.sub(line, start, finish)
      break
    end
  end
  
  if url then
    -- Add protocol if missing
    if not string.match(url, '^https?://') and not string.match(url, '^ftp://') and not string.match(url, '@') then
      url = 'https://' .. url
    end
    
    -- Use explorer.exe to open the URL
    local cmd = string.format('explorer.exe "%s"', url)
    vim.fn.system(cmd)
    vim.notify('Opening: ' .. url, vim.log.levels.INFO)
  else
    vim.notify('No URL found under cursor', vim.log.levels.WARN)
  end
end, { desc = 'Open link under cursor' })

-- Completion keybindings
map('i', '<C-j>', '<C-n>', { desc = 'Select Previous' })
map('i', '<C-k>', '<C-p>', { desc = 'Select Next' })
map('i', '<C-space>', '<C-x><C-o>', { desc = 'Show Snippts' })
map('i', '<C-e>', '<C-c>', { desc = 'Hide Completion' })

-- Folding keybindings (extra for convenience)
map('n', '<leader>zf', function()
    local ufo = require('ufo')
    local current_level = vim.o.foldlevel
    vim.o.foldlevel = math.min(current_level + 1, 99)
end, { desc = 'Increase fold level (open more)' })

map('n', '<leader>zF', function()
    local ufo = require('ufo')
    local current_level = vim.o.foldlevel
    vim.o.foldlevel = math.max(current_level - 1, 0)
end, { desc = 'Decrease fold level (close more)' })

map('n', '<leader>zR', function()
    local ufo = require('ufo')
    ufo.openAllFolds()
end, { desc = 'Open all folds' })

map('n', '<leader>zM', function()
    local ufo = require('ufo')
    ufo.closeAllFolds()
end, { desc = 'Close all folds' })
