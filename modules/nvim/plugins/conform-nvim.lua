-----------------------------------
-- conform-nvim

local conform = require("conform")

local web_formatters = {
    "deno_fmt",
    "prettierd",
    "prettier",
    stop_after_first = true,
}
conform.setup({
    formatters_by_ft = {
        lua = {
            "stylua",
        },
        python = { "ruff", "black", stop_after_first = true },
        rust = {
            "rustfmt",
        },
        javascript = web_formatters,
        typescript = web_formatters,
        javascriptreact = web_formatters,
        typescriptreact = web_formatters,
        nix = {
            "nixfmt",
            "treefmt",
            lsp_format = "fallback",
            stop_after_first = true,
        },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
})
