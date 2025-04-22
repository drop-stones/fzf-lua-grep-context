---@class NeovimVersion
---@field major integer
---@field minor integer
---@field patch integer

---Checks if the current Neovim version is greater or equal to the given version.
---@param required_version NeovimVersion
local function check_nvim_version(required_version)
  local version = vim.version()
  local nvim_version = string.format("%d.%d.%d", version.major, version.minor, version.patch)

  if
    version.major > required_version.major
    or (version.major == required_version.major and version.minor > required_version.minor)
    or (version.major == required_version.major and version.minor == required_version.minor and version.patch >= required_version.patch)
  then
    vim.health.ok("Neovim version: " .. nvim_version)
  else
    vim.health.warn("Neovim version is outdated: " .. nvim_version .. " (0.10+ recommended)")
  end
end

---Checks if a plugin is installed and reports its status.
---@param plugin_name string
---@param require_name string
---@param is_required boolean
local function check_plugin(plugin_name, require_name, is_required)
  local ok, _ = pcall(require, require_name)
  if ok then
    vim.health.ok(plugin_name .. " is installed")
  else
    if is_required then
      vim.health.error(plugin_name .. " is not installed (required)")
    else
      vim.health.warn(plugin_name .. " is not installed (optional)")
    end
  end
end

---Return true if the value is a table
---@return boolean
local function is_table(v)
  return type(v) == "table"
end

---Return true if the value is a string
---@return boolean
local function is_string(v)
  return type(v) == "string"
end

---Validate a single GrepContext and return whether it has any problems
---@param ctx GrepContext
---@param name string
---@return boolean
local function check_grep_context(ctx, name)
  local has_problem = false
  if not is_string(ctx.label) then
    vim.health.warn(string.format("Context '%s' is missing a valid 'label'", name))
    has_problem = true
  end
  if ctx.icon and not is_string(ctx.icon) then
    vim.health.warn(string.format("Context '%s' has non-string 'icon'", name))
    has_problem = true
  end
  if ctx.filetype and not is_string(ctx.filetype) then
    vim.health.warn(string.format("Context '%s' has non-string 'filetype'", name))
    has_problem = true
  end
  if ctx.icon and ctx.filetype then
    vim.health.warn(string.format("Context '%s' defines both 'icon' and 'filetype'; 'icon' will take precedence", name))
    has_problem = true
  end
  if ctx.flags and not is_table(ctx.flags) then
    vim.health.warn(string.format("Context '%s' has non-table 'flags'", name))
    has_problem = true
  end
  if ctx.globs and not is_table(ctx.globs) then
    vim.health.warn(string.format("Context '%s' has non-table 'globs'", name))
    has_problem = true
  end
  if ctx.commands then
    if not is_table(ctx.commands) then
      vim.health.warn(string.format("Context '%s' has non-table 'commands'", name))
      has_problem = true
    else
      for cmd_name, cmd in pairs(ctx.commands) do
        if cmd.flags and not is_table(cmd.flags) then
          vim.health.warn(string.format("Command '%s' in context '%s' has non-table 'flags'", cmd_name, name))
          has_problem = true
        end
        if cmd.globs and not is_table(cmd.globs) then
          vim.health.warn(string.format("Command '%s' in context '%s' has non-table 'globs'", cmd_name, name))
          has_problem = true
        end
      end
    end
  end
  return has_problem
end

---Validate the 'contexts' option structure and report issues
---@param contexts ContextGroups
local function check_contexts(contexts)
  if not contexts then
    vim.health.info("'contexts' not defined (optional)")
    return
  end

  local has_problem = false
  if not is_table(contexts) then
    vim.health.error("'contexts' must be a table")
    has_problem = true
  else
    for group_name, group in pairs(contexts) do
      if not is_string(group.title) then
        vim.health.warn(string.format("Group '%s' is missing a valid 'title'", group_name))
        has_problem = true
      end
      if not is_table(group.entries) then
        vim.health.error(string.format("Group '%s' is missing 'entries' table", group_name))
        has_problem = true
      else
        for entry_name, ctx in pairs(group.entries) do
          has_problem = check_grep_context(ctx, string.format("%s:%s", group_name, entry_name)) or has_problem
        end
      end
    end
  end

  if not has_problem then
    vim.health.ok("'contexts' is valid")
  end
end

---Validate the 'picker' option structure and report issues
---@param picker PickerOptions
local function check_picker(picker)
  if not picker then
    vim.health.info("'picker' not defined (optional)")
    return
  end

  local has_problem = false
  if not is_table(picker) then
    vim.health.error("'picker' must be a table")
    has_problem = true
  else
    if picker.title_fmt and not is_string(picker.title_fmt) then
      vim.health.warn("'picker.title_fmt' should be a string")
      has_problem = true
    end
    if picker.opts and not is_table(picker.opts) then
      vim.health.warn("'picker.opts' should be a table")
      has_problem = true
    end
  end

  if not has_problem then
    vim.health.ok("'picker' is valid")
  end
end

---Validate the 'selected' option structure and report issues
---@param selected SelectedOptions
local function check_selected(selected)
  if not selected then
    vim.health.info("'selected' not defined (optional)")
    return
  end

  local has_problem = false
  if not is_table(selected) then
    vim.health.error("'selected' must be a table")
    has_problem = true
  else
    if not is_string(selected.rgb) then
      vim.health.warn("'selected.rgb' should be a string")
      has_problem = true
    end
    if not is_string(selected.icon) then
      vim.health.warn("'selected.icon' should be a string")
      has_problem = true
    end
  end

  if not has_problem then
    vim.health.ok("'selected' is valid")
  end
end

return {
  check = function()
    vim.health.start("fzf-lua-grep-context")

    check_nvim_version({ major = 0, minor = 10, patch = 0 })
    check_plugin("fzf-lua", "fzf-lua", true)

    local opts = require("fzf-lua-grep-context.config").options
    check_contexts(opts.contexts)
    check_picker(opts.picker)
    check_selected(opts.selected)
  end,
}
