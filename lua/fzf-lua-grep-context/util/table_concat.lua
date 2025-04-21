---Recursively flatten a nested table into a string list
---@param output string[]
---@param tbl table
local function flatten(output, tbl)
  for _, value in ipairs(tbl) do
    if type(value) == "table" then
      flatten(output, value)
    elseif type(value) == "string" then
      table.insert(output, value)
    end
  end
end

---Concatenate a (possibly nested) string table with a separator
---@param tbl table
---@param separator string
---@return string
local function table_concat(tbl, separator)
  local result = {}
  flatten(result, tbl)
  return table.concat(result, separator)
end

return table_concat
