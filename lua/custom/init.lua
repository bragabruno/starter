-- This file is automatically loaded by plugins.config
local plugins = {
  {
    "wbthomason/packer.nvim",
    cmd = { "PackerSync", "PackerInstall" },
  },
  {
    "NvChad/NvChad",
    branch = "main",
    commit = nil,
    pin = true
  }
}

return plugins
