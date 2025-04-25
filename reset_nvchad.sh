#!/bin/bash
# Reset script for NvChad when encountering issues

echo "=== NvChad Reset Tool ==="
echo "This script will help reset problematic parts of your NvChad setup."
echo ""

# Backup current configuration
timestamp=$(date +%Y%m%d_%H%M%S)
backup_dir="$HOME/.config/nvim_backup_$timestamp"
echo "Creating backup at $backup_dir"
mkdir -p "$backup_dir"
cp -r "$HOME/.config/nvim/lua/custom" "$backup_dir/" 2>/dev/null
cp "$HOME/.config/nvim/lazy-lock.json" "$backup_dir/" 2>/dev/null

# Reset Lazy.nvim
echo "Removing Lazy.nvim cache..."
rm -rf "$HOME/.local/share/nvim/lazy"

# Reset lock file
echo "Creating minimal lock file..."
echo '{
  "lazy.nvim": { "branch": "main", "commit": "aedcd79811d491b60d0a6577a9c2d5f06a141d68" }
}' > "$HOME/.config/nvim/lazy-lock.json"

# Create required directories
echo "Ensuring required directories exist..."
mkdir -p "$HOME/.local/share/nvim/mason/bin"
mkdir -p "$HOME/.config/nvim/lua/nvchad/configs"

echo ""
echo "Reset complete! Now you can restart Neovim."
echo "If you still encounter issues, consider running:"
echo "  rm -rf ~/.config/nvim/plugin"
echo "  rm -rf ~/.local/share/nvim/site"
echo ""
echo "Your backup is stored at: $backup_dir"
