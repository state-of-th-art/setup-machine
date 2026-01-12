local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- Function to get proper module name from file path
local function get_module_name()
  local filepath = vim.fn.expand("%:p")   -- get full path
  local filename = vim.fn.expand("%:t:r") -- get filename without extension

  if filename == "" then
    return "ModuleName"
  end

  -- Find src/ in the path and get everything after it
  local src_index = filepath:find("/src/")
  if src_index then
    -- Get the path after src/
    local relative_path = filepath:sub(src_index + 5) -- +5 to skip "/src/"
    -- Remove the .elm extension
    relative_path = relative_path:gsub("%.elm$", "")
    -- Replace / with .
    local module_name = relative_path:gsub("/", ".")
    return module_name
  else
    -- Fallback to just capitalizing filename if no src/ found
    return filename:gsub("^%l", string.upper)
  end
end

return {
  -- Basic module snippet
  s("mod", fmt([[
module {} exposing (..)


{}
]], {
    f(get_module_name),
    i(0)
  })),

  -- Module with specific exports
  s("modexp", fmt([[
module {} exposing
    ( {}
    )


{}
]], {
    f(get_module_name),
    i(1, "init, update, view"),
    i(0)
  })),

  -- TEA (The Elm Architecture) module - your main request
  s("tea", fmt([[
module {} exposing (init, update, view)


-- MODEL


type alias Model =
    {}


init : {}
init =
    {}


-- UPDATE


type Msg
    = {}


update : Msg -> Model -> Model
update msg model =
    case msg of
        {} ->
            {}


-- VIEW


view : Model -> {}
view model =
    {}
]], {
    f(get_module_name),
    i(1, "Int"),          -- Model type
    i(2, "Model"),        -- init return type
    i(3, "0"),            -- init value
    i(4, "NoOp"),         -- Msg constructor
    i(5, "NoOp"),         -- case pattern
    i(6, "model"),        -- update return
    i(7, "Html msg"),     -- view return type
    i(0, "text \"TODO\"") -- view implementation
  })),

  -- TEA with flags (for when you need initialization data)
  s("teaflag", fmt([[
module {} exposing (init, update, view)


-- MODEL


type alias Model =
    {}


type alias Flags =
    {}


init : Flags -> Model
init flags =
    {}


-- UPDATE


type Msg
    = {}


update : Msg -> Model -> Model
update msg model =
    case msg of
        {} ->
            {}


-- VIEW


view : Model -> {}
view model =
    {}
]], {
    f(get_module_name),
    i(1, "Int"),          -- Model type
    i(2, "{}"),           -- Flags type
    i(3, "0"),            -- init implementation
    i(4, "NoOp"),         -- Msg constructor
    i(5, "NoOp"),         -- case pattern
    i(6, "model"),        -- update return
    i(7, "Html msg"),     -- view return type
    i(0, "text \"TODO\"") -- view implementation
  })),

  -- Main module (for applications) - updated with proper path
  s("main", fmt([[
module {} exposing (main)

import Browser
import Html exposing (Html, text)


main =
    Browser.sandbox
        {{ init = init
        , update = update
        , view = view
        }}


-- MODEL


type alias Model =
    {}


init : Model
init =
    {}


-- UPDATE


type Msg
    = {}


update : Msg -> Model -> Model
update msg model =
    case msg of
        {} ->
            {}


-- VIEW


view : Model -> Html Msg
view model =
    {}
]], {
    f(get_module_name),
    i(1, "Int"),                 -- Model type
    i(2, "0"),                   -- init value
    i(3, "NoOp"),                -- Msg constructor
    i(4, "NoOp"),                -- case pattern
    i(5, "model"),               -- update return
    i(0, 'text "Hello, World!"') -- view implementation
  })),

  -- Simple function snippet
  s("fn", fmt([[
{} : {}
{} {} =
    {}
]], {
    i(1, "functionName"), -- function name (first occurrence)
    i(2, "a -> a"),       -- type signature
    i(3, "functionName"), -- function name (second occurrence)
    i(4, "arg"),          -- arguments
    i(0, "arg")           -- implementation
  })),

  -- Case expression
  s("case", fmt([[
case {} of
    {} ->
        {}
]], {
    i(1, "value"),
    i(2, "pattern"),
    i(0, "result")
  })),
}
