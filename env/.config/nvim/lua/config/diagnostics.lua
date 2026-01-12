-- Diagnostic configuration
local diagnostics = require("utils.diagnostics")

-- Configure diagnostics
vim.diagnostic.config({
  virtual_text = {
    enabled = true,
    source = "if_many",
    prefix = "●",
    spacing = 2,
  },
  float = {
    enabled = true,
    source = "if_many",
    border = "rounded",
  },
  signs = {
    enabled = true,
    priority = 20,
    -- Define signs directly in the config
    text = {
      [vim.diagnostic.severity.ERROR] = "✘", -- or "E", "✘"
      [vim.diagnostic.severity.WARN] = "⚠", -- or "W", "⚠"
      [vim.diagnostic.severity.INFO] = "ℹ", -- or "I", "ℹ"
      [vim.diagnostic.severity.HINT] = "💡", -- or "H", "💡"
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>cai', diagnostics.copy_errors_for_ai, { desc = 'Copy errors for AI (formatted)' })
vim.keymap.set('n', '<leader>cb', diagnostics.copy_current_buffer_errors, { desc = 'Copy current buffer errors' })
vim.keymap.set('n', '<leader>cd', diagnostics.copy_diagnostics_interactive, { desc = 'Copy diagnostics (interactive)' }) 