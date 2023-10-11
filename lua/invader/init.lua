local np = require("neoconf.plugins")
local plugin = require("invader.plugin")
local ic = require("invader.config")

local M = {}

function M.setup(opts)
	ic.settings = vim.tbl_extend("keep", opts, ic.settings)
	np.register(plugin)
	require("invader.command")
end

return M
