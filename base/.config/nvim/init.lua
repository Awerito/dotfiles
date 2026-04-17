-- Leader keys (must be set before lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

-- Load custom modules
require("custom.k8s-secret")
