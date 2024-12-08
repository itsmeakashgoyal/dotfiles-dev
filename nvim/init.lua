--Enable the new |lua-loader| that byte-compiles and caches lua files.
vim.loader.enable()

require("config.keymaps")
require("config.utils")
require("config.plugin_specs")
require("config.options")
require("config.misc")
require("plugins.misc")
require("plugins.lualine")
require("plugins.dressing")
require("plugins.dap")
require("plugins.gitsigns")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.trouble")
require("plugins.zenmode")
require("plugins.neogit")
require("plugins.codesnap")
require("plugins.harpoon")
require("plugins.neoformat")

-- vim: ts=8 sts=2 sw=2 et