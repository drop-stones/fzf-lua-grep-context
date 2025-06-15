-- Cursor movement actions within the custom picker UI
local layout = require("fzf-lua-grep-context.picker.ui.layout")
local render = require("fzf-lua-grep-context.picker.ui.render")
local state = require("fzf-lua-grep-context.picker.ui.state")

local M = {}

-- Move cursor down by one entry
function M.move_down()
  state.cursor = math.min(state.cursor + 1, #state.filtered)
  render.update()
end

-- Move cursor up by one entry
function M.move_up()
  state.cursor = math.max(state.cursor - 1, 1)
  render.update()
end

-- Move cursor to the top entry
function M.move_top()
  state.cursor = 1
  render.update()
end

-- Move cursor to the bottom entry
function M.move_bottom()
  state.cursor = #state.filtered
  render.update()
end

-- Move cursor up by half a page
function M.half_page_up()
  local win_height = vim.api.nvim_win_get_height(layout.winid)
  local half = math.floor(win_height / 2)
  state.cursor = math.max(1, state.cursor - half)
  render.update()
end

-- Move cursor down by half a page
function M.half_page_down()
  local win_height = vim.api.nvim_win_get_height(layout.winid)
  local half = math.floor(win_height / 2)
  state.cursor = math.max(1, state.cursor + half)
  render.update()
end

return M
