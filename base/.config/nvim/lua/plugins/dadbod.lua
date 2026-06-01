-- Database access from Neovim.
-- vim-dadbod          : run queries / connect to the DB
-- vim-dadbod-ui       : sidebar to browse connections (:DBUI)
-- vim-dadbod-completion: feeds nvim-cmp with REAL table/column names
return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1

		-- NEVER put credentials in this file: it is tracked by stow/git.
		-- Connections with credentials live in ~/.dbs.lua (NOT tracked), which
		-- must return a table, e.g.:
		--   return { local_pg = "postgresql://user:pass@host:5432/db" }
		local dbs = {}

		local secrets = vim.fn.expand("~/.dbs.lua")
		if vim.fn.filereadable(secrets) == 1 then
			local ok, extra = pcall(dofile, secrets)
			if ok and type(extra) == "table" then
				dbs = vim.tbl_extend("force", dbs, extra)
			end
		end

		vim.g.dbs = dbs

		-- Drawer indent is shiftwidth() * level; force 2 in the tree buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "dbui",
			callback = function()
				vim.bo.shiftwidth = 2
			end,
		})

		-- In SQL buffers, add dadbod completion alongside your usual sources
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "sql", "mysql", "plsql" },
			callback = function()
				require("cmp").setup.buffer({
					sources = {
						{ name = "vim-dadbod-completion" },
						{ name = "luasnip" },
						{ name = "nvim_lsp" },
						{ name = "path" },
					},
				})
			end,
		})
	end,
}
