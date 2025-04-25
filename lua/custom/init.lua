-- Custom init.lua for NvChad
-- Migrated from realbackup_nvim configuration

-- Check if nui.nvim is installed and available
local function ensure_nui()
  local has_nui, _ = pcall(require, "nui.split")
  if not has_nui then
    vim.notify("nui.nvim is not installed or not loaded properly. Some features may not work.", vim.log.levels.WARN)
  end
end

-- Basic additional Neovim configurations
local opt = vim.opt
local g = vim.g

-- Enable splash screen by ensuring 'I' is not in shortmess
opt.shortmess:remove('I')

-- Display settings
opt.number = true           -- Show line numbers
opt.relativenumber = true   -- Show relative line numbers
opt.wrap = false            -- Display long lines as just one line
opt.encoding = 'utf-8'      -- The encoding displayed
opt.fileencoding = 'utf-8'  -- The encoding written to file
opt.ruler = true            -- Show the cursor position all the time
opt.mouse = 'a'             -- Enable mouse support
opt.cursorline = true       -- Highlight the current line
opt.signcolumn = 'yes'      -- Always show the signcolumn

-- Indentation
opt.autoindent = true       -- Good auto indent
opt.smartindent = true      -- Makes indenting smart
opt.expandtab = true        -- Converts tabs to spaces
opt.shiftwidth = 2          -- Change a number of space characters inserted for indentation
opt.tabstop = 2             -- Insert 2 spaces for a tab
opt.softtabstop = 2         -- Insert 2 spaces for a tab

-- Search
opt.hlsearch = true         -- Highlight search results
opt.ignorecase = true       -- Ignore case in search patterns
opt.smartcase = true        -- Smart case search if there is uppercase
opt.incsearch = true        -- Shows the match while typing

-- Performance
opt.hidden = true           -- Required to keep multiple buffers open
opt.updatetime = 300        -- Faster completion
opt.timeoutlen = 500        -- By default timeoutlen is 1000 ms

-- Appearance
opt.termguicolors = true    -- True color support
opt.showmode = true         -- Show current mode
opt.showcmd = true          -- Show command in bottom bar
opt.cmdheight = 2           -- More space for displaying messages
opt.pumheight = 10          -- Makes popup menu smaller
opt.showmatch = true        -- Show matching brackets when text indicator is over them

-- Backup and swap
opt.backup = false          -- Don't create backup files
opt.writebackup = false     -- Don't create backup files
opt.swapfile = false        -- Don't create swap files

-- Split windows
opt.splitbelow = true       -- Horizontal splits will automatically be below
opt.splitright = true       -- Vertical splits will automatically be to the right

-- Preview settings for grep and search
opt.grepprg = "rg --vimgrep --no-heading --smart-case"
opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"

-- Create bridge files if needed
if not vim.loop.fs_stat(vim.fn.stdpath("config") .. "/lua/nvchad/configs/lspconfig.lua") then
  -- Create bridge file content
  local bridge_content = "-- Bridge file to load custom lspconfig\nreturn require('custom.configs.lspconfig')"
  
  -- Make sure the directory exists
  vim.fn.mkdir(vim.fn.stdpath("config") .. "/lua/nvchad/configs", "p")
  
  -- Write the bridge file
  local file = io.open(vim.fn.stdpath("config") .. "/lua/nvchad/configs/lspconfig.lua", "w")
  if file then
    file:write(bridge_content)
    file:close()
  end
end

-- Avante keymaps
local keymap = vim.keymap

keymap.set('n', '<leader>aa', '<cmd>Avante<CR>', { 
  noremap = true, 
  silent = true, 
  desc = "Open Avante" 
})

keymap.set('n', '<leader>ac', '<cmd>AvanteChat<CR>', { 
  noremap = true, 
  silent = true, 
  desc = "Open Avante Chat" 
})

keymap.set('n', '<leader>as', '<cmd>AvanteSettings<CR>', { 
  noremap = true, 
  silent = true, 
  desc = "Avante Settings" 
})

-- File preview enhancement keymaps
keymap.set('n', '<C-s>', '<cmd>w<CR>', { 
  noremap = true,
  silent = true, 
  desc = "Save file" 
})

-- Set up clipboard integration for better copy/paste
opt.clipboard = "unnamedplus"

-- Register file preview handlers
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local preview_group = augroup("PreviewEnhancements", { clear = true })

-- Open file at previous position
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local last_pos = vim.fn.line("'\"")
    if last_pos > 0 and last_pos <= vim.fn.line("$") then
      vim.fn.setpos(".", {0, last_pos, 1, 0})
    end
  end,
  group = preview_group,
})

-- Highlight yanked text
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  group = preview_group,
})

-- Auto resize Nvim-Tree and previews on window resize
autocmd("VimResized", {
  pattern = "*",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  group = preview_group,
})

-- Call this at the end to ensure nui.nvim is available for Avante
ensure_nui()
