-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    italic = true,
  },
  CursorLine = {
    bg = "black2",
  },
  NvimTreeFolderName = {
    bold = true,
  },
  NvimTreeOpenedFolderName = {
    bold = true,
    italic = true,
  },
  NvimTreeGitDirty = {
    fg = "red",
  },
  NvimTreeGitNew = {
    fg = "green",
  },
  NvimTreeGitStaged = {
    fg = "vibrant_green",
  },
  NormalFloat = {
    bg = "darker_black",
  },
  FloatBorder = {
    fg = "blue",
    bg = "darker_black",
  },
}

---@type HLTable
M.add = {
  AvanteOutputBorder = { link = "FloatBorder" },
  AvantePromptBorder = { link = "FloatBorder" },
  FlutterToolsOutlineHighlight = { fg = "blue", bg = "one_bg" },
  DartUnitTestSuccess = { fg = "green" },
  DartUnitTestFailure = { fg = "red" },
}

return M
