-- Enhanced previewer for Telescope to improve file preview experience
local M = {}

-- Get preview maker for specific file types
function M.get_preview_maker()
  local previewers = require("telescope.previewers")
  local Job = require("plenary.job")
  local preview_makers = {}

  -- Custom preview handling for different file types
  preview_makers.buffer_previewer_maker = function(filepath, bufnr, opts)
    opts = opts or {}
    
    filepath = vim.fn.expand(filepath)
    vim.loop.fs_stat(filepath, function(_, stat)
      if not stat then return end
      if stat.size > 100000 then
        -- If file is too large, just show a message instead of preview
        return require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- Use file extension to determine best preview method
        local ext = vim.fn.fnamemodify(filepath, ":e"):lower()
        
        if vim.tbl_contains({ "png", "jpg", "jpeg", "gif", "webp" }, ext) then
          -- Image preview (requires telescope-media-files.nvim)
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "IMAGE PREVIEW", filepath })
          end)
        elseif vim.tbl_contains({ "json", "yml", "yaml" }, ext) then
          -- Prettify JSON/YAML files
          vim.schedule(function()
            local output = {}
            if ext == "json" then
              Job:new({
                command = "jq",
                args = { "." },
                writer = filepath,
                on_exit = function(j)
                  output = j:result()
                end,
              }):sync()
            else
              -- Just use normal preview for YAML
              previewers.buffer_previewer_maker(filepath, bufnr, opts)
              return
            end
            
            if #output > 0 then
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
              vim.bo[bufnr].filetype = ext
            else
              previewers.buffer_previewer_maker(filepath, bufnr, opts)
            end
          end)
        elseif ext == "md" then
          -- Markdown files with syntax highlighting
          vim.schedule(function()
            local lines = {}
            local fd = vim.loop.fs_open(filepath, "r", 438)
            if fd then
              local stat = vim.loop.fs_fstat(fd)
              if stat then
                lines = vim.loop.fs_read(fd, stat.size, 0)
                lines = vim.split(lines, "\n")
              end
              vim.loop.fs_close(fd)
            end
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.bo[bufnr].filetype = "markdown"
          end)
        else
          -- Default previewer
          previewers.buffer_previewer_maker(filepath, bufnr, opts)
        end
      end
    end)
  end

  return preview_makers
end

-- Enhanced buffer previewer with syntax highlighting
function M.get_telescope_defaults()
  local telescope_defaults = {
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    buffer_previewer_maker = M.get_preview_maker().buffer_previewer_maker,
  }
  
  return telescope_defaults
end

return M
