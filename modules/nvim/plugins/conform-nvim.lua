-----------------------------------
-- conform-nvim

local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        lua = {
            "stylua",
            lsp_format = "fallback",
        },
        python = { "black" },
        rust = {
            "rustfmt",
            lsp_format = "fallback",
        },
        javascript = {
            "deno_fmt",
            "prettierd",
            "prettier",
            stop_after_first = true,
        },
        typescript = {
            "deno_fmt",
            "prettierd",
            "prettier",
            stop_after_first = true,
        },
        javascriptreact = {
            "deno_fmt",
            "prettierd",
            "prettier",
            stop_after_first = true,
        },
        typescriptreact = {
            "deno_fmt",
            "prettierd",
            "prettier",
            stop_after_first = true,
        },
        nix = {
            "treefmt",
            "nixfmt",
            lsp_format = "fallback",
            stop_after_first = true,
        },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
})
