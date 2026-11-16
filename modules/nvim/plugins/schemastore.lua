-----------------------------------
-- SchemaStore.nvim
-- Provides JSON/YAML schemas from https://www.schemastore.org to jsonls and yamlls.
-- vim.lsp.config merges with the base configs in languages/json.lua and languages/yaml.lua.
--
-- Only the schemas listed below are used. Names must match the catalog exactly
-- (an unknown name is an error); browse them at https://www.schemastore.org.
-- The catalog itself is only loaded in before_init, i.e. when a server starts.

local schemastore = require("schemastore")

local json_schemas = {
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    "Deno Config (deno.json)",
    ".luarc.json",
    "prettierrc.json",
    "devcontainer.json",
    "Renovate",
}

local yaml_schemas = {
    "GitHub Workflow",
    "GitHub Action",
    "dependabot-v2.json",
    "docker-compose.yml",
    ".pre-commit-config.yml",
    "devenv.yaml", -- not in the catalog; defined via `extra` below
}

vim.lsp.config("jsonls", {
    before_init = function(_, config)
        config.settings.json.schemas = schemastore.json.schemas({
            select = json_schemas,
        })
    end,
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
        },
    },
    before_init = function(_, config)
        config.settings.yaml.schemas = schemastore.yaml.schemas({
            select = yaml_schemas,
            extra = {
                {
                    description = "devenv configuration schema",
                    fileMatch = { "devenv.yaml", "devenv.yml" },
                    name = "devenv.yaml",
                    url = "https://devenv.sh/devenv.schema.json",
                },
            },
        })
    end,
})
