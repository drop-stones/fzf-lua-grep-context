-- Handles <Esc> key press by restoring the previous picker state
local active = require("fzf-lua-grep-context.picker.active")

---Re-runs the original picker with the last query and options
local function on_esc()
  local resume_data = active.get_resume_data()
  local fn = resume_data.opts.__call_fn
  local opts = resume_data.opts.__call_opts

  if opts.__resume_key == "grep" then
    opts.query = resume_data.last_query
  else
    opts.query = resume_data.last_query
    opts.search = nil
  end

  fn(opts)
end

return on_esc
