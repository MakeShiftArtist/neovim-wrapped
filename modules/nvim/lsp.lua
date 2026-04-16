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

-- TODO: Fix typescript lsp
-- TypeScript
-- vim.lsp.config("ts_ls", {
--     cmd = { 'typescript-language-server' },
--     filetype = { "ts" },
--     root_markers = { { 'tsconfig.json' }, '.git' },
-- })
-- vim.lsp.enable("ts_ls")
vim.lsp.config("deno_ls", {
    cmd = { "deno", "lsp" },
    filetype = { "javascript", "typescript", "jsx", "tsx" },
    root_markers = { "deno.json", "deno.jsonc", ".git" },
    single_file_support = false,
    settings = {
        deno = {
            enable = true,
            lint = true,
        },
    },
})
vim.lsp.enable("deno_ls")

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

