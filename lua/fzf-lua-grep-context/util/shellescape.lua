---Escape a shell argument, with Windows quoting support
---@param shell_arg string
---@return string
local function shellescape(shell_arg)
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    return string.format('^"%s^"', shell_arg)
  else
    return string.format("'%s'", shell_arg)
  end
end

return shellescape
