# NvChad Custom Configuration Guide

This document provides an overview of the custom configuration set up for your NvChad installation. This setup integrates features from your previous Neovim configuration with NvChad's structure and plugins.

## Key Features

### AI Integration Tools

#### GitHub Copilot
- **Status Indicator**: Shows in the statusline when Copilot is active
- **Key Mappings**:
  - `<C-J>` - Accept suggestion
  - `<C-H>` - Previous suggestion
  - `<C-L>` - Next suggestion
  - `<C-O>` - Dismiss suggestion
  - `<leader>cp` - Open Copilot panel
  - `<leader>ce` - Enable Copilot
  - `<leader>cd` - Disable Copilot
  - `<leader>cs` - Check Copilot status

#### Avante
- **Provider**: Claude is configured as the default AI provider
- **Key Mappings**:
  - `<leader>aa` - Open Avante
  - `<leader>ac` - Open Avante Chat
  - `<leader>as` - Open Avante Settings
  - In visual mode, `<leader>as` - Avante Selection (use AI on selected text)
- **Configuration**: Detailed settings for window behavior, keybindings, and UI are defined in `plugins.lua`

### LSP Configuration
- **Language Servers**: Pre-configured for several languages including HTML, CSS, TypeScript, Python, Go, Rust, and Lua
- **Formatter**: Conform.nvim set up for automatic formatting on save

### UI Customization
- **Theme**: Onedark theme with light/dark toggle capability
- **Highlights**: Custom highlight groups for Copilot, Avante, and improved UI elements
- **Dashboard**: Custom dashboard with AI-focused quick actions
- **Statusline**: Modified to show Copilot status

## File Structure

```
~/.config/nvim/lua/custom/
├── init.lua           # Core settings and keymaps
├── mappings.lua       # NvChad-integrated key mappings
├── plugins.lua        # Plugin configuration
├── chadrc.lua         # NvChad UI configuration
├── highlights.lua     # Custom highlight groups
└── configs/
    ├── lspconfig.lua  # LSP server configuration
    └── conform.lua    # Formatter configuration
```

## Maintenance

### Adding New LSP Servers
To add a new LSP server, edit `configs/lspconfig.lua` and add the server name to the `servers` table.

### Customizing Avante Provider
To change the AI provider or customize settings, edit the Avante configuration in `plugins.lua`.

### Troubleshooting

If you encounter issues:

1. Check the health status with `:checkhealth`
2. Ensure all dependencies are installed:
   - For LSP servers: `:Mason`
   - For formatters: `:MasonInstall stylua prettier black gofmt rustfmt shfmt`
3. For Copilot, run `:Copilot setup` on first use
4. For Avante, ensure you have the appropriate API key set

## Credit

This configuration merges the best of NvChad's framework with custom AI tooling from the previous Neovim setup, providing a modern, AI-enhanced development environment.
