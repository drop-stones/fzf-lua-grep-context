-- Border handling for fzf-lua-grep-context
-- Ensure compatibility with nui.nvim by falling back when fzf-lua profile border returns a function

local border = {
  ---Default border style (fallback if fzf-lua provides a function)
  ---@type nui_popup_border_option_style
  style = "rounded",
}

---Initialize the border style (user-configurable).
---@param style nui_popup_border_option_style?
function border.init(style)
  border.style = style or border.style
end

---Resolve fzf-lua border to a nui-compatible border style.
---Note: "none" and "shadow" styles do not support border text.
---@param fzf_lua_border nui_popup_border_option_style | function
---@param text? nui_popup_border_option_text
---@return nui_popup_border_options
function border.resolve(fzf_lua_border, text)
  local options = {} ---@class nui_popup_border_options

  if type(fzf_lua_border) == "string" or type(fzf_lua_border) == "table" then
    options.style = fzf_lua_border
  else
    options.style = border.style
  end

  if not (type(options.style) == "string" and (options.style == "none" or options.style == "shadow")) then
    options.text = text
  end

  return options
end

return border
