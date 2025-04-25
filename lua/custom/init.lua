-- Custom init file for NvChad

-- Theme configuration
local function theme_setup()
  -- Material theme setup
  if vim.g.colors_name == "material" then
    require("material").setup({
      contrast = {
        terminal = true,
        sidebars = true,
        floating_windows = true,
        cursor_line = true,
        non_current_windows = true,
      },
      styles = {
        comments = { italic = true },
        strings = { italic = false },
        keywords = { italic = true },
        functions = { italic = false, bold = true },
        variables = {},
      },
      plugins = {
        "gitsigns",
        "nvim-cmp",
        "nvim-tree", 
        "telescope",
        "which-key",
      },
      high_visibility = {
        lighter = false,
        darker = true,
      },
      disable = {
        background = false,
        term_colors = false,
        eob_lines = true,
      },
    })
  end
  
  -- Moonlight theme additional settings
  if vim.g.colors_name == "moonlight" then
    -- Any extra moonlight customizations can go here
  end
end

-- Call theme setup after colorscheme is loaded
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    theme_setup()
  end,
})

-- Set theme-specific terminal colors
vim.opt.termguicolors = true
