local M = {}

M.general = {
  n = {
    -- General mappings
    ["<C-h>"] = { "<C-w>h", "Window left" },
    ["<C-l>"] = { "<C-w>l", "Window right" },
    ["<C-j>"] = { "<C-w>j", "Window down" },
    ["<C-k>"] = { "<C-w>k", "Window up" },

    -- Buffer management
    ["<leader>x"] = { "<cmd>bd<CR>", "Close buffer" },
    ["<leader>n"] = { "<cmd>enew<CR>", "New buffer" },
  },

  i = {
    -- Insert mode mappings
    ["jk"] = { "<ESC>", "Escape insert mode" },
  },

  v = {
    -- Visual mode mappings
    ["<"] = { "<gv", "Indent left" },
    [">"] = { ">gv", "Indent right" },
  },
}

return M
