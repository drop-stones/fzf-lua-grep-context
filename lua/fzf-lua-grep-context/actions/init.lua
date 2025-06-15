-- Load and flatten all picker action modules into a single table
local cursor = require("fzf-lua-grep-context.actions.cursor")
local exit = require("fzf-lua-grep-context.actions.exit")
local select = require("fzf-lua-grep-context.actions.select")

return {
  move_down = cursor.move_down,
  move_up = cursor.move_up,
  move_top = cursor.move_top,
  move_bottom = cursor.move_bottom,
  half_page_up = cursor.half_page_up,
  half_page_down = cursor.half_page_down,
  exit = exit.exit,
  toggle_select = select.toggle_select,
  confirm = select.confirm,
}
