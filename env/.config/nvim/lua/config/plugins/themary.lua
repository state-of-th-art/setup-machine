return {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
        require("themery").setup({
            themes = {
                "tokyonight-day",
                "tokyonight-moon",
                "tokyonight-night",
                "tokyonight-storm",
                "material-darker",
                "material-lighter",
                "material-oceanic",
                "material-palenight",
                "material-deep-ocean",
                {
                    name = "everforest dark",
                    colorscheme = "everforest",
                    before = [[
                      vim.opt.background = "dark"
                    ]],

                },
                {
                    name = "everforest light",
                    colorscheme = "everforest",
                    before = [[
                      vim.opt.background = "light"
                    ]],

                }
            }
        })
    end
}
