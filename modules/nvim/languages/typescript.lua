-- TypeScript: for files in a Node project (nearest package.json or tsconfig.json).
-- Files whose nearest project is a Deno one (deno.json(c)) are left to deno_ls,
-- see deno.lua; a directory with both counts as Deno.
vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
    },
    -- Only start when on_dir is called, i.e. not for files outside a Node project
    root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, { "package.json", "tsconfig.json" })
        local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
        -- Both are ancestors of the file, so the longer path is the nearer project
        if root and not (deno_root and #deno_root >= #root) then
            on_dir(root)
        end
    end,
})
vim.lsp.enable("ts_ls")
