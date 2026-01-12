return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons', 'echasnovski/mini.nvim' },
    ft = { 'markdown' },
    config = function()
      require('render-markdown').setup({
        render_modes = { 'n', 'v' },  -- Render only in normal and visual modes
      })
    end,
  }
}
