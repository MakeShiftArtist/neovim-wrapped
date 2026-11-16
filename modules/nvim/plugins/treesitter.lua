-----------------------------------
-- nvim-treesitter (main branch)
-- Parsers are provided by nix (see the treesitter spec), so nothing is installed at runtime.
-- On the main branch, highlighting and indentation are enabled per buffer.

vim.api.nvim_create_autocmd("FileType", {
    desc = "Enable treesitter highlighting and indentation",
    group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
    callback = function(args)
        -- Only for filetypes that have a parser available
        if not pcall(vim.treesitter.start, args.buf) then
            return
        end
        vim.bo[args.buf].indentexpr =
            "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
