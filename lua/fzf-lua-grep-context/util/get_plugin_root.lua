---Get the root path of the plugin using git
---@return string the root path
local function get_plugin_root_path()
  local path = vim.fs.dirname(debug.getinfo(1, "S").source:sub(2)) -- path to fzf-lua-grep-context/lua/fzf-lua-grep-context/
  local result = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true, cwd = path }):wait()

  if result.code ~= 0 then
    vim.notify("Git command failed in directory: " .. path, vim.log.levels.ERROR)
    error("Unable to determine plugin root path")
  end

  return vim.trim(result.stdout)
end

return get_plugin_root_path
