-- Entry point for grep-context picker actions
return {
  on_select = require("fzf-lua-grep-context.actions.on_select"),
  on_esc = require("fzf-lua-grep-context.actions.on_esc"),
}
