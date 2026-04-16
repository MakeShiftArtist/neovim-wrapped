-----------------------------------
-- Tokyonight

require("tokyonight").setup({
    style = "night",
    transparent = true,
    on_highlights = function(hl, c)
        -- set telescope-bg transparent
        local title = c.blue
        local background = c.bg_dark
        local foreground = c.fg_dark
        local border = "#27A1B9"
        hl.TelescopeNormal = {
            bg = background,
            fg = foreground,
        }
        hl.TelescopeBorder = {
            bg = background,
            fg = border,
        }
        hl.TelescopePromptNormal = {
            bg = background,
        }
        hl.TelescopePromptBorder = {
            bg = background,
            fg = border,
        }
        hl.TelescopePromptTitle = {
            bg = background,
            fg = title,
            bold = true,
        }
        hl.TelescopePreviewTitle = {
            bg = background,
            fg = title,
            bold = true,
        }
        hl.TelescopeResultsTitle = {
            bg = background,
            fg = title,
            bold = true,
        }
    end,
})

function ColorMyPencils(color)
    color = color or "tokyonight-night"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#232323" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    --vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
end

ColorMyPencils()
