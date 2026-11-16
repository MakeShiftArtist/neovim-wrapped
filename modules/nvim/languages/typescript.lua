-- TypeScript: Activates if package.json exists
vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
    },
    root_markers = { "package.json", "tsconfig.json" },
    single_file_support = false,
    -- Custom logic: If Deno config is found in the root, tell ts_ls to shut down
    on_init = function(client)
        local root = client.root_dir
        if root then
            local has_deno = vim.fs.find(
                { "deno.json", "deno.jsonc" },
                { path = root, upward = false }
            )[1]
            if has_deno then
                client.stop()
                return false
            end
        end
        return true
    end,
})
vim.lsp.enable("ts_ls")
