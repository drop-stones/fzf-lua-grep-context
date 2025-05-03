-- Handles entry selection toggling and confirmation
local contexts = require("fzf-lua-grep-context.contexts")
local exit = require("fzf-lua-grep-context.actions.exit").exit
local cursor = require("fzf-lua-grep-context.actions.cursor")
local render = require("fzf-lua-grep-context.picker.ui.render")
local state = require("fzf-lua-grep-context.picker.ui.state")

---Toggles the currently highlighted entry
local function toggle()
  local entry = state.filtered[state.cursor]
  if not entry then
    return
  end
  state.selected[entry.key] = not (state.selected[entry.key] or false)
end

local M = {}

---Toggles current entry and moves cursor down
function M.toggle_select()
  toggle()
  cursor.move_down()
  render.update()
end

---Confirm selected entries and set active contexts
function M.confirm()
  local results = {}

  if state.unchanged() then
    toggle()
  end

  for item, ok in pairs(state.selected) do
    if ok then
      table.insert(results, item)
    end
  end

  local group = require("fzf-lua-grep-context.picker").state.group
  local entries = contexts.get_entries_by_group(group)
  local current = {}
  for _, key in ipairs(results) do
    current[key] = entries[key]
  end

  contexts.set_current_entries_by_group(group, current)

  exit()
end

return M
