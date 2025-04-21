-- Executes the FZF picker with current context entries
local active = require("fzf-lua-grep-context.picker.active")
local entries = require("fzf-lua-grep-context.picker.entries")
local fzf_lua = require("fzf-lua")

---Run fzf-lua picker using current group and options
---@param from_picker boolean
local function fzf_exec(from_picker)
  local group, opts = active.get()
  local contents = entries.prepare_contents(group)
  opts = vim.tbl_deep_extend("force", opts, { query = (from_picker and fzf_lua.get_last_query()) or "" })
  fzf_lua.fzf_exec(contents, opts)
end

return fzf_exec
