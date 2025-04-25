# Neovim Themes Guide: Moonlight & Material

This guide explains how to use the Moonlight and Material themes in your NvChad configuration.

## Currently Installed Themes

1. **Moonlight** - A dark, blue-based theme inspired by VS Code Moonlight
2. **Material** - A customizable Material Design theme with multiple styles

## Theme Switching

You have several ways to switch between themes:

- `<leader>tt` - Toggle between the configured themes (Moonlight & Material)
- `<leader>tm` - (Material only) Cycle through Material theme variants

## Material Theme Variants

The Material theme comes with 5 different styles:

- **darker** - A darker variant of Material
- **lighter** - A light variant of Material
- **oceanic** - A blue-green tinted variant
- **palenight** - A purple-blue tinted variant (similar to Moonlight)
- **deep ocean** - A very dark blue variant (current default)

To change the default Material style, edit this line in `lua/custom/chadrc.lua`:
```lua
vim.g.material_style = "deep ocean"  -- Change to your preferred style
```

## Moonlight Theme Features

The Moonlight theme has several customizable features that are configured in `lua/custom/chadrc.lua`:

- **Italic Comments**: `vim.g.moonlight_italic_comments = true`
- **Italic Keywords**: `vim.g.moonlight_italic_keywords = true`
- **Italic Functions**: `vim.g.moonlight_italic_functions = true`
- **Contrast Mode**: `vim.g.moonlight_contrast = true`

## Advanced Customization

Both themes support additional customization:

1. **Material**: Edit the setup function in `lua/custom/init.lua` to adjust contrast, styles, and plugin integration.

2. **Moonlight**: Add custom highlighting rules to the `moonlight` section in the same file.

## Troubleshooting

If the themes don't appear correctly:

1. Make sure your terminal supports true colors
2. Add `set termguicolors` to your vim configuration
3. Try restarting Neovim to reload the theme

Enjoy your new themes!