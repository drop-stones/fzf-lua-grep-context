-- Sets up picker state and triggers FZF execution
local active = require("fzf-lua-grep-context.picker.active")
local fzf_exec = require("fzf-lua-grep-context.picker.fzf_exec")

---Run the grep-context picker for a specific group
---@param group string
---@param opts? table
local function picker(group, opts)
  active.set(group, opts)
  fzf_exec(false)
end

return picker
