-- User-specific configuration
-- This file is loaded after the core configuration
-- Add your personal customizations here

-- Example customizations:

-- Override default options
-- vim.opt.shiftwidth = 2  -- Use 2 spaces instead of 4

-- Add custom keymaps
-- vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })

-- Add custom autocommands
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "python",
--   callback = function()
--     vim.opt_local.tabstop = 4
--     vim.opt_local.shiftwidth = 4
--   end,
-- })

-- Load additional plugins
-- require("config.plugins.my-custom-plugin")

-- Override theme
-- vim.cmd [[colorscheme tokyonight]]

vim.notify("User configuration loaded", vim.log.levels.INFO) 