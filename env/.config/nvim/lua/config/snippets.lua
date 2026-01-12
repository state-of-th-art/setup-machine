-- Snippets configuration
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Configure LuaSnip
ls.config.set_config({
  history = true,                            -- keep around last snippet local to jump back
  updateevents = "TextChanged,TextChangedI", -- update changes as you type
  enable_autosnippets = true,
})

-- LuaSnip keybindings
vim.keymap.set({"i", "s"}, "<Tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  else
    return "<Tab>"
  end
end, {silent = true, expr = true})

vim.keymap.set({"i", "s"}, "<S-Tab>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  else
    return "<S-Tab>"
  end
end, {silent = true, expr = true})

-- For changing choices in choice nodes
vim.keymap.set("i", "<C-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

-- Load snippets from the snippets directory
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets/" })

-- Load friendly-snippets selectively (React, TypeScript, Python, Rust)
require("luasnip.loaders.from_vscode").lazy_load({
  -- Only load specific languages to avoid cluttering autocomplete
  include = {
    "javascript",
    "typescript", 
    "javascriptreact",
    "typescriptreact",
    "python",
    "rust",
    "html",
    "css",
    "json",
    "markdown"
  }
}) 