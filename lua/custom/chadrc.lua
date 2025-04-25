local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

-- Set up Material theme configuration
vim.g.material_style = "deep ocean" -- Options: "darker", "lighter", "oceanic", "palenight", "deep ocean"

-- Set up moonlight configuration
vim.g.moonlight_italic_comments = true
vim.g.moonlight_italic_keywords = true
vim.g.moonlight_italic_functions = true
vim.g.moonlight_contrast = true

M.ui = {
  theme = "moonlight", -- Set moonlight as the default theme
  theme_toggle = { "moonlight", "material" }, -- Toggle between moonlight and material themes

  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
