-- Custom highlights and colorscheme setup

-- Custom buffer highlights
vim.cmd [[
    highlight BufferCurrent guifg=#ffffff guibg=#6182B8 gui=bold
    highlight BufferCurrentIndex guifg=#ffffff guibg=#6182B8 gui=bold
    highlight BufferCurrentMod guifg=#ffffff guibg=#6182B8 gui=bold
]]

-- Custom diagnostic highlights
vim.cmd [[
    highlight DiagnosticError guifg=#ff6b6b
    highlight DiagnosticWarn guifg=#feca57
    highlight DiagnosticInfo guifg=#48dbfb
    highlight DiagnosticHint guifg=#c8d6e5
]]

-- Custom fold highlights
vim.cmd [[
    highlight Folded guifg=#6c757d guibg=#f8f9fa
    highlight FoldColumn guifg=#6c757d guibg=#f8f9fa
]]

-- Custom search highlights
vim.cmd [[
    highlight Search guifg=#ffffff guibg=#007acc
    highlight IncSearch guifg=#ffffff guibg=#ff6b6b
]]

-- Custom cursor line
vim.cmd [[
    highlight CursorLine guibg=#f8f9fa
    highlight CursorLineNr guifg=#007acc guibg=#f8f9fa gui=bold
]]

-- Custom color column
vim.cmd [[
    highlight ColorColumn guibg=#f1f3f4
]] 

-- Signature help highlights (for blink.cmp and LSP)
vim.cmd [[
    highlight NormalFloat guifg=#3c4043 guibg=#f8f9fa
    highlight FloatBorder guifg=#6c757d guibg=#f8f9fa
    highlight LspSignatureActiveParameter guifg=#ffffff guibg=#007acc gui=bold
]]

vim.api.nvim_set_hl(0, "@markup.strong", { bold = true })