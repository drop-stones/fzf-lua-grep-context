-- Entry point for launching the grep-context UI for a given context group
local contexts = require("fzf-lua-grep-context.contexts")
local layout = require("fzf-lua-grep-context.picker.ui.layout")
local render = require("fzf-lua-grep-context.picker.ui.render")
local state = require("fzf-lua-grep-context.picker.ui.state")

---Open the grep-context UI for a given group
---@param group string
local function open(group)
  -- Fetch and initialize context entries and selections
  local entries = contexts.get_entries_by_group(group)
  local seleceted = contexts.get_current_key_set_by_group(group)

  -- Initialize and mount layout, then render list
  state.init(entries, seleceted)
  layout.init()
  layout.mount()
  render.update()
end

return {
  open = open,
}
