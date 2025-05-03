local contexts = require("fzf-lua-grep-context.contexts")
local layout = require("fzf-lua-grep-context.picker.ui.layout")
local render = require("fzf-lua-grep-context.picker.ui.render")
local state = require("fzf-lua-grep-context.picker.ui.state")

---@param group string
local function open(group)
  local entries = contexts.get_entries_by_group(group)
  local seleceted = contexts.get_current_key_set_by_group(group)
  state.init(entries, seleceted)
  layout.init()
  layout.mount()
  render.update()
end

return {
  open = open,
}
