return {
  "yetone/avante.nvim",
  lazy = false,
  config = function()
    require("avante").setup({
      -- Required: Add your AI provider API key here
      api_key = vim.env.OPENAI_API_KEY, -- or use environment variable
      
      -- Optional configuration
      model = "gpt-4", -- Default AI model
      temperature = 0.7, -- Response creativity (0.0 - 1.0)
      
      -- Customize keymaps (examples)
      keymaps = {
        chat = "<leader>ac", -- Open chat window
        inline = "<leader>ai", -- Inline completion
        select = "<leader>as", -- Selection-based completion
      },
      
      -- Additional settings
      auto_format = true, -- Format responses automatically
      highlight = true, -- Syntax highlighting in chat window
      chat_window = {
        width = 50, -- Window width in columns
        height = 15, -- Window height in rows
        border = "single", -- Window border style
      },
    })
  end,
  -- Plugin dependencies
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for async operations
  },
}