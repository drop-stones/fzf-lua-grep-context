-- Handles toggle logic when entries are selected in the picker
local contexts = require("fzf-lua-grep-context.contexts")
local entries = require("fzf-lua-grep-context.picker.entries")
local fzf_exec = require("fzf-lua-grep-context.picker.fzf_exec")

---Toggles the selected entries and reopens the picker
---@param selected string[]
local function on_select(selected)
  local group, _ = require("fzf-lua-grep-context.picker.active").get()
  local entries_ = contexts.get_entries_by_group(group)
  local current = contexts.get_current_entries_by_group(group)

  for _, content in ipairs(selected) do
    local label = entries.normalize_entry(content)
    local key = entries.get_key_by_label(label)
    if current[key] == nil then
      current[key] = entries_[key]
    else
      current[key] = nil
    end
  end

  contexts.set_current_entries_by_group(group, current)

  fzf_exec(true)
end

return on_select
