-- Core Neovim configuration
-- This file sets up the basic Neovim environment and loads other modules

-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load core modules
require("core.options")     -- Basic vim options
require("core.keymaps")     -- Global keymaps
require("core.autocmds")    -- Autocommands
require("core.highlights")  -- Custom highlights

-- Bootstrap and setup lazy.nvim
require("config.lazy")

-- Load user configuration if it exists
local user_config = vim.fn.stdpath("config") .. "/lua/user/init.lua"
if vim.fn.filereadable(user_config) == 1 then
    require("user")
end 