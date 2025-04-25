-- Enhanced Telescope configuration with LSP integration
local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

local options = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules", "^.git/", "^.cache/", "%.o", "%.a", "%.out", "%.class" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" },
    
    -- Use our enhanced buffer previewer
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    buffer_previewer_maker = function(filepath, bufnr, opts)
      opts = opts or {}
      
      filepath = vim.fn.expand(filepath)
      vim.loop.fs_stat(filepath, function(_, stat)
        if not stat then return end
        if stat.size > 100000 then
          -- If file is too large, show a message instead of preview
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "File too large to preview" })
          end)
        else
          require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
        end
      end)
    end,
    
    -- Enhanced mappings
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-c>"] = actions.close,
        ["<C-u>"] = false, -- Clear the prompt line with <C-u>
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-f>"] = actions.preview_scrolling_up,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
        ["<CR>"] = actions.select_default,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
      },
      n = {
        ["<esc>"] = actions.close,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["q"] = actions.close,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
        ["<CR>"] = actions.select_default,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
      },
    },
  },
  
  pickers = {
    -- Find files configuration
    find_files = {
      previewer = true,
      hidden = true,
      find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
    },
    
    -- Live grep configuration
    live_grep = {
      previewer = true,
      only_sort_text = true,
      additional_args = function(opts)
        return {"--hidden"}
      end,
    },
    
    -- Buffers configuration
    buffers = {
      previewer = true,
      initial_mode = "normal",
      mappings = {
        n = {
          ["d"] = actions.delete_buffer,
        },
      },
    },
    
    -- LSP related pickers
    lsp_references = {
      theme = "dropdown",
      initial_mode = "normal",
      path_display = { "truncate" },
    },
    lsp_definitions = {
      theme = "dropdown",
      initial_mode = "normal",
      path_display = { "truncate" },
    },
    lsp_declarations = {
      theme = "dropdown",
      initial_mode = "normal",
      path_display = { "truncate" },
    },
    lsp_implementations = {
      theme = "dropdown",
      initial_mode = "normal",
      path_display = { "truncate" },
    },
    
    -- Symbol pickers
    lsp_document_symbols = {
      theme = "dropdown",
      previewer = false,
      symbol_width = 50,
    },
    lsp_workspace_symbols = {
      theme = "dropdown",
      previewer = false,
      symbol_width = 50,
    },
    
    -- Current buffer fuzzy find (the <C-f> functionality)
    current_buffer_fuzzy_find = {
      previewer = false,
      theme = "dropdown",
      prompt_title = "Search Current Buffer",
    },
  },
  
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    file_browser = {
      theme = "dropdown",
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          ["<C-w>"] = function() vim.cmd('normal vbd') end,
        },
        ["n"] = {
          ["h"] = require("telescope").extensions.file_browser.actions.goto_parent_dir,
          ["/"] = function() vim.cmd('startinsert') end,
        },
      },
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- Even more opts
        previewer = false,
        layout_config = {
          width = 0.5,
        },
      },
    },
  },
}

-- Setup custom Telescope key mappings for LSP operations
local setup_telescope_mappings = function()
  local wk = require("which-key")
  
  -- LSP group
  wk.register({
    g = {
      name = "Go To",
      r = { builtin.lsp_references, "References" },
      d = { builtin.lsp_definitions, "Definition" },
      i = { builtin.lsp_implementations, "Implementation" },
      t = { builtin.lsp_type_definitions, "Type Definition" },
    },
    
    -- Document symbols group
    d = {
      name = "Document",
      s = { builtin.lsp_document_symbols, "Document Symbols" },
    },
    
    -- Workspace group
    w = {
      name = "Workspace",
      s = { builtin.lsp_workspace_symbols, "Workspace Symbols" },
    },
  }, { prefix = "<leader>" })
  
  -- Add C-f mapping globally
  vim.keymap.set({"n", "i"}, "<C-f>", function()
    builtin.current_buffer_fuzzy_find({ 
      previewer = false,
      theme = "dropdown",
    })
  end, { desc = "Search in current buffer" })
end

-- Call setup after loading the plugin
local M = {}

M.setup = function()
  telescope.setup(options)
  
  -- Load extensions
  telescope.load_extension("fzf")
  telescope.load_extension("file_browser")
  telescope.load_extension("ui-select")
  
  -- Setup additional mappings
  setup_telescope_mappings()
end

return M
