-- Lua
vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
})
vim.lsp.enable("lua_ls")

-- Nix
vim.lsp.config("nixd", {
    cmd = { "nixd" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import <nixpkgs> { }",
            },
        },
        formatting = {
            command = { "nixmft" },
        },
    },
})
vim.lsp.enable("nixd")

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

-- Rust
vim.lsp.config("rust-analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", ".git" },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                targetDir = true,
                allFeatures = true,
            },
            check = { command = "clippy" },
            inlayHints = {
                bindingModeHints = { enabled = true },
                closureCaptureHints = { enable = true },
                maxLength = 100,
            },
            rustc = { source = "discover" },
        },
    },
})
vim.lsp.enable("rust-analyzer")

-- Python
vim.lsp.config("ruff", {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
    settings = { select = { "ALL" } },
})
vim.lsp.enable("ruff")

