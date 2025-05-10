vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Incremental search
vim.opt.incsearch = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = false
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Disable EditorConfig
vim.g.editorconfig = false

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- [[ Plugin Specs list ]]
    -- Copilot
    "github/copilot.vim",

    -- Colorscheme
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = "dark"
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_foreground = "mix"
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_enable_bold = 1
            vim.g.gruvbox_material_ui_contrast = "high"
            vim.g.gruvbox_material_statusline_style = "default"
            vim.g.gruvbox_material_sign_column_background = "none"
            vim.cmd.colorscheme("gruvbox-material")
            -- Override highlight groups used by LSP
            vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#504945", bold = true })
            vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#504945", bold = true })
            vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#7c6f64", bold = true })
        end,
    },

    -- Markdown preview
    {
        "iamcco/markdown-preview.nvim",
        build = ":call mkdp#util#install()",
        ft = { "markdown" },
    },

    -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",

    -- Commenting plugin
    { "numToStr/Comment.nvim", opts = {} },

    -- Gitsigns
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },

    -- Which-key is a keybinding helper that shows you possible keybindings
    {
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function()
            require("which-key").setup()

            -- Document existing key chains
            require("which-key").add({
                { "<leader>c", name = "[C]ode" },
                { "<leader>d", name = "[D]ocument" },
                { "<leader>g", name = "[G]it" },
                { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
                { "<leader>r", name = "[R]ename" },
                { "<leader>s", name = "[S]earch" },
                { "<leader>t", name = "[T]erminal" },
                { "<leader>w", name = "[W]orkspace" },
                -- register which-key VISUAL mode
                -- required for visual <leader>hs (hunk stage) to work
                { "<leader>", name = "VISUAL <leader>", mode = { "v" } },
            })
        end,
    },

    -- [[ Fuzzy Finder ]]
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-tree/nvim-web-devicons" },
        },
        config = function()
            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            -- Enable telescope extensions, if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            -- See `:help telescope.builtin`
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
            vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

            -- Slightly advanced example of overriding default behavior and theme
            vim.keymap.set("n", "<leader>/", function()
                -- You can pass additional configuration to telescope to change theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false,
                }))
            end, { desc = "[/] Fuzzily search in current buffer" })

            -- Also possible to pass additional configuration options.
            vim.keymap.set("n", "<leader>s/", function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                })
            end, { desc = "[S]earch [/] in Open Files" })
        end,
    },

    { -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for neovim
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Useful status updates for LSP.
            { "j-hui/fidget.nvim", opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                    map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                    map("K", vim.lsp.buf.hover, "Hover Documentation")
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            local servers = {
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "workspace",
                            },
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    "${3rd}/luv/library",
                                    unpack(vim.api.nvim_get_runtime_file("", true)),
                                },
                            },
                        },
                    },
                },
            }

            require("mason").setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua", -- Used to format lua code
                "black", -- Used to format python code
                "clangd", -- Used for C/C++/Objective-C
                "jq", -- Used for JSON
                "sqlls", -- Used for SQL
                "eslint", -- Used for JavaScript
                "prettier", -- Used for formatting JavaScript/TypeScript
                "prettierd", -- Used for formatting HTML/CSS
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "clangd",
                    "sqlls",
                    "eslint",
                },
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        require("lspconfig")[server_name].setup({
                            cmd = server.cmd,
                            settings = server.settings,
                            filetypes = server.filetypes,
                            capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {}),
                        })
                    end,
                },
            })
        end,
    },

    { -- Autoformat
        "stevearc/conform.nvim",
        opts = {
            notify_on_error = false,
            format_on_save = {
                timeout_ms = 5000, -- 5 second timeout
                lsp_fallback = true,
            },
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                html = { "prettierd" },
                json = { "jq" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                css = { "prettierd" },
            },
        },
    },

    { -- Autocompletion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
            },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },

                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete({}),
                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                },
            })
        end,
    },

    -- Highlight todo, notes, etc in comments
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },

    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        config = function()
            require("mini.ai").setup({ n_lines = 500 })
            require("mini.surround").setup()
            require("mini.statusline").setup({ use_icons = true })
            MiniStatusline.section_location = function()
                return "%2l:%-2v"
            end
        end,
    },

    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "c",
                    "html",
                    "lua",
                    "markdown",
                    "vimdoc",
                    "python",
                    "javascript",
                    "typescript",
                },
                -- Autoinstall languages that are not installed
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
})

-- Transparent background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })

-- Redo with U
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo with [U]" })

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move [J] lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move [K] lines up" })

-- Indent lines in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent [L]eft" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent [R]ight" })

-- Keep number and relativenumber on netrw
vim.cmd.autocmd("FileType", "netrw", "setlocal number relativenumber")

-- -- <leader>t opens a vertical terminal without numberlines and in insert mode
vim.keymap.set("n", "<leader>t", "<cmd>vsplit term://zsh | setlocal nonumber norelativenumber | startinsert<CR>")

-- In terminal mode move between windows with <C-hjkl>
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")

-- Activate spell checking for Spanish and English
vim.cmd("setlocal spelllang=en_us")
-- Set <C-s> to activate and deactivate spell checking
vim.keymap.set("n", "<C-s>", ":setlocal spell!<CR>", { desc = "Toggle [S]pell" })
vim.keymap.set("i", "<C-s>", "<Esc>:setlocal spell!<CR>gi", { desc = "Toggle [S]pell" })
vim.keymap.set("n", "<C-f>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "[F]ix last misspelled word" })
vim.keymap.set("i", "<C-f>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "[F]ix last misspelled word" })

-- Set syntax highlighting for vifmrc file like vimrc
vim.cmd.autocmd("BufNewFile,BufRead", "vifmrc", "setlocal filetype=vim")

-- Leader mp to open markdown preview
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<CR>")

-- Leader mt formats the markdown table selected
vim.keymap.set("v", "<leader>mt", "<cmd>'<,'>! tr -s ' ' | column -t -s '|' -o '|'<CR>", { desc = "[M]arkdown [T]able" })

-- No wrap lines
vim.opt.wrap = false
