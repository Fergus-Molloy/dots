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
	s({ trig = "mod", name = "Module", description = "insert module with filename populated" }, {
		t("-module("),
		f(function(args, snip)
			local filename = snip.env.TM_FILENAME
			local rev = string.reverse(filename)
			local dot = string.find(rev, ".", 1, true)
			if dot == nil then
				return filename
			else
				return filename:sub(1, -(dot + 1))
			end
		end, {}),
		t(")."),
	}),
	s({ trig = "fn", name = "function", description = "new function" }, {
		i(1, "function_name"),
		t("("),
		i(2),
		t({ ") ->", "" }),
		i(0),
		t("."),
	}),
	s({ trig = "case", name = "case statement", description = "new case statement" }, {
		t("case "),
		i(1),
		t({ " of", "" }),
		i(2),
		t("end"),
	}),
	s({ trig = "HT", name = "list pattern", description = "list pattern" }, {
		t("[ "),
		i(1, "Head"),
		t(" | "),
		i(2, "Tail"),
		t(" ]"),
	}),
	s({ trig = "tup", name = "tuple pattern", description = "tuple pattern" }, {
		t("{ "),
		i(1, "Value"),
		t(" }"),
	}),
	s({ trig = "DOWN", name = "Down message", description = "down message for matching" }, {
		t("{'DOWN', Ref, process, Pid, Reason}"),
	}),
	s({ trig = "mexp", name = "merge exports", description = "merge multiple lines of exports into one" }, {
		t("-export(["),
		f(function(_, snip)
			local all_exports = ""
			local is_first = true
			for _, line in ipairs(snip.env.LS_SELECT_RAW) do
				local exports = line:gsub("-export%(%[(.*)%]%).", "%1")
				if is_first then
					all_exports = all_exports .. exports
					is_first = false
				else
					all_exports = all_exports .. "," .. exports
				end
			end
			return all_exports
		end, {}),
		t("])."),
	}),
	s({ trig = "server", name = "gen server template", description = "create gen server outline" }, {
		t({
			"-behavoir(gen_server).",
			"-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).",
			"",
			"init(State) ->",
			"\t{ok, State}.",
			"",
			"handle_call(_Event, _From, State) ->",
			"\t{noreply, State}.",
			"",
			"handle_cast(_Event, State) ->",
			"\t{noreply, State}.",
			"",
			"handle_info(_Event, State) ->",
			"\t{noreply, State}.",
			"",
			"terminate(_Reason, _State) ->",
			"\tok.",
			"",
			"code_change(_OldSvn, State, _Extra) ->",
			"\t{ok, State}.",
		}),
	}),
}
