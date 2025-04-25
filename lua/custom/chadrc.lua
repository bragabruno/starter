---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "tokyonight",
  theme_toggle = { "tokyonight", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,
  
  -- Customization options
  italic_comments = true,
  
  -- Statusline
  statusline = {
    theme = "default", -- default/vscode/vscode_colored/minimal
    separator_style = "default",
    overriden_modules = function(modules)
      -- Add Avante status indicators to statusline
      table.insert(
        modules,
        8,
        (function()
          local avante_status = " 󰚩 "
          return "%#St_LspStatus#" .. avante_status .. "%#ST_EmptySpace#"
        end)()
      )
    end,
  },
  
  -- Tabufline (tabs/buffers at top)
  tabufline = {
    enabled = true,
    lazyload = true,
    overriden_modules = function()
      return {}
    end,
  },
  
  -- NvDash (dashboard)
  nvdash = {
    load_on_startup = true,
    
    header = {
      "                                                    ",
      " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
      " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
      " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
      " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
      " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
      " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
      "                                                    ",
    },
    
    buttons = {
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "  Recent Files", "Spc f r", "Telescope oldfiles" },
      { "  Find Word", "Spc f g", "Telescope live_grep" },
      { "  File Browser", "Spc f e", "Telescope file_browser" },
      { "  Avante AI", "Spc a a", "Avante" },
      { "  LazyGit", "Spc g g", "LazyGit" },
      { "  Mason Packages", "Spc p m", "MasonPackages" },
      { "  Themes", "Spc t h", "Telescope themes" },
    },
  },
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

-- Set custom options
M.options = {
  -- User interface options
  relativenumber = true,        -- Show relative line numbers
  number = true,                -- Show line numbers
  spell = false,                -- Disable spell checking
  signcolumn = "yes",           -- Always show the sign column
  wrap = false,                 -- Display long lines as just one line
  
  -- Indentation options
  expandtab = true,             -- Convert tabs to spaces
  shiftwidth = 2,               -- Size of an indent
  smartindent = true,           -- Insert indents automatically
  tabstop = 2,                  -- Number of spaces tabs count for
  softtabstop = 2,              -- Number of spaces tabs count for
  
  -- Search options
  ignorecase = true,            -- Ignore case
  smartcase = true,             -- Don't ignore case with capitals
  
  -- Split windows
  splitbelow = true,            -- Put new windows below current
  splitright = true,            -- Put new windows right of current
  
  -- Better display
  cmdheight = 1,                -- More space for displaying messages
  pumheight = 10,               -- Makes popup menu smaller
  showmode = false,             -- Don't show mode since we have a statusline
  showtabline = 2,              -- Always show tabs
  
  -- Backups and history
  backup = false,               -- No backups
  swapfile = false,             -- No swap files
  undofile = true,              -- Enable persistent undo
  writebackup = false,          -- No write backup
  
  -- Performance
  updatetime = 250,             -- Faster completion
  timeoutlen = 300,             -- By default timeoutlen is 1000 ms
  
  -- Behavior
  completeopt = {               -- Better completion experience
    "menu",
    "menuone",
    "noselect",
  },
  conceallevel = 0,             -- So that `` is visible in markdown files
  fileencoding = "utf-8",       -- The encoding written to a file
  hidden = true,                -- Required to keep multiple buffers open
  hlsearch = true,              -- Highlight all matches on search
  mouse = "a",                  -- Enable mouse mode
  
  -- Special features
  termguicolors = true,         -- True color support
  clipboard = "unnamedplus",    -- System clipboard
  scrolloff = 8,                -- Lines of context
  sidescrolloff = 8,            -- Columns of context
  guifont = "monospace:h17",    -- The font used in graphical neovim
}

return M
