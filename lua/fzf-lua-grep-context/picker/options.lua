-- Default picker options and key mappings
local actions = require("fzf-lua-grep-context.actions")
local util = require("fzf-lua-grep-context.util")

---@class PickerOptions
local options = {
  default_group = "default",
  title_fmt = " Grep Context: %s ",
  keymaps = {
    { "<Down>", actions.move_down, mode = { "n", "i" } },
    { "<Up>", actions.move_up, mode = { "n", "i" } },
    { "<C-j>", actions.move_down, mode = { "n", "i" } },
    { "<C-k>", actions.move_up, mode = { "n", "i" } },
    { "<C-d>", actions.half_page_down, mode = { "n", "i" } },
    { "<C-u>", actions.half_page_up, mode = { "n", "i" } },
    { "<Tab>", actions.toggle_select, mode = { "n", "i" } },
    { "<CR>", actions.confirm, mode = { "n", "i" } },
    { "<Esc>", actions.exit, mode = { "n", "i" } },
    { "j", actions.move_down, mode = "n" },
    { "k", actions.move_up, mode = "n" },
    { "gg", actions.move_top, mode = "n" },
    { "G", actions.move_bottom, mode = "n" },
    { "q", actions.exit, mode = "n" },
  },
}

---Initialize default and user-defined picker options
---@param opts? PickerOptions
function options.init(opts)
  -- Merge user options into default picker options
  util.deep_extend_inplace(options, opts or {})
end

return options
