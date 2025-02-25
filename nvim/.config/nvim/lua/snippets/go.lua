local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

return {
	s({ trig = "struct", name = "struct", description = "Create a new struct" }, {
		t("type "),
		i(1, "StructName"),
		t({ " struct {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
	s({ trig = "enil", name = "err is nil", description = "check if err is nil" }, {
		t("if "),
		i(1, "err"),
		t({ " != nil {", "\t" }),
		i(2),
		t({ "", "}" }),
	}),
	s({ trig = "snil", name = "err is nil (surround)", description = "check if err is nil (surround)" }, {
		t("if "),
		i(1, "err"),
		t({ " != nil {", "" }),
		f(function(_, snip)
			local res, env = {}, snip.env
			for _, ele in ipairs(env.LS_SELECT_RAW) do
				table.insert(res, ele)
			end
			return res
		end, {}),
		t({ "", "}" }),
	}),
	s({ trig = "erris", name = "errors.Is", description = "repalce err == with errors.Is" }, {
		t("error.Is("),
		f(function(_, snip)
			local line = snip.env.LS_SELECT_RAW[1]
			return line:gsub(" ?== ?", ", ")
		end, {}),
		t(")"),
	}),
	s({ trig = "errnis", name = "not errors.Is", description = "repalce err != with !errors.Is" }, {
		t("!error.Is("),
		f(function(_, snip)
			local line = snip.env.LS_SELECT_RAW[1]
			return line:gsub(" ?!= ?", ", ")
		end, {}),
		t(")"),
	}),
}
