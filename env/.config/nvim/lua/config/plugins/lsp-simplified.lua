-- Simplified LSP configuration
-- Focuses on essential functionality and reduces duplication

local function common_on_attach(client, bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- Essential LSP keybindings only
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
  vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'Go to type definition' }))
  vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>',
    vim.tbl_extend('force', opts, { desc = 'Show references' }))
  vim.keymap.set('n', 'gk', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
  vim.keymap.set('n', 'gn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
  vim.keymap.set({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code actions' }))
  vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code actions' }))
  vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Previous diagnostic' }))
  vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))

  -- Formatting if supported
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set('n', 'gf', vim.lsp.buf.format, vim.tbl_extend('force', opts, { desc = 'Format document' }))
    vim.keymap.set('n', '<F3>', vim.lsp.buf.format, vim.tbl_extend('force', opts, { desc = 'Format document' }))
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      {
        "saghen/blink.cmp",
        version = '1.*',
        dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },
        opts = {
          snippets = { preset = 'luasnip' },
          sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
          },
        },
      },
    },
    config = function()
      require("mason").setup()
      local servers = require("config.lsp.servers")
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = servers.list,
      })

      for _, server in ipairs(servers.list) do
        local opts = {
          capabilities = capabilities,
          on_attach = common_on_attach,
        }
        local override = servers.overrides[server]
        if override then
          opts = vim.tbl_deep_extend("force", opts, override)
        end
        if server == "ts_ls" then
          opts.on_attach = function(client, bufnr)
            common_on_attach(client, bufnr)

            local ts_opts = { buffer = bufnr, silent = true }
            vim.keymap.set('n', '<leader>ti', function()
              vim.lsp.buf.code_action({
                context = { only = { 'source.addMissingImports.ts' } },
                apply = true,
              })
            end, vim.tbl_extend('force', ts_opts, { desc = 'TS: Add missing imports' }))
          end
        end
        require('lspconfig')[server].setup(opts)
      end
    end,
  }
}
