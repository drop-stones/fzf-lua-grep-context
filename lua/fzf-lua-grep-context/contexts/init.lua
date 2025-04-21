-- Provides access to full and current grep context groups

local M = {}

---@alias CurrentContextGroups table<string, ContextEntries>

---@type ContextGroups
local contexts = {}

---Initialize context groups
---@param ctxs ContextGroups
function M.initialize_contexts(ctxs)
  contexts = ctxs
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
  vim.env.FZF_LUA_GREP_CONTEXTS_CURRENT = vim.json.encode(ctxs)
end

---Update current entries of a group
---@param group string
---@param entries ContextEntries
function M.set_current_entries_by_group(group, entries)
  local new = vim.json.decode(vim.env.FZF_LUA_GREP_CONTEXTS_CURRENT)
  new[group] = entries
  vim.env.FZF_LUA_GREP_CONTEXTS_CURRENT = vim.json.encode(new)
end

---Get current active context groups from env
---@return CurrentContextGroups
function M.get_current_contexts()
  return vim.json.decode(vim.env.FZF_LUA_GREP_CONTEXTS_CURRENT)
end

---Get current entries of a group from env
---@param group string
---@return ContextEntries
function M.get_current_entries_by_group(group)
  local current = vim.json.decode(vim.env.FZF_LUA_GREP_CONTEXTS_CURRENT)
  return current[group] or {}
end

return M
