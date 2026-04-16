-----------------------------------
-- Blink-cmp

local blink = require("blink.cmp")

blink.setup({
    cmdline = { enabled = true },
    signature = {
        enabled = true,
    },
    fuzzy = {
        implementation = "prefer_rust_with_warning",
        max_typos = function(keyword)
            return math.floor(#keyword / 4)
        end,
        frecency = {
            enabled = true,
        },
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer", "omni" },
    },
    completion = {
        -- Inline suggestions while you type
        ghost_text = {
            enabled = true,
            show_with_menu = true,
            show_without_selection = true,
        },
        -- Support for nvim-autopairs
        -- accept = { auto_brackets = { enable = true } },
        menu = {
            auto_show = true,
            border = "rounded",
            winblend = 15,
        },
        list = {
            selection = {
                preselect = true,
                auto_insert = false,
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = {
                border = "rounded",
                winblend = 15,
            },
        },
    },
    keymap = {
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-l>"] = { "select_next", "fallback" },
        ["<C-Down>"] = { "select_next", "fallback" },
        ["<C-h>"] = { "select_prev", "fallback" },
        ["<C-Up>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-k>"] = { "scroll_documentation_up", "fallback" },
        ["<C-j>"] = { "scroll_documentation_down", "fallback" },
    },
})
