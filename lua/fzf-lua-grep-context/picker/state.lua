-- Manages current picker state: group name, title and resume data

---@class PickerState
---@field resume_data table Resume data from fzf-lua
---@field group string Currently selected context group name
---@field title string Picker window title

---@class PickerState
local state = {
  resume_data = {},
  group = "default",
  title = "",
}

function state.init(group)
  state.resume_data = vim.deepcopy(require("fzf-lua.config").__resume_data)
  state.group = group
  state.title =
    string.format(require("fzf-lua-grep-context.picker.options").title_fmt, require("fzf-lua-grep-context.contexts").get_title(group))
end

return state
