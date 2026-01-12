return {
    {
        'marko-cerovac/material.nvim',
        config = function()
            require('material').setup {
                plugins = { -- Uncomment the plugins that you use to highlight them
                    -- Available plugins:
                    -- "coc",
                    -- "colorful-winsep",
                    -- "dap",
                    -- "dashboard",
                    -- "eyeliner",
                    -- "fidget",
                    -- "flash",
                    -- "gitsigns",
                    -- "harpoon",
                    -- "hop",
                    -- "illuminate",
                    -- "indent-blankline",
                    -- "lspsaga",
                    -- "mini",
                    -- "neogit",
                    -- "neotest",
                    -- "neo-tree",
                    -- "neorg",
                    -- "noice",
                    -- "nvim-cmp",
                    -- "nvim-navic",
                    -- "nvim-tree",
                    -- "nvim-web-devicons",
                    -- "rainbow-delimiters",
                    -- "sneak",
                    "telescope",
                    -- "trouble",
                    -- "nvim-notify",
                },
            }
            
            -- Set the colorscheme after plugin is loaded
            vim.cmd [[colorscheme material-lighter]]
        end
    }
}
