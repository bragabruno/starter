local M = {}

-- Integrated keymaps for NvChad
M.general = {
  n = {
    -- Mason Package Manager with dynamic search
    ["<leader>pm"] = { 
      function()
        require("custom.configs.mason_telescope").open()
      end, 
      "Mason Packages (Search UI)" 
    },
    ["<leader>pi"] = { "<cmd>MasonInstall ", "Mason Install (type package)" },
    ["<leader>pu"] = { "<cmd>MasonUninstall ", "Mason Uninstall (type package)" },
    ["<leader>pU"] = { "<cmd>MasonUpdate<CR>", "Mason Update All" },
    
    -- File navigation
    ["<C-n>"] = { "<cmd>NvimTreeToggle<CR>", "Toggle NvimTree" },
    ["<leader>e"] = { "<cmd>NvimTreeFocus<CR>", "Focus NvimTree" },
    
    -- Window management
    ["<leader>sv"] = { "<C-w>v", "Split window vertically" },
    ["<leader>sh"] = { "<C-w>s", "Split window horizontally" },
    ["<leader>se"] = { "<C-w>=", "Make splits equal size" },
    ["<leader>sx"] = { "<cmd>close<CR>", "Close current split" },
    ["<leader>sm"] = { "<cmd>MaximizerToggle<CR>", "Toggle maximized window" },
    
    -- Buffer management
    ["<leader>x"] = { 
      function() 
        require("mini.bufremove").delete(0, false) 
      end, 
      "Close buffer" 
    },
    
    -- Terminal
    ["<C-\\>"] = { "<cmd>ToggleTerm<CR>", "Toggle terminal" },
    
    -- Avante mappings
    ["<leader>aa"] = { "<cmd>Avante<CR>", "Open Avante" },
    ["<leader>ac"] = { "<cmd>AvanteChat<CR>", "Avante Chat" },
    ["<leader>as"] = { "<cmd>AvanteSettings<CR>", "Avante Settings" },
    
    -- Undo tree
    ["<leader>u"] = { "<cmd>UndotreeToggle<CR>", "Toggle Undotree" },
    
    -- Git
    ["<leader>gg"] = { "<cmd>LazyGit<CR>", "Open LazyGit" },
    ["<leader>gj"] = { "<cmd>lua require 'gitsigns'.next_hunk()<CR>", "Next Hunk" },
    ["<leader>gk"] = { "<cmd>lua require 'gitsigns'.prev_hunk()<CR>", "Prev Hunk" },
    ["<leader>gl"] = { "<cmd>lua require 'gitsigns'.blame_line()<CR>", "Blame" },
    ["<leader>gp"] = { "<cmd>lua require 'gitsigns'.preview_hunk()<CR>", "Preview Hunk" },
    ["<leader>gr"] = { "<cmd>lua require 'gitsigns'.reset_hunk()<CR>", "Reset Hunk" },
    ["<leader>gs"] = { "<cmd>lua require 'gitsigns'.stage_hunk()<CR>", "Stage Hunk" },
    ["<leader>gu"] = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<CR>", "Undo Stage Hunk" },
    ["<leader>gd"] = { "<cmd>Gitsigns diffthis HEAD<CR>", "Git Diff" },
    
    -- Flutter commands
    ["<leader>fr"] = { "<cmd>FlutterRun<CR>", "Flutter Run" },
    ["<leader>fq"] = { "<cmd>FlutterQuit<CR>", "Flutter Quit" },
    ["<leader>fR"] = { "<cmd>FlutterReload<CR>", "Flutter Reload" },
    ["<leader>fD"] = { "<cmd>FlutterDetach<CR>", "Flutter Detach" },
    ["<leader>fd"] = { "<cmd>FlutterDevices<CR>", "Flutter Devices" },
    
    -- Telescope with file preview
    ["<leader>ff"] = { "<cmd>Telescope find_files previewer=true<CR>", "Find files with preview" },
    ["<leader>fg"] = { "<cmd>Telescope live_grep previewer=true<CR>", "Live grep with preview" },
    -- File browser with preview
    ["<leader>fb"] = { "<cmd>Telescope buffers previewer=true<CR>", "Buffers with preview" },
    ["<leader>fe"] = { "<cmd>Telescope file_browser previewer=true<CR>", "File explorer with preview" },
    ["<leader>fn"] = { "<cmd>Telescope file_browser path=%:p:h select_buffer=true previewer=true<CR>", "Browse current directory" },
    ["<leader>fo"] = { "<cmd>Telescope oldfiles previewer=true<CR>", "Recent files with preview" },
    ["<leader>fp"] = { "<cmd>Telescope projects previewer=true<CR>", "Projects with preview" },
    
    -- LSP and Telescope integration
    ["<C-f>"] = { 
      function() 
        require("telescope.builtin").current_buffer_fuzzy_find() 
      end, 
      "Search in current buffer" 
    },
    ["<leader>gr"] = { 
      function() 
        require("telescope.builtin").lsp_references() 
      end, 
      "LSP References" 
    },
    ["<leader>gd"] = { 
      function() 
        require("telescope.builtin").lsp_definitions() 
      end, 
      "LSP Definitions" 
    },
    ["<leader>gi"] = { 
      function() 
        require("telescope.builtin").lsp_implementations() 
      end, 
      "LSP Implementations" 
    },
    ["<leader>gt"] = { 
      function() 
        require("telescope.builtin").lsp_type_definitions() 
      end, 
      "LSP Type Definitions" 
    },
    ["<leader>ds"] = { 
      function() 
        require("telescope.builtin").lsp_document_symbols() 
      end, 
      "Document Symbols" 
    },
    ["<leader>ws"] = { 
      function() 
        require("telescope.builtin").lsp_workspace_symbols() 
      end, 
      "Workspace Symbols" 
    },
    ["<leader>fd"] = { 
      function() 
        require("telescope.builtin").diagnostics({bufnr = 0}) 
      end, 
      "Document Diagnostics" 
    },
    ["<leader>fD"] = { 
      function() 
        require("telescope.builtin").diagnostics() 
      end, 
      "Workspace Diagnostics" 
    },
    
    -- Comment.nvim
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },
    
    -- LSP
    ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show documentation" },
    ["<leader>rn"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    ["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code action" },
    ["<leader>d"] = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Show line diagnostics" },
    ["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Previous diagnostic" },
    ["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next diagnostic" },
  },
  
  i = {
    -- Terminal escape
    ["<C-\\>"] = { "<cmd>ToggleTerm<CR>", "Toggle terminal" },
    
    -- Quick search in insert mode
    ["<C-f>"] = { 
      function() 
        require("telescope.builtin").current_buffer_fuzzy_find() 
      end, 
      "Search in current buffer" 
    },
  },
  
  v = {
    -- Avante selection
    ["<leader>as"] = { ":<C-u>AvanteSelection<CR>", "Avante Selection" },
    
    -- Comment
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
    
    -- LSP
    ["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code action" },
    
    -- Git
    ["<leader>gh"] = { "<cmd>lua require 'gitsigns'.stage_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>", "Stage selected hunk" },
  },
  
  t = {
    -- Terminal navigation
    ["<C-h>"] = { "<C-\\><C-n><C-w>h", "Terminal left window navigation" },
    ["<C-j>"] = { "<C-\\><C-n><C-w>j", "Terminal down window navigation" },
    ["<C-k>"] = { "<C-\\><C-n><C-w>k", "Terminal up window navigation" },
    ["<C-l>"] = { "<C-\\><C-n><C-w>l", "Terminal right window navigation" },
    ["<C-\\>"] = { "<cmd>ToggleTerm<CR>", "Toggle terminal" },
    ["<Esc>"] = { "<C-\\><C-n>", "Escape terminal mode" },
  },
}

return M
