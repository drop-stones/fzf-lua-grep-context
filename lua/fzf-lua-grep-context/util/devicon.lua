-- Return a function to get filetype icons with ANSI highlight

---Return an icon getter using nvim-web-devicons if available
---@return function?
local function get_from_web_devicons()
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    return nil
  end

  return function(filetype)
    local icon, hl = devicons.get_icon_by_filetype(filetype)
    if not icon then
      icon, hl = devicons.get_icon(nil, filetype)
    end
    return icon, hl
  end
end

---Return an icon getter using mini.icons if available
---@return function?
local function get_from_mini_icons()
  local ok, mini_icons = pcall(require, "mini.icons")
  if not ok then
    return nil
  end

  return function(filetype)
    local icon, hl = devicons.get_icon_by_filetype(filetype)
    if not icon then
      icon, hl = devicons.get_icons_by_extension(filetype)
    end
    return icon, hl
  end
end

---Choose the available icon provider or fallback to empty string
---@return fun(string): string, string
local function setup_provider()
  -- stylua: ignore
  -- return get_from_web_devicons() or get_from_mini_icons() or function(_) return "", "Normal" end -- fallback: no icon
  return get_from_web_devicons() or function(_) return "", "Normal" end -- fallback: no icon
end

return setup_provider()
