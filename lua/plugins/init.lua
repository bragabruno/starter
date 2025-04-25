-- Default NvChad plugins
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lspconfig") -- This will load our bridge file
    end,
  },

  -- Default plugins that come with NvChad
  "nvim-treesitter/nvim-treesitter",
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "MunifTanjim/nui.nvim",
  
  -- Load our custom plugins
  { import = "custom.plugins" },
}
