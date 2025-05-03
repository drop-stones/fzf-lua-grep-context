local Input = require("nui.input")
local Layout = require("nui.layout")
local NuiText = require("nui.text")
local Popup = require("nui.popup")
local filetype = require("fzf-lua-grep-context.filetype")
local picker_state = require("fzf-lua-grep-context.picker.state")
local state = require("fzf-lua-grep-context.picker.ui.state")
local util = require("fzf-lua-grep-context.util")

---@type NuiInput
local input_popup
---@type NuiPopup
local list_popup
---@type NuiLayout
local layout

local M = {}

function M.init()
  local winopts = picker_state.resume_data.opts.winopts
  input_popup = Input({
    border = {
      style = winopts.border,
      text = {
        top = picker_state.title,
        top_align = winopts.title_pos,
      },
    },
    win_options = {
      winhighlight = "Normal:FzfLuaNormal,FloatBorder:FzfLuaBorder,FloatTitle:FzfLuaTitle",
    },
  }, {
    prompt = NuiText("> ", "FzfLuaFzfPrompt"),
    default_value = "",
    on_change = function(query)
      state.filter(query)
      require("fzf-lua-grep-context.picker.ui.render").update()
    end,
  })

  list_popup = Popup({
    border = { style = winopts.border },
    win_options = {
      winhighlight = "Normal:FzfLuaNormal,FloatBorder:FzfLuaBorder,FloatTitle:FzfLuaTitle",
    },
  })

  layout = Layout(
    {
      position = {
        row = winopts.row,
        col = winopts.col,
      },
      size = {
        width = winopts.width,
        height = winopts.height,
      },
      zindex = winopts.zindex,
    },
    Layout.Box({
      Layout.Box(input_popup, { size = 3 }),
      Layout.Box(list_popup, { grow = 1 }),
    }, { dir = "col" })
  )
end

function M.mount()
  layout:mount()

  -- window/buffer settings
  M.winid = list_popup.winid
  M.bufnr = list_popup.bufnr
  vim.bo[input_popup.bufnr].filetype = filetype
  vim.bo[list_popup.bufnr].filetype = filetype

  -- keymaps
  local options = require("fzf-lua-grep-context.picker.options")
  for _, map in ipairs(options.keymaps) do
    local key = map[1]
    local action = map[2]
    local modes = type(map.mode) == "table" and map.mode --[[ @as string[] ]]
      or { map.mode or "n" }
    for _, mode in ipairs(modes) do
      input_popup:map(mode, key, action, { noremap = true, silent = true })
    end
  end

  util.startinsert(500, filetype)
end

function M.unmount()
  layout:unmount()
end

return M
