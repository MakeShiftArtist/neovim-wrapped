-----------------------------------
-- Telescope

local builtin = require("telescope.builtin")

-- Fuzzy find all files in the current working directory
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
-- Fuzzy find all files tracked with git
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
-- Fuzzy find text in the current working directory
vim.keymap.set("n", "<leader>ps", function()
    builtin.grep_string({ search = vim.fn.input("Grep >") })
end)

