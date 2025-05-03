---@param tbl table
---@return boolean
local function is_list(tbl)
  if type(tbl) ~= "table" then
    return false
  elseif tbl[1] == nil then
    return false
  else
    return true
  end
end

local function is_table(tbl)
  return type(tbl) == "table" and (not is_list(tbl))
end

---Recursively merges values from `src` into `dst`, modifying `dst` in-place
---@param dst table
---@param src table
local function deep_extend_inplace(dst, src)
  for key, value in pairs(src) do
    if is_table(value) and is_table(dst[key]) then
      deep_extend_inplace(dst[key], value)
    else
      dst[key] = value
    end
  end
end

return deep_extend_inplace
