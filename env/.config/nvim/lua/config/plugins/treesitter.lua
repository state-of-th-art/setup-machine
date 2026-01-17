return { {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elm", "typescript", "rust", "javascript", "html", "markdown", "markdown_inline", "haskell", "sql" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
} }
