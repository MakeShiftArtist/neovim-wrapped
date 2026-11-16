-----------------------------------
-- Luasnip

-- Load the VS Code-style snippets on the runtimepath (friendly-snippets, see the
-- luasnip spec). lazy_load only reads a filetype's snippets when it's first used.
require("luasnip.loaders.from_vscode").lazy_load()
