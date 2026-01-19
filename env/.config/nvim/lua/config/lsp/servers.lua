local M = {}

M.list = {
  "lua_ls",
  "rust_analyzer",
  "cssls",
  "pyright",
  "ts_ls",
  "tailwindcss",
  "elmls",
  "postgres_lsp",
}

M.overrides = {
  tailwindcss = {
    filetypes = { "html", "elm", "typescriptreact", "javascriptreact" },
    init_options = {
      userLanguages = {
        elm = "html",
        html = "html",
      },
    },
    settings = {
      tailwindCSS = {
        includeLanguages = {
          elm = "html",
          html = "html",
        },
        classAttributes = { "class", "className", "classList", "ngClass" },
        experimental = {
          classRegex = {
            "\\bclass[\\s(<|]+\"([^\"]*)\"",
            "\\bclass[\\s(]+\"[^\"]*\"[\\s+]+\"([^\"]*)\"",
            "\\bclass[\\s<|]+\"[^\"]*\"\\s*\\+{2}\\s*\" ([^\"]*)\"",
            "\\bclass[\\s<|]+\"[^\"]*\"\\s*\\+{2}\\s*\" [^\"]*\"\\s*\\+{2}\\s*\" ([^\"]*)\"",
            "\\bclass[\\s<|]+\"[^\"]*\"\\s*\\+{2}\\s*\" [^\"]*\"\\s*\\+{2}\\s*\" [^\"]*\"\\s*\\+{2}\\s*\" ([^\"]*)\"",
            "\\bclassList[\\s\\[\\(]+\"([^\"]*)\"",
            "\\bclassList[\\s\\[\\(]+\"[^\"]*\",\\s[^\\)]+\\)[\\s\\[\\(,]+\"([^\"]*)\"",
            "\\bclassList[\\s\\[\\(]+\"[^\"]*\",\\s[^\\)]+\\)[\\s\\[\\(,]+\"[^\"]*\",\\s[^\\)]+\\)[\\s\\[\\(,]+\"([^\"]*)\"",
          },
        },
        lint = {
          cssConflict = "warning",
          invalidApply = "error",
          invalidConfigPath = "error",
          invalidScreen = "error",
          invalidTailwindDirective = "error",
          invalidVariant = "error",
          recommendedVariantOrder = "warning",
        },
        validate = true,
      },
    },
  },
  elmls = {
    root_dir = require("lspconfig.util").root_pattern("elm.json"),
  },
}

return M
