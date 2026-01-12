-- Neovim configuration entry point
-- This file is intentionally minimal and delegates to the modular structure

-- CRITICAL: Disable netrw before ANY other loading to prevent errors
-- This must be the very first thing we do
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

vim.notify("Loading Neovim configuration...", vim.log.levels.INFO)

-- Load the core configuration
require("core")

-- Load additional configurations
require("config.diagnostics")
require("config.snippets")
