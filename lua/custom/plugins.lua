local overrides = require "custom.configs.overrides"

local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = overrides.gitsigns,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = overrides.cmp,
  }
}

return plugins
