-- Handles plugin configuration and context initialization
local util = require("fzf-lua-grep-context.util")

---@alias ContextGroups table<string, ContextGroup>
---@alias ContextEntries table<string, GrepContext>

---@class FzfLuaGrepContextOptions
---@field contexts? ContextGroups
---@field picker? PickerOptions
---@field selected? SelectedOptions

---@class ContextGroup
---@field title string
---@field entries ContextEntries

---@class GrepContext
---@field label string
---@field icon? string
---@field filetype? string
---@field flags? string[]
---@field globs? string[]
---@field commands? table<string, CommandContext>

---@class CommandContext
---@field flags? string[]
---@field globs? string[]

---@class PickerOptions
---@field title_fmt? string
---@field opts? table

---@class SelectedOptions
---@field rgb string
---@field icon string

local M = {}

---User options
---@type FzfLuaGrepContextOptions
M.options = {}

---Configures the plugin and initialize context state
---@param opts FzfLuaGrepContextOptions
function M.setup(opts)
  -- Save user options for health check
  M.options = opts

  -- Set plugin root path for access from headless child processes
  vim.env.FZF_LUA_GREP_CONTEXT = util.get_plugin_root()
end

return M
