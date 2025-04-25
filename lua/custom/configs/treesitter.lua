-- Custom Treesitter Configuration
local options = {
  ensure_installed = {
    -- Default languages
    "lua", "vim", "vimdoc",
    
    -- Web development
    "html", "css", "javascript", "typescript", "tsx", "json",
    
    -- Programming languages
    "c", "cpp", "rust", "go", "python", "java", "kotlin",
    
    -- Mobile development
    "dart", "swift",
    
    -- Markup and config
    "markdown", "markdown_inline", "yaml", "toml",
    
    -- Shell scripting
    "bash", "fish",
    
    -- Data formats
    "json", "jsonc",
    
    -- Others
    "regex", "comment",
  },
  
  -- Automatically install missing parsers when entering buffer
  auto_install = true,
  
  -- Enhanced highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  
  -- Indentation based on treesitter
  indent = {
    enable = true,
  },
  
  -- Text objects provided by treesitter
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
      },
    },
  },
  
  -- Treesitter context (shows context at the top of the screen)
  context = {
    enable = true,
    max_lines = 3,
  },
}

return options
