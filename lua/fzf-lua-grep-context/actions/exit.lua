-- Handles <Esc> key press by restoring the previous picker state
local layout = require("fzf-lua-grep-context.picker.ui.layout")
local state = require("fzf-lua-grep-context.picker.state")
local util = require("fzf-lua-grep-context.util")

---Re-runs the original picker with the last query and options
local function exit()
  layout.unmount()

  local fn = state.resume_data.opts.__call_fn
  local opts = state.resume_data.opts.__call_opts

  if opts.__resume_key == "grep" then
    opts.query = state.resume_data.last_query
  else
    opts.query = state.resume_data.last_query
    opts.search = nil
  end

  fn(opts)

  util.startinsert(500, "fzf")
end

return {
  exit = exit,
}
