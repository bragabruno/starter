-- Enhanced Mason integration with Telescope for dynamic searching
local M = {}

-- Build the package list
local function build_package_list()
  local registry = require("mason-registry")
  local package_list = {}
  
  for _, pkg_name in ipairs(registry.get_all_package_names()) do
    local pkg = registry.get_package(pkg_name)
    local installed = pkg:is_installed()
    local categories = pkg.spec.categories or {}
    
    local category_str = ""
    if #categories > 0 then
      category_str = table.concat(categories, ", ")
    end
    
    local package_info = {
      name = pkg_name,
      installed = installed,
      status = installed and "installed" or "not_installed",
      status_text = installed and "✓ Installed" or "✗ Not Installed",
      categories = category_str,
      category_list = categories,
      type = categories[1] or "unknown",
    }
    table.insert(package_list, package_info)
  end
  
  return package_list
end

-- Create a dynamic Mason finder
M.create_finder = function()
  local finders = require("telescope.finders")
  local package_list = build_package_list()
  
  -- Create a finder with all packages
  return finders.new_table({
    results = package_list,
    entry_maker = function(entry)
      -- Style like grep search results
      local status_prefix = entry.installed and "[✓] " or "[✗] "
      local type_prefix = "[" .. string.upper(entry.type or "UNKNOWN") .. "] "
      
      return {
        value = entry,
        ordinal = entry.name .. " " .. entry.status .. " " .. entry.categories, -- Searchable fields
        display = status_prefix .. type_prefix .. entry.name,
        name = entry.name, -- For sorting
        installed = entry.installed, -- For filtering
        categories = entry.categories, -- For filtering
      }
    end,
  })
end

-- Create a dynamic sorter
M.create_sorter = function()
  local sorters = require("telescope.sorters")
  
  -- Use fzf-native sorter if available
  local ok, fzf_sorter = pcall(require, "telescope._extensions.fzf")
  if ok then
    return fzf_sorter.native_fzf_sorter()
  end
  
  -- Fallback to fuzzy sorter
  return sorters.get_fuzzy_file()
end

-- Attach action mappings
M.attach_mappings = function(prompt_bufnr, map)
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local registry = require("mason-registry")
  
  -- Install or uninstall package
  actions.select_default:replace(function()
    local selection = action_state.get_selected_entry()
    local package_name = selection.value.name
    local pkg = registry.get_package(package_name)
    
    actions.close(prompt_bufnr)
    
    if pkg:is_installed() then
      vim.ui.select({"Uninstall", "Cancel"}, {
        prompt = "Package " .. package_name .. " is already installed. What would you like to do?",
      }, function(choice)
        if choice == "Uninstall" then
          vim.cmd("MasonUninstall " .. package_name)
        end
      end)
    else
      vim.cmd("MasonInstall " .. package_name)
    end
  end)
  
  -- Show package info
  map("i", "<C-i>", function()
    local selection = action_state.get_selected_entry()
    local package_name = selection.value.name
    local pkg = registry.get_package(package_name)
    local installed = pkg:is_installed()
    local status = installed and "Installed ✓" or "Not installed ✗"
    local categories = selection.value.categories
    
    -- Show a more detailed floating window
    local lines = {
      "Package: " .. package_name,
      "Status: " .. status,
      "Categories: " .. categories,
    }
    
    if installed then
      local version = pkg:get_installed_version()
      if version then
        table.insert(lines, "Version: " .. version)
      end
    end
    
    vim.lsp.util.open_floating_preview(lines, "markdown", {
      border = "rounded",
      pad_left = 1,
      pad_right = 1,
    })
  end)
  
  -- Set up filter by installation status
  map("i", "<C-s>", function()
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    local current_filter = current_picker._mason_filter or "all"
    
    -- Toggle between all, installed, not installed
    local new_filter
    if current_filter == "all" then
      new_filter = "installed"
    elseif current_filter == "installed" then
      new_filter = "not_installed"
    else
      new_filter = "all"
    end
    
    -- Update picker
    current_picker._mason_filter = new_filter
    
    -- Show which filter is active
    local title_suffix = ""
    if new_filter == "installed" then
      title_suffix = " (Installed Only)"
    elseif new_filter == "not_installed" then
      title_suffix = " (Not Installed Only)"
    end
    
    current_picker.prompt_title = "Mason Packages" .. title_suffix
    
    -- Apply the filter
    local filtered_results = {}
    for _, pkg in ipairs(build_package_list()) do
      if new_filter == "all" or
         (new_filter == "installed" and pkg.installed) or
         (new_filter == "not_installed" and not pkg.installed) then
        table.insert(filtered_results, pkg)
      end
    end
    
    -- Update the finder with filtered results
    current_picker:refresh(M.create_finder(), { reset_prompt = true })
    
    -- Let the user know what filter is active
    local status_message = "Filter: " .. new_filter
    vim.api.nvim_echo({{status_message, "Normal"}}, true, {})
  end)
  
  -- Set up filter by category
  map("i", "<C-c>", function()
    -- First get all available categories
    local all_categories = {}
    local seen = {}
    
    for _, pkg in ipairs(build_package_list()) do
      for _, category in ipairs(pkg.category_list or {}) do
        if not seen[category] then
          seen[category] = true
          table.insert(all_categories, category)
        end
      end
    end
    
    table.sort(all_categories)
    table.insert(all_categories, 1, "All Categories")
    
    -- Show category selection
    vim.ui.select(all_categories, {
      prompt = "Filter by category:",
    }, function(choice)
      if not choice or choice == "All Categories" then
        -- No filter or reset filter
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        current_picker._mason_category = nil
        current_picker.prompt_title = "Mason Packages"
        current_picker:refresh(M.create_finder(), { reset_prompt = true })
      else
        -- Apply category filter
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        current_picker._mason_category = choice
        current_picker.prompt_title = "Mason Packages (Category: " .. choice .. ")"
        
        -- Filter packages by selected category
        local filtered_results = {}
        for _, pkg in ipairs(build_package_list()) do
          if vim.tbl_contains(pkg.category_list or {}, choice) then
            table.insert(filtered_results, pkg)
          end
        end
        
        -- Create a new finder with filtered results
        local finders = require("telescope.finders")
        local new_finder = finders.new_table({
          results = filtered_results,
          entry_maker = function(entry)
            local status_prefix = entry.installed and "[✓] " or "[✗] "
            local type_prefix = "[" .. string.upper(entry.type or "UNKNOWN") .. "] "
            
            return {
              value = entry,
              ordinal = entry.name .. " " .. entry.status .. " " .. entry.categories,
              display = status_prefix .. type_prefix .. entry.name,
              name = entry.name,
              installed = entry.installed,
              categories = entry.categories,
            }
          end,
        })
        
        -- Update picker with new finder
        current_picker:refresh(new_finder, { reset_prompt = true })
      end
    end)
  end)
  
  return true
end

-- Create a preview that shows package details
M.create_previewer = function()
  local previewers = require("telescope.previewers")
  
  return previewers.new_buffer_previewer({
    title = "Package Details",
    define_preview = function(self, entry, status)
      local pkg_name = entry.value.name
      local registry = require("mason-registry")
      local pkg = registry.get_package(pkg_name)
      local content = {}
      
      -- Format the preview like a grep result
      table.insert(content, "# " .. pkg_name)
      table.insert(content, "")
      
      -- Status section
      table.insert(content, "## Status")
      if entry.value.installed then
        table.insert(content, "**✓ INSTALLED**")
        
        -- Add version if available
        local version = pkg:get_installed_version()
        if version then
          table.insert(content, "**Version**: " .. version)
        end
      else
        table.insert(content, "**✗ NOT INSTALLED**")
      end
      
      -- Categories
      table.insert(content, "")
      table.insert(content, "## Categories")
      if #entry.value.category_list > 0 then
        for _, category in ipairs(entry.value.category_list) do
          table.insert(content, "- " .. category)
        end
      else
        table.insert(content, "*(No categories specified)*")
      end
      
      -- Keymaps help
      table.insert(content, "")
      table.insert(content, "## Available Actions")
      table.insert(content, "- Press **<Enter>** to " .. (entry.value.installed and "uninstall" or "install"))
      table.insert(content, "- Press **<C-s>** to filter by installation status")
      table.insert(content, "- Press **<C-c>** to filter by category")
      table.insert(content, "- Press **<C-i>** for quick package info")
      
      -- Schema and technical info
      if pkg.spec.schema_version then
        table.insert(content, "")
        table.insert(content, "## Technical Info")
        table.insert(content, "Schema version: " .. pkg.spec.schema_version)
      end
      
      -- Set content and highlight
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, content)
      vim.bo[self.state.bufnr].filetype = "markdown"
      
      -- Add syntax highlighting
      vim.api.nvim_buf_add_highlight(self.state.bufnr, -1, "Title", 0, 0, -1)
    end,
  })
end

-- Main function to open the Mason UI
M.open = function()
  local pickers = require("telescope.pickers")
  local conf = require("telescope.config").values
  
  -- Create the picker
  pickers.new({}, {
    prompt_title = "Mason Packages",
    finder = M.create_finder(),
    sorter = M.create_sorter(),
    previewer = M.create_previewer(),
    attach_mappings = M.attach_mappings,
    layout_config = {
      width = 0.8,
      height = 0.8,
      preview_width = 0.5,
    },
  }):find()
end

return M
