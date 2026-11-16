-- Deno: Activates if deno.json(c) exists
vim.lsp.config("deno_ls", {
    cmd = { "deno", "lsp" },
    filetypes = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
    },
    root_markers = { "deno.json", "deno.jsonc" },
    single_file_support = false,
    settings = {
        deno = { enable = true, lint = true },
    },
})
vim.lsp.enable("deno_ls")
