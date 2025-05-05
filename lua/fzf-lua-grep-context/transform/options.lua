-- Manage persistent glob flag and separator via environment variables for fzf-lua grep context
local M = {}

local env_glob_flag = "FZF_LUA_GREP_CONTEXT_GLOB_FLAG"
local env_glob_separator = "FZF_LUA_GREP_CONTEXT_GLOB_SEPARATOR"

---Initialize and store glob flag and separator from fzf-lua options into environment variables
function M.init()
  local fzf_opts = require("fzf-lua.config").setup_opts
  local fzf_defaults = require("fzf-lua.defaults")
  local glob_flag = (fzf_opts.grep and fzf_opts.grep.glob_flag) or fzf_defaults.defaults.grep.glob_flag
  local glob_separator = (fzf_opts.grep and fzf_opts.grep.glob_separator) or fzf_defaults.defaults.grep.glob_separator
  vim.env[env_glob_flag] = vim.json.encode(glob_flag)
  vim.env[env_glob_separator] = vim.json.encode(glob_separator)
end

---Retrieve the stored glob flag from environment variables
---@return string
function M.glob_flag()
  return vim.json.decode(vim.env[env_glob_flag])
end

---Retrieve the stored glob separator from environment variables
---@return string
function M.glob_separator()
  return vim.json.decode(vim.env[env_glob_separator])
end

return M
