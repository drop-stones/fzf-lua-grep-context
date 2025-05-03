-- Sets up picker state and open picker window
local options = require("fzf-lua-grep-context.picker.options")
local state = require("fzf-lua-grep-context.picker.state")
local ui = require("fzf-lua-grep-context.picker.ui")

---Run the grep-context picker for a specific group
---@param group? string
local function picker(group)
  if group == nil then
    group = options.default_group or "default"
  end
  state.init(group)
  ui.open(group)
end

return picker
