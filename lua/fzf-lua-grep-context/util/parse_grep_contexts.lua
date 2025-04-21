local contexts = require("fzf-lua-grep-context.contexts")

---Parse active grep contexts to extract flags and globs
---@param command string
---@return string[], string[]
local function parse_grep_contexts(command)
  local current = contexts.get_current_contexts()
  local globs, flags = {}, {}
  for _, ctxs in pairs(current) do
    for _, ctx in pairs(ctxs) do
      vim.list_extend(flags, ctx.flags or {})
      vim.list_extend(globs, ctx.globs or {})
      if ctx.commands and ctx.commands[command] then
        vim.list_extend(flags, ctx.commands[command].flags or {})
        vim.list_extend(globs, ctx.commands[command].globs or {})
      end
    end
  end
  return flags, globs
end

return parse_grep_contexts
