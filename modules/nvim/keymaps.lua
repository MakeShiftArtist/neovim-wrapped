-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happenn before plugins are loaded (Otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Removes search highlights on <Esc>
vim.keymap.set(
    "n",
    "<Esc>",
    "<cmd>nohlsearch<CR>",
    { desc = "Removes search highlightt" }
)
-- Exit insert mode if typing jj
-- vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" }) -- Disabled due to delay in jj

-- Open native file tree
vim.keymap.set(
    "n",
    "<leader>pv",
    vim.cmd.Ex,
    { desc = "Open the native file tree" }
)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to the next [D]idanostic message" })
vim.keymap.set(
    "n",
    "<leader>e",
    vim.diagnostic.open_float,
    { desc = "Show diagnostic [E]rror message" }
)
vim.keymap.set(
    "n",
    "<leader>q",
    vim.diagnostic.setloclist,
    { desc = "Open diagnostic [Q]uickfix" }
)

-- Center cursor when using Ctrl + d or Ctrl + u
vim.keymap.set(
    "n",
    "<C-u>",
    "<C-u>zz",
    { desc = "Move up half the page and center the cursor" }
)
vim.keymap.set(
    "n",
    "<C-d>",
    "<C-d>zz",
    { desc = "Move down half the page and center the cursor" }
)

