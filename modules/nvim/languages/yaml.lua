-- YAML
vim.lsp.config("yamlls", {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
    root_markers = { ".git" },
    settings = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
            format = { enable = false }, -- formatting handled by conform (prettier)
            validate = true,
            hover = true,
            completion = true,
            -- schemaStore/schemas are configured in plugins/schemastore.lua
        },
    },
})
vim.lsp.enable("yamlls")
