-- Deno: for files in a Deno project (nearest deno.json(c)). Files whose nearest
-- project is a Node one (package.json or tsconfig.json) are left to ts_ls, see
-- typescript.lua; a directory with both counts as Deno.
vim.lsp.config("deno_ls", {
    cmd = { "deno", "lsp" },
    filetypes = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
    },
    -- Only start when on_dir is called, i.e. not for files outside a Deno project
    root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
        local node_root =
            vim.fs.root(bufnr, { "package.json", "tsconfig.json" })
        -- Both are ancestors of the file, so the longer path is the nearer project
        if root and not (node_root and #node_root > #root) then
            on_dir(root)
        end
    end,
    settings = {
        deno = { enable = true, lint = true },
    },
})
vim.lsp.enable("deno_ls")
