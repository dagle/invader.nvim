local defaults = {
  enabled = false,
  -- a way to always add the base libs
  typelibs = {},
}

local settings = {
  cmd = function (path, obj)
    return string.format("gir-to-stub -l lua -o %s %s.gir", path, obj)
  end,
  path = vim.fn.stdpath("data") .. "/gir-stub",
  ask = false,
}

local config = {
  defaults = defaults,
  settings = settings,
}

return config
