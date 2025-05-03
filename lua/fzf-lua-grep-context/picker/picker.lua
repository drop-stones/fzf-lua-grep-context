-- Entry point to run the grep-context picker for a given group
local options = require("fzf-lua-grep-context.picker.options")
local state = require("fzf-lua-grep-context.picker.state")
local ui = require("fzf-lua-grep-context.picker.ui")

---Run the grep-context picker for a specific group
---@param group? string
local function picker(group)
  group = group or options.default_group or "default"
  state.init(group)
  ui.open(group)
end

return picker
