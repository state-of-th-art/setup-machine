-- Markdown snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node
-- NOTE: keep snippets simple; avoid extras to reduce load issues

-- Function to get today's date
local function get_date()
  return os.date("%d.%m.%Y")
end

return {
  -- Snippet for today's date in format ### DD.MM.YYYY
  s("date", {
    t("## "),
    f(get_date),
  }),
  
  -- Daily reflection template
  s("reflection", {
    t({
      "#### What did I do today?",
      "",
    }),
    i(1),
    t({
      "",
      "#### What gave me energy/joy?",
      "",
    }),
    i(2),
    t({
      "",
      "#### What drained/annoyed me?",
      "",
    }),
    i(3),
    t({
      "",
      "#### What did I want to do but didn't?",
      "",
    }),
    i(0),
  }),
}
