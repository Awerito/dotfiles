return {
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
}
