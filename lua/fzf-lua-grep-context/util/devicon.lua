---Return filetype/extension icons with ANSI highlight
---@param query { filetype: string?, extension: string? }
---@return string?, string?
local function devicon(query)
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    return nil, nil
  end

  local icon, hl
  if query.filetype then
    icon, hl = devicons.get_icon_by_filetype(query.filetype)
  end
  if not icon and query.extension then
    icon, hl = devicons.get_icon(nil, query.extension)
  end
  return icon, hl
end

return devicon
