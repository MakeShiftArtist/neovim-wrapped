-- Set to true if you have a nerd font installed
vim.g.have_nerd_font = true

-- Fix SQLComplete error by using syntax completion instead of dbext (https://github.com/neovim/neovim/issues/14433)
vim.g.omni_sql_default_compl_type = "syntax"

-- Show line numbers in the file
vim.opt.number = true

-- Show relative line numbers
vim.opt.relativenumber = true

-- Wrapped lines are indented equal to actual indentation
vim.opt.breakindent = true

-- Sync clipboard between OS and Neovim
-- See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus" -- Doing "+y yanks to system, making this redundant
-- Save undo history
vim.opt.undofile = true

-- Decrease update time
vim.opt.updatetime = 250
-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Buffer Splitting
vim.opt.splitright = true -- <Crtl> + w -> v
vim.opt.splitbelow = true -- <Crtl> + w -> s

-- Sets how neovim will display certain whitespace characters in the editor
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = ".", nbsp = "⎵" }

-- Only convert tabs to spaces when at the beginning of the line
vim.opt.smarttab = true
-- Automatically convert tab indents to spaces
vim.opt.expandtab = true
-- Change default indent size to 4 spaces
vim.opt.shiftwidth = 4

-- Show which line your cursor is on
vim.opt.cursorline = false

-- Preview substitutions live, as you type
vim.opt.inccommand = "split"

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Case-insenstive search UNLESS \C or one or more capital letters are in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Set highlight on search, clearing on <Esc> set in keymaps.lua
vim.opt.hlsearch = true

-- [[ Basic Autocommands ]]
-- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
-- See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup(
        "kickstart-highlight-yank",
        { clear = true }
    ),
    callback = function()
        vim.hl.on_yank()
    end,
})
