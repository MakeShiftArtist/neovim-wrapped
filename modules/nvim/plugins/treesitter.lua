-----------------------------------
-- nvim-treesitter

local opts = {
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
}

require("nvim-treesitter").setup(opts)
