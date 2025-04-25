-- Configuration for nui.nvim
-- This file ensures that nui.nvim is loaded properly before Avante needs it

-- Create a simple wrapper to make sure nui.nvim is available
local M = {}

M.ensure_loaded = function()
  local ok, nui = pcall(require, "nui.split")
  if not ok then
    vim.notify("Failed to load nui.split. Make sure nui.nvim is installed correctly.", vim.log.levels.ERROR)
    return false
  end
  
  return true
end

return M
