-- Stores and retrieves picker-specific options

local M = {}

---@type PickerOptions
local options = nil

---Initialize default and user-defined picker options
---@param opts? PickerOptions
function M.initialize_options(opts)
  local default = {
    title_fmt = " Grep Context: %s ",
    opts = {
      actions = {
        ["default"] = require("fzf-lua-grep-context.actions").on_select,
        ["esc"] = require("fzf-lua-grep-context.actions").on_esc,
      },
    },
  }

  options = vim.tbl_deep_extend("force", default, opts or {})
end

---Retrieve the current picker options
---@return table
function M.get_options()
  return options
end

return M
