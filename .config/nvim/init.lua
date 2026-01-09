-- ============================================
-- LEADER KEYS
-- ============================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================
-- GENERAL SETTINGS
-- ============================================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = false
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.incsearch = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.opt.wrap = false

-- Disable EditorConfig
vim.g.editorconfig = false

-- ============================================
-- BASIC KEYMAPS
-- ============================================
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

-- ============================================
-- AUTOCOMMANDS
-- ============================================
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

-- ============================================
-- K8S SECRET EDITOR (base64 decode/encode)
-- ============================================
local K8sSecret = {
    decoded_buffers = {},
}

local function b64decode(str)
    local handle = io.popen("echo '" .. str .. "' | base64 -d 2>/dev/null")
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result:gsub("\n$", "")
    end
    return str
end

local function b64encode(str)
    local handle = io.popen("echo -n '" .. str:gsub("'", "'\\''") .. "' | base64 -w0 2>/dev/null")
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result:gsub("\n$", "")
    end
    return str
end

local function is_data_line(line)
    return line:match("^%s%s[%w_%-]+:%s*.+$") ~= nil
end

function K8sSecret.decode()
    local bufnr = vim.api.nvim_get_current_buf()
    if K8sSecret.decoded_buffers[bufnr] then
        vim.notify("Already decoded. Use :SecretEncode first.", vim.log.levels.WARN)
        return
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local in_data = false
    local modified = false

    for i, line in ipairs(lines) do
        if line:match("^data:%s*$") then
            in_data = true
        elseif line:match("^%S") and in_data then
            in_data = false
        elseif in_data and is_data_line(line) then
            local indent, key, value = line:match("^(%s+)([%w_%-]+):%s*(.+)$")
            if indent and key and value and value ~= "" then
                local decoded = b64decode(value)
                if decoded ~= value then
                    lines[i] = indent .. key .. ": " .. decoded
                    modified = true
                end
            end
        end
    end

    if modified then
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        K8sSecret.decoded_buffers[bufnr] = true
        vim.notify("Decoded. Run :SecretEncode before saving!", vim.log.levels.INFO)
    else
        vim.notify("No base64 values found.", vim.log.levels.WARN)
    end
end

function K8sSecret.encode()
    local bufnr = vim.api.nvim_get_current_buf()
    if not K8sSecret.decoded_buffers[bufnr] then
        vim.notify("Buffer not decoded.", vim.log.levels.WARN)
        return
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local in_data = false

    for i, line in ipairs(lines) do
        if line:match("^data:%s*$") then
            in_data = true
        elseif line:match("^%S") and in_data then
            in_data = false
        elseif in_data and is_data_line(line) then
            local indent, key, value = line:match("^(%s+)([%w_%-]+):%s*(.+)$")
            if indent and key and value and value ~= "" then
                lines[i] = indent .. key .. ": " .. b64encode(value)
            end
        end
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    K8sSecret.decoded_buffers[bufnr] = nil
    vim.notify("Encoded. Safe to save.", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("SecretDecode", K8sSecret.decode, { desc = "Decode K8s secret" })
vim.api.nvim_create_user_command("SecretEncode", K8sSecret.encode, { desc = "Encode K8s secret" })
vim.keymap.set("n", "<leader>kd", ":SecretDecode<CR>", { desc = "[K]8s secret [D]ecode" })
vim.keymap.set("n", "<leader>ke", ":SecretEncode<CR>", { desc = "[K]8s secret [E]ncode" })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*/secrets/secret.*.yaml",
    callback = function()
        if K8sSecret.decoded_buffers[vim.api.nvim_get_current_buf()] then
            vim.notify("WARNING: Saving decoded secret!", vim.log.levels.ERROR)
        end
    end,
})

-- ============================================
-- LAZY.NVIM SETUP
-- ============================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================
-- PLUGINS
-- ============================================
require("lazy").setup({
    -- Claude Code AI
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        build = "npm install -g claude-code",
        config = true,
        keys = {
            { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
        },
    },

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

            -- LSP highlights
            vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#504945", bold = true })
            vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#504945", bold = true })
            vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#7c6f64", bold = true })

            -- Transparent background
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
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

    -- Commenting
    { "numToStr/Comment.nvim", opts = {} },

    -- Git signs
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

    -- Which-key
    {
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function()
            require("which-key").setup()
            require("which-key").add({
                { "<leader>a", name = "[A]I/Claude" },
                { "<leader>c", name = "[C]ode" },
                { "<leader>d", name = "[D]ocument" },
                { "<leader>g", name = "[G]it" },
                { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
                { "<leader>k", name = "[K]8s secrets" },
                { "<leader>r", name = "[R]ename" },
                { "<leader>s", name = "[S]earch" },
                { "<leader>t", name = "[T]erminal" },
                { "<leader>w", name = "[W]orkspace" },
                { "<leader>", name = "VISUAL <leader>", mode = { "v" } },
            })
        end,
    },

    -- Telescope
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
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
            vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find buffers" })
            vim.keymap.set("n", "<leader>/", function()
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false,
                }))
            end, { desc = "Fuzzy search in buffer" })
            vim.keymap.set("n", "<leader>s/", function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                })
            end, { desc = "[S]earch in Open Files" })
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim", opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
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

                    -- Highlight references under cursor
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

            -- Server-specific configurations
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
                ts_ls = {},
                gopls = {},
                html = {},
                cssls = {},
                yamlls = {},
                jsonls = {},
                dockerls = {},
                docker_compose_language_service = {},
            }

            require("mason").setup()

            -- LSPs and tools to install
            local ensure_installed = {
                -- LSPs
                "pyright", -- Python
                "lua_ls", -- Lua
                "ts_ls", -- TypeScript/JavaScript
                "gopls", -- Go
                "html", -- HTML
                "cssls", -- CSS
                "yamlls", -- YAML
                "jsonls", -- JSON
                "dockerls", -- Dockerfile
                "docker_compose_language_service", -- docker-compose

                -- Formatters
                "black", -- Python
                "stylua", -- Lua
                "prettier", -- JS/TS/HTML/CSS/JSON/YAML
                -- "gofmt", -- Go (comes with gopls)
            }

            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),
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

    -- Autoformat
    {
        "stevearc/conform.nvim",
        opts = {
            notify_on_error = false,
            format_on_save = {
                timeout_ms = 5000,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                python = { "black" },
                lua = { "stylua" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                go = { "gofmt" },
            },
        },
    },

    -- Autocompletion
    {
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

    -- Todo comments
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },

    -- Mini.nvim
    {
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

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
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
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
})
