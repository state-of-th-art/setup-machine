return {
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({
        -- Enable default icons
        default = true
      })
    end
  }
}
