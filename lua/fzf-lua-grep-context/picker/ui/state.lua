---@class UIState
---@field items ContextEntries
---@field selected table<string, boolean>
---@field selected_initial table<string, boolean>
---@field filtered FilteredEntry[]
---@field query string
---@field cursor integer

---@class UIState
local state = {
  items = {},
  selected = {},
  selected_initial = {},
  query = "",
  filtered = {},
  display_map = {},
  cursor = 1,
}

---@param items ContextEntries
---@param selected table<string, boolean>
function state.init(items, selected)
  state.items = items or {}
  state.selected = selected or {}
  state.selected_initial = vim.deepcopy(state.selected)
  state.query = ""
end

return state
