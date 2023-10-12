# invader.nvim
Invader is a typelib helper for neovim. Typelibs is what is used to load
gobject based libraries (glib, gio, gtk, etc) into dynamic languages (lua, gjs,
python). This is very cool but comes with a problem, neovim and the lsp can't
pickup the bindings, documentation, etc. This makes the neovim developing
experience sub-optimal.

This plugin uses [gir-to-stub](https://github.com/dagle/gir-to-stub) to
generate a stub file. What invader.nvim does is that it creates an automated
interface to use with [neoconf.nvim](https://github.com/folke/neoconf.nvim).
Right now it only supports lua but hopefully this will change in the future.

## ⚡️Install 
First you need to install [gir-to-stub](https://github.com/dagle/gir-to-stub).
Alternativly you need a way to obtain the stub-files. 

### [lazy](https://github.com/folke/lazy.nvim)
``` lua
  { 'dagle/invader.nvim',
    dependencies = 'folke/neoconf.nvim',
  },
```

## 🚀 Usage

```lua
require("neoconf").setup({
  -- override any of the default settings here
})
-- Add invader after neoconf but before the lsp starts
require("invader").setup({})

-- setup your lsp servers as usual
require("lspconfig").sumneko_lua.setup(...)
```

To setup your .neoconf.json, look in the neoconf.json.example

After setting up your .neoconf.json, installing gir-to-stub and adding
invader to neovim (and doing setup), you can now do:

```
:Invader install_all
```

This will try to install all girs defined in the .neoconf.json
