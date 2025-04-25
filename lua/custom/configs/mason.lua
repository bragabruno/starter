      -- Add a filter by category function 
      map("i", "<C-f>", function()
        -- Close current picker
        actions.close(prompt_bufnr)
        
        -- Show a category selector
        local categories = {}
        local seen = {}
        
        for _, pkg in ipairs(package_list) do
          for category in string.gmatch(pkg.categories, "([^,]+)") do
            category = category:match("^%s*(.-)%s*$") -- Trim whitespace
            if category ~= "" and not seen[category] then
              seen[category] = true
              table.insert(categories, category)
            end
          end
        end
        
        table.sort(categories)
        table.insert(categories, 1, "All")
        table.insert(categories, 2, "Installed")
        table.insert(categories, 3, "Not Installed")
        
        vim.ui.select(categories, {
          prompt = "Filter packages by category:",
        }, function(choice)
          if not choice then return end
          
          -- Create filtered package list
          local filtered_packages = {}
          
          if choice == "All" then
            filtered_packages = package_list
          elseif choice == "Installed" then
            for _, pkg in ipairs(package_list) do
              if pkg.installed == "✓" then
                table.insert(filtered_packages, pkg)
              end
            end
          elseif choice == "Not Installed" then
            for _, pkg in ipairs(package_list) do
              if pkg.installed == "✗" then
                table.insert(filtered_packages, pkg)
              end
            end
          else
            for _, pkg in ipairs(package_list) do
              if string.find(pkg.categories, choice) then
                table.insert(filtered_packages, pkg)
              end
            end
          end
          
          -- Open a new picker with filtered results
          pickers.new({}, {
            prompt_title = "Mason Packages \"" .. choice .. "\"",
            finder = finders.new_table({
              results = filtered_packages,
              entry_maker = function(entry)
                local display_status = entry.installed == "✓" and "[Installed]" or "[Not Installed]"
                local display_type = "[" .. entry.type:upper() .. "]"
                
                return {
                  value = entry,
                  display = display_status .. " " .. display_type .. " " .. entry.name,
                  ordinal = entry.type .. " " .. entry.name .. " " .. entry.status .. " " .. entry.categories,
                }
              end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(inner_prompt_bufnr, inner_map)
              -- Re-attach same mappings for filtered view
              actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                local package_name = selection.value.name
                local pkg = registry.get_package(package_name)
                
                actions.close(inner_prompt_bufnr)
                
                if pkg:is_installed() then
                  vim.ui.select({"Uninstall", "Cancel"}, {
                    prompt = "Package " .. package_name .. " is already installed. What would you like to do?",
                  }, function(inner_choice)
                    if inner_choice == "Uninstall" then
                      vim.cmd("MasonUninstall " .. package_name)
                    end
                  end)
                else
                  vim.cmd("MasonInstall " .. package_name)
                end
              end)
              
              -- Add the filter capability to the filtered view
              inner_map("i", "<C-f>", function()
                actions.close(inner_prompt_bufnr)
                M.telescope_mason() -- Restart from the beginning
              end)
              
              -- Show package info
              inner_map("i", "<C-i>", function()
                local selection = action_state.get_selected_entry()
                local package_name = selection.value.name
                vim.api.nvim_echo({{"\nPackage: " .. package_name .. "\nStatus: " .. selection.value.status, "Normal"}}, true, {})
              end)
              
              return true
            end,
            previewer = require("telescope.previewers").new_buffer_previewer({
              define_preview = function(self, entry, status)
                local pkg_name = entry.value.name
                local pkg = registry.get_package(pkg_name)
                local content = {}
                
                -- Same preview style as before
                table.insert(content, "# " .. pkg_name .. " (" .. entry.value.type .. ")")
                table.insert(content, "")
                
                table.insert(content, "## Status")
                if pkg:is_installed() then
                  table.insert(content, "**✓ INSTALLED**")
                  
                  -- Add version if available
                  local version = pkg:get_installed_version()
                  if version then
                    table.insert(content, "**Version**: " .. version)
                  end
                else
                  table.insert(content, "**✗ NOT INSTALLED**")
                end
                
                table.insert(content, "")
                table.insert(content, "## Categories")
                local categories = pkg.spec.categories or {}
                if #categories > 0 then
                  for _, category in ipairs(categories) do
                    table.insert(content, "- " .. category)
                  end
                else
                  table.insert(content, "*(No categories specified)*")
                end
                
                table.insert(content, "")
                table.insert(content, "## Actions")
                table.insert(content, "- Press **<Enter>** to " .. (pkg:is_installed() and "uninstall" or "install"))
                table.insert(content, "- Press **<C-i>** for package information")
                table.insert(content, "- Press **<C-f>** to change filter")
                
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, content)
                vim.bo[self.state.bufnr].filetype = "markdown"
                
                vim.api.nvim_buf_add_highlight(self.state.bufnr, -1, "Keyword", 0, 0, -1)
              end
            }),
          }):find()
        end)
      end)-- Custom Mason configuration with Telescope-like UI
local M = {}

M.setup = function()
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")

  -- Setup Mason with enhanced UI
  mason.setup({
    ui = {
      -- Use a border similar to Telescope
      border = "rounded",
      
      -- Enhanced icons
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
      
      -- Use telescope-like keymaps
      keymaps = {
        toggle_package_expand = "<CR>",
        install_package = "i",
        update_package = "u",
        check_package_version = "c",
        update_all_packages = "U",
        check_outdated_packages = "C",
        uninstall_package = "X",
        cancel_installation = "<C-c>",
        apply_language_filter = "<C-f>",
        toggle_help = "?",
      },
    },
  })

  -- Configure Mason-LSPConfig integration
  mason_lspconfig.setup({
    -- Auto-install configured servers
    automatic_installation = true,
    
    -- Ensure these servers are installed
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
  })
end

-- Create a telescope-like interface for Mason
M.telescope_mason = function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  
  -- Get the list of available Mason packages
  local registry = require("mason-registry")
  local package_list = {}
  
  for _, pkg_name in ipairs(registry.get_all_package_names()) do
    local pkg = registry.get_package(pkg_name)
    local installed = pkg:is_installed()
    local categories = pkg.spec.categories or {}
    local package_info = {
      name = pkg_name,
      installed = installed and "✓" or "✗",
      status = installed and "installed" or "not installed",
      categories = table.concat(categories, ", "),
      type = categories[1] or "unknown"
    }
    table.insert(package_list, package_info)
  end
  
  -- Create a telescope picker
  pickers.new({}, {
    prompt_title = "Mason Packages",
    finder = finders.new_table({
      results = package_list,
      entry_maker = function(entry)
        -- Format the display like grep search results
        local display_status = entry.installed == "✓" and "[Installed]" or "[Not Installed]"
        local display_type = "[" .. entry.type:upper() .. "]"
        
        return {
          value = entry,
          -- Format like grep: "filepath:line:column: content"
          display = display_status .. " " .. display_type .. " " .. entry.name,
          ordinal = entry.type .. " " .. entry.name .. " " .. entry.status .. " " .. entry.categories,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      -- Install or uninstall a package
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        local package_name = selection.value.name
        local pkg = registry.get_package(package_name)
        
        actions.close(prompt_bufnr)
        
        -- If installed, give option to uninstall, otherwise install
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
        vim.api.nvim_echo({{"\nPackage: " .. package_name .. "\nStatus: " .. selection.value.status, "Normal"}}, true, {})
      end)
      
      return true
    end,
    previewer = require("telescope.previewers").new_buffer_previewer({
      define_preview = function(self, entry, status)
        local pkg_name = entry.value.name
        local pkg = registry.get_package(pkg_name)
        local content = {}
        
        -- Styled similar to grep search results preview
        table.insert(content, "# " .. pkg_name .. " (" .. entry.value.type .. ")")
        table.insert(content, "")
        
        -- Status section styled like file info in grep
        table.insert(content, "## Status")
        if pkg:is_installed() then
          table.insert(content, "**✓ INSTALLED**")
          
          -- Add version if available
          local version = pkg:get_installed_version()
          if version then
            table.insert(content, "**Version**: " .. version)
          end
        else
          table.insert(content, "**✗ NOT INSTALLED**")
        end
        
        -- Categories section similar to file context in grep
        table.insert(content, "")
        table.insert(content, "## Categories")
        local categories = pkg.spec.categories or {}
        if #categories > 0 then
          for _, category in ipairs(categories) do
            table.insert(content, "- " .. category)
          end
        else
          table.insert(content, "*(No categories specified)*")
        end
        
        -- Installation instructions like grep match context
        table.insert(content, "")
        table.insert(content, "## Actions")
        table.insert(content, "- Press **<Enter>** to " .. (pkg:is_installed() and "uninstall" or "install"))
        table.insert(content, "- Press **<C-i>** for package information")
        table.insert(content, "- Press **<C-f>** to filter by category")
        
        -- Schema version and additional info
        if pkg.spec.schema_version then
          table.insert(content, "")
          table.insert(content, "## Technical Info")
          table.insert(content, "Schema version: " .. pkg.spec.schema_version)
        end
        
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, content)
        vim.bo[self.state.bufnr].filetype = "markdown"
        
        -- Apply syntax highlighting for easier reading
        vim.api.nvim_buf_add_highlight(self.state.bufnr, -1, "Keyword", 0, 0, -1)
      end
    }),
  }):find()
end

return M
