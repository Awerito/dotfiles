-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Keep numbers in netrw
vim.cmd.autocmd("FileType", "netrw", "setlocal number relativenumber")

-- Set vifmrc syntax like vimrc
vim.cmd.autocmd("BufNewFile,BufRead", "vifmrc", "setlocal filetype=vim")
