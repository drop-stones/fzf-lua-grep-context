---Split grep query and globs using a custom separator
---@param query string
---@param glob_separator string
---@return string, string[]
local function parse_grep_query(query, glob_separator)
  if not query or not query:find(glob_separator) then
    return query, {}
  end

  -- Extract the base query and the space-separated globs
  local globs = {}
  local search_query, glob_str = query:match("(.-)" .. glob_separator .. "(.*)")
  for glob in glob_str:gmatch("%S+") do
    table.insert(globs, glob)
  end
  return search_query, globs
end

return parse_grep_query
