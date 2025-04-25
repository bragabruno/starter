-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- local function add_hl(name, value)
--   vim.api.nvim_set_hl(0, name, value)
-- end

local M = {}

---@type Base46HLGroupsList
M.override = {
  -- Add highlight group overrides here
}

---@type HLTable
M.add = {
  -- Add new highlight groups here
}

return M
