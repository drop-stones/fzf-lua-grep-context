-- Transforms a ripgrep command by injecting parsed flags and glob patterns
local util = require("fzf-lua-grep-context.util")

---Converts glob patterns into ripgrep-compatible command-line args
---@param globs string[]
---@param glob_flag string
---@return string[]
local function process_globs(globs, glob_flag)
  local result = {}
  for _, glob in ipairs(globs) do
    table.insert(result, glob_flag)
    table.insert(result, util.shellescape(glob))
  end
  return result
end

---Injects grep-context flags and globs into a ripgrep command
---@param query string
---@param cmd string?
---@param glob_separator string
---@param glob_flag string
---@return string?, string?
local function fn_transform_cmd(query, cmd, glob_separator, glob_flag)
  if not cmd or query == "<query>" then
    return
  end

  local flags, globs = util.parse_grep_contexts("rg")
  local search_query, rg_globs = util.parse_grep_query(query, glob_separator)
  globs = process_globs(vim.list_extend(globs, rg_globs), glob_flag)

  -- Remove raw `-e` from the base command and inject the search pattern safely
  local new_cmd = util.table_concat({ cmd:gsub("-e", ""), flags, globs, "-e", util.shellescape(search_query) }, " ")
  return new_cmd, search_query
end

return fn_transform_cmd
