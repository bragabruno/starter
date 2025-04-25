# NvChad Troubleshooting Guide

This document provides solutions to common issues encountered with NvChad configuration.

## Module Not Found Errors

### Problem: `module 'nvchad.configs.lspconfig' not found`

This error occurs when NvChad is looking for a module at a specific path but can't find it.

**Solution:**

1. Create bridge files:
   ```lua
   -- In ~/.config/nvim/lua/nvchad/configs/lspconfig.lua
   return require("custom.configs.lspconfig")
   
   -- In ~/.config/nvim/lua/nvchad/configs/init.lua
   return {
     lspconfig = require("nvchad.configs.lspconfig"),
   }
   ```

2. Ensure your custom configuration is in the right place:
   ```
   ~/.config/nvim/lua/custom/configs/lspconfig.lua
   ```

### Problem: `module 'nui.split' not found`

This error occurs when Avante.nvim can't find its dependency nui.nvim.

**Solution:**

1. Make sure the dependency is loaded before Avante:
   ```lua
   -- In plugins.lua
   {
     "MunifTanjim/nui.nvim",
     lazy = false, -- Important: Not lazy-loaded
   },
   
   -- Avante config should include
   {
     "yetone/avante.nvim",
     dependencies = {
       "MunifTanjim/nui.nvim", -- List as dependency
     },
   }
   ```

2. If the issue persists, install nui.nvim manually:
   ```bash
   git clone https://github.com/MunifTanjim/nui.nvim.git ~/.local/share/nvim/lazy/nui.nvim
   ```

## Plugin Loading Issues

If plugins aren't loading or you're encountering strange errors:

1. Clear the plugin cache:
   ```bash
   rm -rf ~/.local/share/nvim/lazy
   ```

2. Restart Neovim and let it reinstall plugins

3. Check health status:
   ```
   :checkhealth
   ```

## LSP Configuration Issues

If language servers aren't working properly:

1. Make sure the servers are installed through Mason:
   ```
   :Mason
   ```

2. Manually install required servers:
   ```
   :MasonInstall lua_ls tsserver pyright
   ```

3. Verify that on_attach functions are properly set up in your configuration

## Keybinding Conflicts

If key bindings are conflicting or not working:

1. Check for duplicates in your mapping files
2. Use `:WhichKey` to see available keybindings 
3. Use `:verbose map <key>` to see what a specific key is mapped to

## Performance Issues

If Neovim is slow to start or operate:

1. Use `:LspInfo` to check what servers are running
2. Lazy-load plugins that aren't needed immediately
3. Use `:TSModuleInfo` to check what Treesitter parsers are loaded

## Recovering from Broken Configuration

If you've made changes that break your configuration:

1. Restore from backup:
   ```bash
   cp -r ~/.config/nvim_backup_* ~/.config/nvim
   ```

2. Or revert to NvChad defaults and reimport your custom files:
   ```bash
   rm -rf ~/.config/nvim/lua/custom
   cp -r ~/.config/nvim_backup_*/custom ~/.config/nvim/lua/
   ```

## Getting Help

- Visit the [NvChad GitHub repository](https://github.com/NvChad/NvChad)
- Join the [NvChad Discord server](https://discord.gg/nvchad)
- Check issues on the NvChad repository that may be similar to yours
