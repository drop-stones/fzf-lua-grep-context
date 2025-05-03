-- Handles plugin configuration and context initialization
local contexts = require("fzf-lua-grep-context.contexts")
local picker_ = require("fzf-lua-grep-context.picker")
local util = require("fzf-lua-grep-context.util")

---@alias ContextGroups table<string, ContextGroup>
---@alias ContextEntries table<string, GrepContext>

---@class FzfLuaGrepContextOptions
---@field contexts? ContextGroups | ContextGroup
---@field picker? PickerOptions

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
---@field default_group? string
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

  -- Initialize all available context groups
  contexts.initialize_contexts(opts.contexts)

  -- Initialize current selection as empty at startup
  contexts.initialize_current_contexts({})

  -- Apply user-defined picker options
  picker_.initialize_options(opts.picker)
  picker_.initialize_selected_options(opts.selected)
end

return M
