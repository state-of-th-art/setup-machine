return {
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
            'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        },
        init = function() vim.g.barbar_auto_setup = false end,
        opts = {
            -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
            -- animation = true,
            -- insert_at_start = true,
            -- …etc.
        },
        version = '^1.0.0', -- optional: only update when a new 1.x version is released
        config = function(_, opts)
            require('barbar').setup(opts)
            -- Link barbar's highlight groups to the theme's tab line colors.
            vim.api.nvim_set_hl(0, "BufferCurrent", { link = "TabLineSel" })
            vim.api.nvim_set_hl(0, "BufferInactive", { link = "TabLine" })
            vim.api.nvim_set_hl(0, "BufferVisible", { link = "TabLine" })
        end,
    },
}
