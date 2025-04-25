-- Enhanced LSP configuration with Telescope integration
local base = require("plugins.configs.lspconfig")
local on_attach = function(client, bufnr)
  -- Call the default NvChad LSP attach function first
  base.on_attach(client, bufnr)
  
  -- Add LSP specific keymaps
  local map = function(mode, lhs, rhs, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, noremap = true, silent = true })
  end
  
  -- Telescope LSP integration
  local builtin = require('telescope.builtin')
  map("n", "<leader>gr", builtin.lsp_references, "References")
  map("n", "<leader>gd", builtin.lsp_definitions, "Definitions")
  map("n", "<leader>gi", builtin.lsp_implementations, "Implementations")
  map("n", "<leader>gt", builtin.lsp_type_definitions, "Type Definitions")
  map("n", "<leader>ds", builtin.lsp_document_symbols, "Document Symbols")
  map("n", "<leader>ws", builtin.lsp_workspace_symbols, "Workspace Symbols")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
  map("n", "<C-f>", builtin.current_buffer_fuzzy_find, "Search in Current Buffer")
  map("n", "<leader>fd", function() 
    builtin.diagnostics({ bufnr = 0 }) 
  end, "Document Diagnostics")
  map("n", "<leader>fD", builtin.diagnostics, "Workspace Diagnostics")
  
  -- Format document (if server supports it)
  if client.server_capabilities.documentFormattingProvider then
    map("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, "Format Document")
  end
  
  -- Document navigation with diagnostics
  map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
  map("n", "<leader>d", function() vim.diagnostic.open_float({ border = "rounded" }) end, "Line Diagnostics")
end

-- Override base capabilities with those from cmp_nvim_lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities(base.capabilities)

-- Load mason-lspconfig
require("mason-lspconfig").setup({
  -- Ensure servers installed
  ensure_installed = {
    "lua_ls",        -- Lua
    "cssls",         -- CSS
    "html",          -- HTML
    "tsserver",      -- TypeScript/JavaScript
    "pyright",       -- Python
    "gopls",         -- Go
    "rust_analyzer", -- Rust
    "jsonls",        -- JSON
    "yamlls",        -- YAML
    "clangd",        -- C/C++
    "dartls",        -- Dart/Flutter
  },
  automatic_installation = true,
})

-- Configure each server
local lspconfig = require("lspconfig")

-- Import mason-lspconfig to get access to server list
local mason_lspconfig = require("mason-lspconfig")

-- Setup LSP servers
mason_lspconfig.setup_handlers({
  -- Default handler for installed servers
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
  
  -- Server-specific settings
  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand "$VIMRUNTIME/lua"] = true,
              [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
              [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
              [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    })
  end,
  
  -- TypeScript/JavaScript
  ["tsserver"] = function()
    lspconfig.tsserver.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    })
  end,
})

-- Configure global diagnostic settings
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Configure LSP signs
local signs = { Error = "󰀩 ", Warn = "󰀦 ", Hint = "󰌵 ", Info = "󰋽 " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return {
  on_attach = on_attach,
  capabilities = capabilities,
}
