-- Bash
vim.lsp.config("bashls", {
    cmd = { "bash-language-server", "start" },
    filetypes = { "bash", "sh" },
    root_markers = { ".git" },
})
vim.lsp.enable("bashls")
