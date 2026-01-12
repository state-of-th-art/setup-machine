return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      layout = {
        align = "left",
      },
      icons = {
        group = "+",
        separator = "→",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "copy/diagnostics" },
        { "<leader>f", group = "find/files" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp/diagnostics" },
        { "<leader>t", group = "toggles/theme" },
        { "<leader>z", group = "folds" },
      })
    end,
  },
}
