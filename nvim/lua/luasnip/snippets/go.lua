local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s("eif", {
		t("if err != nil {"), -- literal text
		t({ "", "\t" }), -- newline + tab
		i(1, "return err"), -- cursor position
		t({ "", "}" }),
	}),
}
