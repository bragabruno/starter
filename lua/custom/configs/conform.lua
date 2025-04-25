local options = {
  lsp_fallback = true,
  
  formatters_by_ft = {
    lua = { "stylua" },
    
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    
    python = { "black" },
    
    go = { "gofmt" },
    
    rust = { "rustfmt" },
    
    sh = { "shfmt" },
  },
  
  -- Set up format on save
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
