# AI Tools Integration Guide

This guide explains how to set up and use the AI tools (GitHub Copilot and Avante) in your NvChad configuration.

## GitHub Copilot

### First-time Setup
1. Run `:Copilot setup` and follow the authentication prompts
2. After authentication, run `:Copilot enable` to activate Copilot

### Key Features
- **Inline Suggestions**: As you type, Copilot will offer suggestions
- **Panel Mode**: View multiple suggestions in a panel

### Keybindings
- `<C-J>` - Accept the current suggestion
- `<C-H>` - Navigate to previous suggestion
- `<C-L>` - Navigate to next suggestion
- `<C-O>` - Dismiss the current suggestion
- `<leader>cp` - Open Copilot panel with multiple suggestions
- `<leader>ce` - Enable Copilot
- `<leader>cd` - Disable Copilot
- `<leader>cs` - Check Copilot status

### Customization
You can modify Copilot settings in:
- `lua/custom/init.lua` - Basic settings
- `lua/custom/plugins.lua` - Plugin configuration
- `lua/custom/mappings.lua` - Keybindings

## Avante

### First-time Setup
1. Set your Claude API key:
   - Add `export ANTHROPIC_API_KEY=your_api_key_here` to your shell profile
   - Or update the Avante configuration in `lua/custom/plugins.lua`

2. First run may take a moment as Avante compiles dependencies

### Key Features
- **Chat Interface**: Conversational AI within Neovim
- **Code Generation**: Generate code with AI assistance
- **Selection Processing**: Process selected text with AI

### Keybindings
- `<leader>aa` - Open Avante main interface
- `<leader>ac` - Open Avante Chat
- `<leader>as` - Open Avante Settings
- In visual mode, `<leader>as` - Process selected text with Avante

### Customization
Avante is highly customizable. Key configuration sections in `lua/custom/plugins.lua`:
- `provider` - Set your preferred AI model (claude/openai)
- `claude` - Configure model, temperature, and tokens
- `windows` - Adjust UI layout and behavior
- `mappings` - Customize keybindings

### Troubleshooting
- If Avante fails to load, check:
  - API key is set correctly
  - Dependencies were installed correctly (`make` command completed)
  - Required plugins are installed

## Integration Tips

### Workflow Examples
1. **Code Completion**:
   - Start typing a function or comment
   - Let Copilot suggest completions
   - Accept with `<C-J>` or navigate with `<C-H>`/`<C-L>`

2. **Documentation Generation**:
   - Select code with Visual mode
   - Press `<leader>as` to open Avante with selection
   - Ask "Generate documentation for this code"

3. **Problem Solving**:
   - Open Avante Chat with `<leader>ac`
   - Describe the programming challenge
   - Review and refine the suggested solution

### Best Practices
- Use Copilot for rapid, context-aware code completion
- Use Avante for complex reasoning, explanation, and code transformation
- Combine both tools for maximum productivity
