-- Transforms a git-grep command by injecting parsed flags and pathspecs
local options = require("fzf-lua-grep-context.transform.options")
local util = require("fzf-lua-grep-context.util")

---Converts glob patterns into git-compatible pathspecs (handles negation)
---@param globs string[]
---@return string[]
local function process_pathspecs(globs)
  local pathspecs = {}
  for _, pathspec in ipairs(globs) do
    if pathspec:sub(1, 1) == "!" then
      -- Convert '!pattern' to git's exclude pathspec
      table.insert(pathspecs, util.shellescape(":(exclude)" .. pathspec:sub(2)))
    else
      -- Wrap regular pathspec in single quotes
      table.insert(pathspecs, util.shellescape(pathspec))
    end
  end
  return pathspecs
end

---Injects grep-context flags and pathspecs into a git-grep command
---@param query string
---@param cmd string?
---@return string?, string?
local function fn_transform_cmd(query, cmd)
  if cmd == nil or query == "<query>" then
    return
  end

  local glob_separator = options.glob_separator()
  local flags, globs = util.parse_grep_contexts("git_grep")
  local search_query, git_globs = util.parse_grep_query(query, glob_separator)
  local pathspecs = process_pathspecs(vim.list_extend(globs, git_globs))

  -- Compose git grep command with optional "--" before pathspecs
  local new_cmd = util.table_concat({ cmd, flags, util.shellescape(search_query), (#pathspecs > 0 and "--" or ""), pathspecs }, " ")
  return new_cmd, search_query
end

return fn_transform_cmd
