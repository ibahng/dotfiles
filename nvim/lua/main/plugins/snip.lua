-- LuaSnip - snippet engine
return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  opts = {
    history = true,                    -- Remember snippet state for jumping back
    region_check_events = "InsertEnter", -- Check if still in snippet region
    delete_check_events = "InsertLeave", -- Clean up when leaving insert mode
  },
  config = function(_, opts)
    local ls = require("luasnip")

    ls.setup(opts)

    -- Load VSCode-style snippets from friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Helper functions for creating snippets
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local extras = require('luasnip.extras')
    local rep = extras.rep
      -- allows for the same inserted text via the i function at a different location; rep(#)
    local fmta = require('luasnip.extras.fmt').fmta
      -- allows for easier formatting with {} in the place of insertions, raw curly braces are with doubled {{}}; fmt([[snippet]], {list of insertions}) 
    local c = ls.choice_node
      -- allows for cycling through different choices; c(#, {list of t('string')})
    local f = ls.function_node -- this is a REALLY powerful tool
      -- allows for lua function insertion, HAS to return a string, can have it inline (defined in the function) or defined previously and move into the snippet; f(function() function_code end)

    ls.add_snippets('lua', {
      s('example', fmta(
        [[
        hello world <>
        this is an <> example
        for the purposes
        of testing out <> luasnip
        ]],
        {
          i(1), i(2), i(3)
        }
      ))
    })

    ls.add_snippets('tex', {
      s('electron', t(
        '\\ce{e^-}'
      )),

      s('proton', t(
        '\\ce{H^+}'
      )),

      s('tb', fmta(
        '\\textbf{<>}',
        { i(1) }
      )),

      s('ti', fmta(
        '\\textit{<>}',
        { i(1) }
      )),

      s('tt', fmta(
        '\\texttt{<>}',
        { i(1) }
      )),

      s('tu', fmta(
        '\\uline{<>}',
        { i(1) }
      )),
      
      s('ice', fmta(
        '\\ce{<>}',
        { i(1) }
      )),

      s('bce', fmta(
        '\\hspace{7mm}\\ce{<>}',
        { i(1) }
      )),

    })

    ls.add_snippets('py', {
      -- s()
    })
  end,
}


