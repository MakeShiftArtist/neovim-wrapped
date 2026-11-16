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
