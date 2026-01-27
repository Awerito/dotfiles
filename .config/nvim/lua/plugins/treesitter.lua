return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
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
        })
    end,
}
