-- Builds and manages fzf entries for grep contexts
local contexts = require("fzf-lua-grep-context.contexts")
local util = require("fzf-lua-grep-context.util")

local M = {}

---@type SelectedOptions
local selected_options = {
  rgb = "#5FAF5F",
  icon = "",
}

---Non-breaking space used as entry separator
---@type string
local nbsp = "\u{2002}"
---Mappings from label to context key
---@type table<string, string>
local label_to_key = {}

---Create a formatted fzf entry from a context
---@param ctx GrepContext
---@param selected boolean
---@return string
local function make_entry(ctx, selected)
  local entry = {}
  table.insert(entry, (selected and require("fzf-lua.utils").ansi_from_rgb(selected_options.rgb, selected_options.icon)) or " ")
  table.insert(entry, ctx.icon or (ctx.filetype and util.devicon(ctx.filetype)) or " ")
  table.insert(entry, ctx.label)
  return table.concat(entry, nbsp)
end

---@param opts? SelectedOptions
function M.initialize_selected_options(opts)
  selected_options = vim.tbl_extend("force", selected_options, opts or {})
end

---Extract label part from a full fzf entry
---@param entry string
---@return string
function M.normalize_entry(entry)
  local parts = vim.split(entry, nbsp)
  return vim.trim(parts[#parts] or "")
end

---Look up context key by its label
---@param label string
---@return string
function M.get_key_by_label(label)
  return label_to_key[label]
end

---Generate fzf entries and update label-to-key mappings
---@param group string
---@return string[]
function M.prepare_contents(group)
  local contents = {} ---@type string[]
  label_to_key = {}
  local entries = contexts.get_entries_by_group(group)
  local current = contexts.get_current_entries_by_group(group)
  for key, ctx in pairs(entries) do
    label_to_key[ctx.label] = key
    table.insert(contents, make_entry(ctx, current[key] ~= nil))
  end
  return contents
end

return M
