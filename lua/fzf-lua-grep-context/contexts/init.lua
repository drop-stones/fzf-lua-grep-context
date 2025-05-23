-- Provides access to full and current grep context groups

local M = {}

---@alias CurrentContextGroups table<string, ContextEntries>

---@type string
local env_current_contexts = "FZF_LUA_GREP_CONTEXT_CURRENT"
---@type ContextGroups
local contexts = {}

---Check if `ctxs` is ContextGroup
---@param ctxs? ContextGroups | ContextGroup
---@return boolean
local function is_contex_group(ctxs)
  return type(ctxs) == "table" and type(ctxs.title) == "string" and type(ctxs.entries) == "table"
end

---Initialize context groups, merging default filetypes with user-defined groups
---@param ctxs? ContextGroups | ContextGroup
function M.initialize_contexts(ctxs)
  local util = require("fzf-lua-grep-context.util")
  local filetypes_ctx = require("fzf-lua-grep-context.contexts.filetypes")

  -- Filter entries to only those with available devicons
  local entries = {}
  for key, entry in pairs(filetypes_ctx.entries) do
    local icon, _ = util.devicon({ filetype = entry.filetype, extension = entry.extension })
    if icon then
      entries[key] = entry
    end
  end

  -- Assemble the "filetypes" group
  local filetypes = { title = filetypes_ctx.title, entries = entries }

  -- Define default groups with a fallback "default" group
  ---@type ContextGroups
  local default = {
    default = {
      title = "Default",
      entries = {},
    },
    filetypes = filetypes,
  }

  -- Normalize input: wrap single group into a ContextGroups table
  ctxs = ctxs or {}
  if is_contex_group(ctxs) then
    ctxs = { default = ctxs }
  end

  -- Merge default and user-defined context groups
  contexts = vim.tbl_deep_extend("force", default, ctxs)
end

---Get a full context group by its name
---@param group string
---@return ContextGroup
function M.get_context_by_group(group)
  return contexts[group]
end

---Get context entries from a group
---@param group string
---@return ContextEntries
function M.get_entries_by_group(group)
  return contexts[group].entries
end

---Get title of a context group
---@param group string
---@return string
function M.get_title(group)
  return contexts[group].title
end

---Set current active context groups in env variable
---@param ctxs CurrentContextGroups
function M.initialize_current_contexts(ctxs)
  vim.env[env_current_contexts] = vim.json.encode(ctxs)
end

---Update current entries of a group
---@param group string
---@param entries ContextEntries
function M.set_current_entries_by_group(group, entries)
  local new = vim.json.decode(vim.env[env_current_contexts])
  new[group] = entries
  vim.env[env_current_contexts] = vim.json.encode(new)
end

---Get current active context groups from env
---@return CurrentContextGroups
function M.get_current_contexts()
  return vim.json.decode(vim.env[env_current_contexts])
end

---Get current entries of a group from env
---@param group string
---@return ContextEntries
function M.get_current_entries_by_group(group)
  local current = vim.json.decode(vim.env[env_current_contexts])
  return current[group] or {}
end

---Get a current set of entry keys of a group from env
---@param group string
---@return table<string, boolean>
function M.get_current_key_set_by_group(group)
  local current = vim.json.decode(vim.env[env_current_contexts])
  return vim.iter(vim.tbl_keys(current[group] or {})):fold({}, function(acc, val)
    acc[val] = true
    return acc
  end)
end

return M
