-- Stores and filter the current UI state and selection

---Represent the full UI state, including selection and filtering info
---@class UIState
---@field items ContextEntries All available items to display
---@field selected table<string, boolean> Currently selected keys
---@field selected_initial table<string, boolean> Initial selection snapshot for diffing
---@field filtered FilteredEntry[] Items currently shown after filtering
---@field query string Current search query
---@field cursor integer Current highlighted row in filtered list

---Represent a filtered list entry with match metadata
---@class FilteredEntry
---@field key string Key of the entry (used in state lookups)
---@field label string Display label
---@field positions integer[] Matched character positions in label

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

---Filter items based on fuzzy score from input query
---@param query? string
function state.filter(query)
  state.query = query or ""
  state.cursor = 1

  local results = {}
  for key, item in pairs(state.items) do
    local score, positions
    if state.query == "" then
      score, positions = 0, {}
    else
      score, positions = require("fzf-lua-grep-context.util").fuzzy_match(item.label, state.query)
      if score == 0 then
        goto continue
      end
    end

    table.insert(results, {
      key = key,
      score = score,
      selected = state.selected_initial[key] and 1 or 0,
      label = item.label,
      positions = positions,
    })

    ::continue::
  end

  -- Sort by score, then selection, then label
  table.sort(results, function(a, b)
    if a.score ~= b.score then
      return a.score > b.score
    elseif a.selected ~= b.selected then
      return a.selected > b.selected
    else
      return a.label < b.label
    end
  end)

  -- Store sorted filtered results
  state.filtered = {}
  for _, entry in ipairs(results) do
    table.insert(state.filtered, {
      key = entry.key,
      label = entry.label,
      positions = entry.positions,
    })
  end
end

---Initialize internal state
---@param items ContextEntries
---@param selected table<string, boolean>
function state.init(items, selected)
  state.items = items or {}
  state.selected = selected or {}
  state.selected_initial = vim.deepcopy(state.selected)
  state.query = ""

  state.filter()
end

---Check if item toggled from initial selection
---@return boolean
function state.toggled(key)
  return (state.selected_initial[key] or false) ~= (state.selected[key] or false)
end

---Return true if selection has not changed
---@return boolean
function state.unchanged()
  for key, _ in pairs(state.selected) do
    if state.toggled(key) then
      return false
    end
  end
  return true
end

return state
