-- Render list entries and highlight in the list popup buffer
local layout = require("fzf-lua-grep-context.picker.ui.layout")
local namespace = require("fzf-lua-grep-context.namespace")
local state = require("fzf-lua-grep-context.picker.ui.state")
local util = require("fzf-lua-grep-context.util")

---Pad line with white spaces to match popup width
local function pad_to_width(str)
  local win_width = vim.api.nvim_win_get_width(layout.winid)
  local pad = math.max(win_width - vim.fn.strdisplaywidth(str, 0))
  return str .. string.rep(" ", pad)
end

local M = {}

---Update the rendered list and highlight matches
function M.update()
  vim.schedule(function()
    local lines = {}
    local highlights = {}

    -- Build each line with icon, label, checkmark
    for _, entry in ipairs(state.filtered) do
      local cursor = "  "
      local mark = require("fzf-lua-grep-context.picker.options").checkbox.mark ---@type string
      local check = (state.selected[entry.key] and "[" .. mark .. "]") or ("[" .. string.rep(" ", vim.fn.strdisplaywidth(mark)) .. "]")

      -- Get icon and highlight group
      local icon, hl
      if state.items[entry.key].icon then
        icon, hl = state.items[entry.key].icon[1], state.items[entry.key].icon[2]
      elseif state.items[entry.key].filetype or state.items[entry.key].extension then
        icon, hl = util.devicon({ filetype = state.items[entry.key].filetype, extension = state.items[entry.key].extension })
      end
      icon = icon or " "

      -- Format line and collect highlights
      local line = string.format("%s%s %s %s", cursor, check, icon, entry.label)
      line = pad_to_width(line)
      table.insert(lines, line)

      local check_start = #cursor
      local check_end = check_start + #check
      table.insert(highlights, {
        hl_group = "FzfLuaGrepContextCheckMark",
        line = #lines - 1, -- 0-indexed
        col_start = check_start + 1,
        col_end = check_start + #check - 1,
      })

      local icon_start = check_end + 1
      local icon_end = icon_start + #icon
      table.insert(highlights, {
        hl_group = hl,
        line = #lines - 1, -- 0-indexed
        col_start = icon_start,
        col_end = icon_end,
      })

      -- Highlight match positions
      local label_start = icon_end + 1
      for _, col in ipairs(entry.positions) do
        table.insert(highlights, {
          hl_group = "FzfLuaFzfMatch",
          line = #lines - 1, -- 0-indexed
          col_start = label_start + col,
          col_end = label_start + col + 1,
        })
      end
    end

    -- Apply rendered lines and highlights
    vim.api.nvim_buf_set_lines(layout.bufnr, 0, -1, false, lines)
    for _, hl in ipairs(highlights) do
      vim.api.nvim_buf_set_extmark(layout.bufnr, namespace, hl.line, hl.col_start, {
        end_col = hl.col_end,
        hl_group = hl.hl_group,
      })
    end

    -- Set cursor and pointer visuals
    state.cursor = math.max(math.min(state.cursor, #state.filtered), 1)
    vim.api.nvim_win_set_cursor(layout.winid, { state.cursor, 0 })

    -- Highlight current cursor lines
    vim.api.nvim_buf_set_extmark(layout.bufnr, namespace, state.cursor - 1, 0, {
      virt_text = { { "▌", "FzfLuaFzfPointer" } },
      virt_text_pos = "overlay",
      end_row = state.cursor,
      hl_group = "FzfLuaCursorLine",
    })

    -- Mark toggled items
    for line, key in ipairs(state.filtered) do
      if state.toggled(key) then
        vim.api.nvim_buf_set_extmark(layout.bufnr, namespace, line - 1, 1, {
          end_col = 2,
          virt_text = { { "┃", "FzfLuaFzfPointer" } },
          virt_text_pos = "overlay",
        })
      end
    end
  end)
end

return M
