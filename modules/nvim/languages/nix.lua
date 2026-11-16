-- Nix
local flake_expr = "(builtins.getFlake (toString ./.))"
local nixos_options =
    string.format("%s.nixosConfigurations.<hostname>.options", flake_expr)
vim.lsp.config("nixd", {
    cmd = { "nixd" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import <nixpkgs> { }",
            },
            options = {
                nixos = {
                    expr = nixos_options,
                },
                -- Cannot figure out why this breaks completions.
                -- home_manager = {
                --     expr = string.format(
                --         "%s.home-manager.users.type.getSubOptions []",
                --         nixos_options
                --     ),
                -- },
                flake_parts = {
                    expr = string.format("%s.debug.options", flake_expr),
                },
                flake_parts2 = {
                    expr = string.format(
                        "%s.currentSystem.options",
                        flake_expr
                    ),
                },
            },
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
})
vim.lsp.enable("nixd")
