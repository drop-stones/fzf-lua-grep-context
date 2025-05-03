-- Load and flatten all picker action modules into a single table

local M = {}

for _, module in ipairs({
  "fzf-lua-grep-context.actions.cursor",
  "fzf-lua-grep-context.actions.select",
  "fzf-lua-grep-context.actions.exit",
}) do
  local mod = require(module)
  for name, func in pairs(mod) do
    M[name] = func
  end
end

return M
