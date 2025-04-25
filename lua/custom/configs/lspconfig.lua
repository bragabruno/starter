-- Custom LSP configuration 
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

-- LSP server setup with basic on_attach function
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Buffer local mappings
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- LSP mappings
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
end

-- Configure mason-lspconfig
require("mason").setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  }
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "tsserver",
    "html",
    "cssls",
    "pyright",
    "jsonls"
  },
  automatic_installation = true,
})

-- Server-specific settings
local lspconfig = require("lspconfig")

-- Lua language server
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

-- TypeScript language server (using ts_ls instead of deprecated tsserver)
lspconfig.typescript = {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- HTML language server
lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- CSS language server
lspconfig.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Python language server
lspconfig.pyright.setup {
  on_attach = on_attach, 
  capabilities = capabilities,
}

-- JSON language server
lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

return {
  on_attach = on_attach,
  capabilities = capabilities,
}
