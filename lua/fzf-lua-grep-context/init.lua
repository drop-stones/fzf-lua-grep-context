-- Main entry point for fzf-lua-grep-context plugin
local config = require("fzf-lua-grep-context.config")
local picker = require("fzf-lua-grep-context.picker")

local M = {}

---Setup the plugin with the given user options
---@param opts? FzfLuaGrepContextOptions
function M.setup(opts)
  opts = opts or {}
  config.setup(opts)
end

-- Expose the main picker function for launching the UI
M.picker = picker.picker

return M
