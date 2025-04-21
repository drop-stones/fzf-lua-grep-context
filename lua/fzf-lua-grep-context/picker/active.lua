-- Manages current picker state: group name, options, and resume data
local contexts = require("fzf-lua-grep-context.contexts")
local options = require("fzf-lua-grep-context.picker.options")

local M = {}

---Currently selected context group name
---@type table
local resume_data = {}
---Resume data from fzf-lua
---@type string
local group_ = ""
---Options for picker invocation
---@type table
local opts_ = {}

---Set the active context group and picker options
---@param group string
---@param opts? table
function M.set(group, opts)
  resume_data = vim.deepcopy(require("fzf-lua.config").__resume_data)
  group_ = group

  local options_ = options.get_options()
  local title = string.format(options_.title_fmt, contexts.get_title(group_))
  opts_ = vim.tbl_deep_extend("force", options_.opts, opts or {}, { winopts = { title = title } })
end

---Get the currently set group name and picker options
---@return string, table
function M.get()
  return group_, opts_
end

---Get saved resume data from fzf-lua
function M.get_resume_data()
  return resume_data
end

return M
