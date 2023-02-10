local Neoconf = require("neoconf")
local ic = require("invader.config")

local M = {}

function M.list()
  local buf = {}
  if vim.fn.isdirectory(ic.settings.path) == 1 then
    for file in vim.fs.dir(ic.settings.path) do
      table.insert(buf, file)
    end
  end
  return buf
end

function M.install(gir)
  if gir == nil then
    error("Need to specify a gir")
  end
  local cmd = ic.settings.cmd(ic.settings.path, gir)
  vim.fn.jobstart(cmd, {
    stderr_buffered = true,
    stdout_buffered = true,
  })
end

function M.install_all()
    local invader = Neoconf.get("invader", ic.defaults)

    local status = string.format("Installing %d packages", #invader.typelibs)
    print(status)
    for _, gir in ipairs(invader.typelibs) do
      print("Installing " .. gir)
      M.install(gir)
    end
end

function M.is_installed(gir)
  if gir == nil then
    error("Need to specify a gir")
  end
  gir = gir:gsub("[-.]", "_")
  local target = ic.settings.path .. "/" .. gir
  return vim.fn.isdirectory(target) == 1
end

function M.uninstall(gir)
  if gir == nil then
    error("Need to specify a gir")
  end
  gir = gir:gsub("[-.]", "_")
  local target = ic.settings.path .. "/" .. gir
  vim.loop.fs_rmdir(target)
end

vim.api.nvim_create_user_command("Invader", function (args)
  if #args.fargs < 1 then
    error("Need at least 2 arguments")
  end

  for key, fun in ipairs(M) do
    if args.fargs[1] == key then
      fun(args.fargs[2])
    end
  end
	end, {
	nargs = "*",
})

return M
