-----------------------------------
-- SchemaStore.nvim
-- Provides JSON/YAML schemas from https://www.schemastore.org to jsonls and yamlls.
-- vim.lsp.config merges with the base configs in lsp.lua.

local schemastore = require("schemastore")

vim.lsp.config("jsonls", {
    settings = {
        json = {
            schemas = schemastore.json.schemas({}),
            validate = { enable = true },
        },
    },
})

vim.lsp.config("yamlls", {
    settings = {
        yaml = {
            schemaStore = {
                -- Disable yamlls' built-in SchemaStore fetching in favor of SchemaStore.nvim
                enable = false,
                -- Avoid a TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
            },
            schemas = schemastore.yaml.schemas({
                extra = {
                    {
                        description = "devenv configuration schema",
                        fileMatch = { "devenv.yaml", "devenv.yml" },
                        name = "devenv.yaml",
                        url = "https://devenv.sh/devenv.schema.json",
                    },
                },
            }),
        },
    },
})
