-- LuaSnip config
-- This is luasnip initialized
local ls = require("luasnip")
-- local s = ls.s
-- local fmt = require("luasnip.extras.fmt").fmt
-- local i = ls.insert_node
-- local rep = require("luasnip.extras").rep

-- Snippets in lua
ls.snippets = {
	all = {
		ls.parser.parse_snippet("expand", "This is expanded"),
	},
	-- lua = {
	-- 	s("req", fmt("local {} = require('{}')", {i(1, "default"), rep(1)} )),
	-- },	
}
