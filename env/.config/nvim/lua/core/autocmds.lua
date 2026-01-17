-- Autocommands
local api = vim.api

-- Create augroup for better organization
local general_group = api.nvim_create_augroup("General", { clear = true })

-- Auto-resize splits when window is resized
api.nvim_create_autocmd("VimResized", {
  group = general_group,
  command = "tabdo wincmd =",
  desc = "Auto-resize splits when window is resized"
})

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  group = general_group,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
  desc = "Highlight yanked text"
})

-- Remove trailing whitespace on save
api.nvim_create_autocmd("BufWritePre", {
  group = general_group,
  pattern = "*",
  callback = function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end,
  desc = "Remove trailing whitespace on save"
})

-- Auto-format on save for specific filetypes
local format_group = api.nvim_create_augroup("Format", { clear = true })

api.nvim_create_autocmd("BufWritePre", {
  group = format_group,
  pattern = { "*.lua", "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.css", "*.scss", "*.elm" },
  callback = function()
    -- Check if LSP is available and has formatting capability
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in pairs(clients) do
      if client.server_capabilities.documentFormattingProvider then
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        vim.lsp.buf.format({ async = false })
        vim.api.nvim_win_set_cursor(0, cursor_pos)
        return
      end
    end
  end,
  desc = "Auto-format on save"
})



-- Ensure our highlight overrides apply AFTER any colorscheme
local highlight_overrides = api.nvim_create_augroup("HighlightOverrides", { clear = true })

api.nvim_create_autocmd("ColorScheme", {
  group = highlight_overrides,
  callback = function()
    -- Force bold/italic for markdown via Treesitter captures
    vim.api.nvim_set_hl(0, "@markup.strong", { bold = true })
    vim.api.nvim_set_hl(0, "@markup.strong.markdown_inline", { bold = true })
    vim.api.nvim_set_hl(0, "@markup.emphasis", { italic = true })
    vim.api.nvim_set_hl(0, "@markup.emphasis.markdown_inline", { italic = true })

    -- Also link to generic Bold/Italic groups as a fallback (themes usually define them)
    pcall(vim.api.nvim_set_hl, 0, "@text.strong", { link = "Bold" })
    pcall(vim.api.nvim_set_hl, 0, "@text.emphasis", { link = "Italic" })
    pcall(vim.api.nvim_set_hl, 0, "@markup.strong", { link = "Bold" })
    pcall(vim.api.nvim_set_hl, 0, "@markup.emphasis", { link = "Italic" })

    -- If terminal/fonts ignore bold, ensure visible color via Title
    pcall(vim.api.nvim_set_hl, 0, "@markup.strong", { link = "Title" })
    pcall(vim.api.nvim_set_hl, 0, "@markup.strong.markdown_inline", { link = "Title" })
  end,
  desc = "Force bold/italic for markdown captures after colorscheme is applied",
})

-- Filetype-specific settings
local filetype_group = api.nvim_create_augroup("CustomFileType", { clear = true })

-- psql temp files from \e should use SQL filetype
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = filetype_group,
  pattern = { "psql.edit.*", "*.psql" },
  callback = function()
    vim.bo.filetype = "sql"
  end,
  desc = "Detect SQL filetype for psql edit buffers"
})

-- -- Markdown settings
api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.textwidth = 120
  end,
  desc = "Markdown-specific settings"
})

-- -- Git commit settings
api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 72
  end,
  desc = "Git commit-specific settings"
})

-- -- Elm settings
api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = "elm",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
  end,
  desc = "Elm-specific settings"
})
