-- Rust
-- `info.rust_src` is set by the rust spec in neovim.nix, only when the bundled
-- toolchain is enabled (settings.rust.toolchain.enable)
local info = ...

vim.lsp.config("rust-analyzer", {
    -- Use the bundled std sources only if the toolchain in use (which may be the
    -- project's own) doesn't ship them, so std always matches when it can.
    before_init = function(_, config)
        if not info.rust_src then
            return
        end
        local sysroot = vim.system(
            { "rustc", "--print", "sysroot" },
            { cwd = config.root_dir, text = true }
        ):wait()
        local has_src = sysroot.code == 0
            and vim.uv.fs_stat(
                vim.trim(sysroot.stdout) .. "/lib/rustlib/src/rust/library"
            )
        if not has_src then
            config.settings["rust-analyzer"].cargo.sysrootSrc = info.rust_src
        end
    end,
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
