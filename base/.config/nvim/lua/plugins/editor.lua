-- Editor enhancement plugins
return {
    -- Markdown preview
    {
        "iamcco/markdown-preview.nvim",
        build = ":call mkdp#util#install()",
        ft = { "markdown" },
    },

    -- Terreno - codebase visualization (local dev)
    {
        "Awerito/terreno.nvim",
        build = "cd app && bash install.sh",
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
}
