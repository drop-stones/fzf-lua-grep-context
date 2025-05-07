-- Handles `exit` key press by restoring the previous picker state
local layout = require("fzf-lua-grep-context.picker.ui.layout")
local state = require("fzf-lua-grep-context.picker.state")
local util = require("fzf-lua-grep-context.util")

---Restore the picker with previous query and options on exit
local function exit()
  layout.unmount()

  local fn = state.resume_data.opts.__call_fn
  local opts = state.resume_data.opts.__call_opts

  if opts.__resume_key == "grep" then
    opts.query = state.resume_data.last_query
  else
    opts.query = state.resume_data.last_query
    opts.search = nil -- Clear stale search query
  end

  -- Add `resume = true` to mimic the behavior of `fzf-lua.resume()`.
  -- This prevents double escaping of backslashes (e.g. `\b` -> `\\b`) in the query string by triggering special handling in `fzf.fzf_exec()`.
  opts.resume = true

  fn(opts)

  util.startinsert(500, "fzf")
end

return {
  exit = exit,
}
