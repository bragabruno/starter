### LSP and Telescope Integration
- Complete LSP integration with Telescope for advanced code navigation
- Press `<C-f>` to search within the current buffer
- Use `<leader>gr` to find all references of a symbol
- Use `<leader>gd` to jump to definitions
- Use `<leader>gi` to find implementations
- Use `<leader>gt` to find type definitions
- Use `<leader>ds` to search document symbols
- Use `<leader>ws` to search workspace symbols
- Use `<leader>fd` to view document diagnostics
- Use `<leader>fD` to view workspace diagnostics

All LSP operations provide interactive preview windows with context and quick navigation.# NvChad Setup Guide with All Required Plugins

This document provides an overview of your customized NvChad setup with all the requested plugins properly configured.

## Enhanced Features

### Dynamic Mason Package Search
A completely redesigned Mason package manager with Telescope integration:
- Press `<leader>pm` to open the Mason package browser
- Type to dynamically search through available packages
- Press `<C-s>` to filter by installation status (installed/not installed)
- Press `<C-c>` to filter by category (LSP, formatter, linter, etc.)
- Press `<C-i>` for quick info about a package
- Press `<Enter>` to install/uninstall packages

The interface provides:
- Real-time filtering as you type
- Preview window with detailed package information
- Visual indicators for installed packages
- Category-based organization

### File Search and Preview
- Enhanced Telescope integration for file search with preview
- Custom Mason UI that mimics grep search results
- File browser with built-in preview

## Installed Plugins

### Plugin Management
- **lazy.nvim** - Modern plugin manager

### UI Enhancements
- **plenary.nvim** - Lua utility functions 
- **vim-tmux-navigator** - Seamless navigation between tmux and vim
- **dressing.nvim** - Better UI for inputs and selects
- **vim-maximizer** - Maximize and restore current window

### Code Navigation and Features
- **telescope.nvim** - Fuzzy finder
- **telescope-fzf-native.nvim** - Fast sorter for telescope
- **nvim-web-devicons** - File icons
- **nvim-tree.lua** - File explorer
- **nvim-treesitter** - Better syntax highlighting and code navigation
- **nvim-ts-autotag** - Auto close and rename HTML tags
- **indent-blankline.nvim** - Indentation guides
- **nvim-cmp** - Completion engine
- **lspkind.nvim** - VS Code-like pictograms for completions
- **luasnip** - Snippet engine
- **nvim-autopairs** - Auto close pairs with completion integration
- **Comment.nvim** - Smart commenting
- **nvim-ts-context-commentstring** - Context-aware commenting

### Git Integration
- **gitsigns.nvim** - Git integration (show changes in gutter)
- **lazygit.nvim** - LazyGit integration

## Key Features

### File Search and Preview
- Enhanced Telescope integration for file search with preview
- Custom Mason UI that mimics grep search results
- File browser with built-in preview

### AI Integration
- Avante.nvim with Claude AI provider
- Multiple AI-based operations including code completion and chat

### LSP Support
- Comprehensive LSP setup with Mason integration
- Easy package management through Telescope-like UI
- Flutter/Dart support

### Git Integration
- Git changes shown in the gutter
- LazyGit integration for a full Git workflow
- Git blame, staging, and diff operations

## Key Mappings

### General
- `<Space>` - Leader key
- `<leader>m` - Toggle window maximization

### File Navigation
- `<C-n>` - Toggle file explorer (NvimTree)
- `<leader>e` - Focus file explorer
- `<leader>ff` - Find files with preview
- `<leader>fg` - Live grep with preview
- `<leader>fb` - Browse buffers with preview
- `<leader>fe` - File explorer with preview
- `<leader>fd` - Browse current directory
- `<leader>fr` - Recent files with preview
- `<leader>fp` - Projects with preview

### Window Management
- `<leader>sv` - Split window vertically
- `<leader>sh` - Split window horizontally
- `<leader>se` - Make splits equal size
- `<leader>sx` - Close current split

### Terminal
- `<C-\>` - Toggle terminal
- `<Esc>` - Exit terminal mode (when in terminal)

### Git
- `<leader>gg` - Open LazyGit
- `<leader>gj` - Next hunk
- `<leader>gk` - Previous hunk
- `<leader>gl` - Blame line
- `<leader>gp` - Preview hunk
- `<leader>gr` - Reset hunk
- `<leader>gs` - Stage hunk
- `<leader>gu` - Undo stage hunk
- `<leader>gd` - Git diff

### LSP
- `gd` - Go to definition
- `gr` - References
- `gi` - Go to implementation
- `gt` - Go to type definition
- `<leader>rn` - Rename
- `<leader>ca` - Code action
- `K` - Show documentation

### Packages and Tools
- `<leader>pm` - Mason packages (Telescope-like UI)
- `<leader>pi` - Install a package
- `<leader>pu` - Uninstall a package
- `<leader>pU` - Update all packages

### AI Integration
- `<leader>aa` - Open Avante
- `<leader>ac` - Open Avante Chat
- `<leader>as` - Open Avante Settings

## Getting Started

1. Launch Neovim to let it install all plugins automatically
2. Run `:checkhealth` to verify everything is working properly
3. Install language servers using `:Mason` or the `<leader>pm` shortcut
4. Set up your Anthropic API key for Avante in `~/.config/nvim/lua/custom/plugins.lua`

## Customization

If you want to customize the configuration further:

- Edit `~/.config/nvim/lua/custom/plugins.lua` to add/remove plugins
- Edit `~/.config/nvim/lua/custom/mappings.lua` to change key mappings
- Edit `~/.config/nvim/lua/custom/chadrc.lua` to change UI elements and options
- Edit `~/.config/nvim/lua/custom/highlights.lua` to modify syntax highlighting

## Tips for Best Experience

1. Install a Nerd Font for proper icon support
2. Install ripgrep for better telescope grep performance
3. Install fd for faster file finding
4. Set up Node.js for LSP servers that require it

Enjoy your enhanced NvChad experience with all the power tools you need!
