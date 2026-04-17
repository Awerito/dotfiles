-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix" })

-- Terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")

-- Disable arrow keys
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus left" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus right" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus down" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus up" })

-- Redo with U
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

-- Indent in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Terminal
vim.keymap.set("n", "<leader>t", "<cmd>vsplit term://zsh | setlocal nonumber norelativenumber | startinsert<CR>")

-- Spell checking
vim.cmd("setlocal spelllang=en_us")
vim.keymap.set("n", "<C-s>", ":setlocal spell!<CR>", { desc = "Toggle spell" })
vim.keymap.set("i", "<C-s>", "<Esc>:setlocal spell!<CR>gi", { desc = "Toggle spell" })
vim.keymap.set("n", "<C-f>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "Fix last misspelled word" })
vim.keymap.set("i", "<C-f>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "Fix last misspelled word" })

-- Markdown
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", { desc = "[M]arkdown [P]review" })
vim.keymap.set("v", "<leader>mt", "<cmd>'<,'>! tr -s ' ' | column -t -s '|' -o '|'<CR>", { desc = "[M]arkdown [T]able" })
