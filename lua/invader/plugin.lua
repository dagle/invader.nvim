local Util = require("neoconf.util")
local Neoconf = require("neoconf")
local ic = require("invader.config")
local cmd = require("invader.command")

local M = {}

function M.on_schema(schema)
	schema:import("invader", ic.defaults)
	schema:set("invader.typelibs", {
		description = "Typelibs we want to use",
	})
end

function M.setup()
	Util.on_config({
		name = "settings/plugins/invader",
		on_config = M.on_new_config,
	})
end

function M.on_new_config(config, root_dir)
	if config.name == "lua_ls" then
		local invader = Neoconf.get("invader", ic.defaults)

		local enabled = invader.enabled

		if not enabled then
			return
		end

		local stubs = {}
		for _, gir in ipairs(invader.typelibs) do
			if cmd.is_installed(gir) then
				gir = gir:gsub("[-.]", "_")
				local target = ic.settings.path .. "/" .. gir
				table.insert(stubs, target)
			end
		end

		if enabled then
			config.settings = Util.merge({
				Lua = {
					workspace = {
						library = {},
					},
				},
			}, config.settings)

			vim.list_extend(config.settings.Lua.workspace.library, stubs)
		end
	end
end

return M
