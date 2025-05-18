-- Handles plugin configuration and context initialization
local contexts = require("fzf-lua-grep-context.contexts")
local picker = require("fzf-lua-grep-context.picker")
local transform = require("fzf-lua-grep-context.transform")
local util = require("fzf-lua-grep-context.util")

---@alias ContextGroups table<string, ContextGroup>
---@alias ContextEntries table<string, GrepContext>

---User plugin options passed to setup()
---@class FzfLuaGrepContextOptions
---@field contexts? ContextGroups | ContextGroup
---@field picker? PickerOptions

---Represents a group of grep context entries shown in the checklist
---@class ContextGroup
---@field title string
---@field entries ContextEntries

---Describe a single grep context item selectable in the checklist
---@class GrepContext
---@field label string
---@field icon? { [1]: string, [2]: string }
---@field filetype? string
---@field extension? string
---@field flags? string[]
---@field globs? string[]
---@field commands? table<string, CommandContext>

---Optional context overrides for a specific grep command
---@class CommandContext
---@field flags? string[]
---@field globs? string[]

---User-defined options for customizing the checklist picker UI
---@class PickerOptions
---@field default_group? string
---@field title_fmt? string
---@field keymaps? PickerKeymapEntry[]
---@field checkbox? CheckboxConfig

---Describe a single keymap entry to use within the picker
---@class PickerKeymapEntry
---@field [1] string
---@field [2] function
---@field mode? string|string[]

---Checkbox display options used in the picker UI
---@class CheckboxConfig
---@field mark? string
---@field hl? table

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

  -- Initialize options for fn_transform_cmd()
  transform.options.init()

  -- Apply user-defined picker options
  picker.options.init(opts.picker)
end

return M
