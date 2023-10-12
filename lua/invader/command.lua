local Neoconf = require("neoconf")
local ic = require("invader.config")

local M = {}

-- Print all generated girs
function M.list()
  local buf = {}
  if vim.fn.isdirectory(ic.settings.path) == 1 then
    for file in vim.fs.dir(ic.settings.path) do
      table.insert(buf, file)
    end
  end
  vim.print(buf)
end

--- Install a gir
---@param gir string name of the gir to install
function M.install(gir)
	if gir == nil then
		error("Need to specify a gir")
	end
	local cmd = ic.settings.cmd(ic.settings.path, gir)
	print("Installing " .. gir)
	vim.fn.jobstart(cmd, {
		stderr_buffered = true,
		stdout_buffered = true,
	})
end

--- Install all girs specified in the neoconf in the current project
function M.install_all()
	local invader = Neoconf.get("invader", ic.defaults)

  for _, gir in ipairs(invader.typelibs) do
    M.install(gir)
  end
end

--- Check if a generated gir is installed
---@param gir string name of the gir to check
---@return boolean
function M.is_installed(gir)
	if gir == nil then
		error("Need to specify a gir")
	end
	gir = gir:gsub("[-.]", "_")
	local target = ic.settings.path .. "/" .. gir
	return vim.fn.isdirectory(target) == 1
end

-- Uninstall the specified gir
---@param gir string name of the gir to check
---@return boolean|nil
function M.uninstall(gir)
  if gir == nil then
    error("Need to specify a gir")
  end
  gir = gir:gsub("[-.]", "_")
  local target = ic.settings.path .. "/" .. gir
  return vim.loop.fs_rmdir(target)
end

vim.api.nvim_create_user_command("Invader", function (args)
  if #args.fargs < 1 then
    error("Need at least 1 arguments")
  end

  for key, fun in pairs(M) do
    if args.fargs[1] == key then
      fun(args.fargs[2])
      return
    end
  end
  error("Not an Invader command")
	end, {
  nargs = "*",
  complete = function(lead, line, _)
    local keys = vim.tbl_keys(M)
    if vim.trim(line) == "Invader" then
      return keys
    elseif lead ~= "" then
      return vim.tbl_filter(function(val)
        return vim.startswith(val, lead)
      end, keys)
    end
  end
})

return M
