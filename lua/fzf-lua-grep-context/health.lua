-- Healthcheck for fzf-lua-grep-context to validate environment and configuration

---Represent a semantic version of Neovim
---@class NeovimVersion
---@field major integer
---@field minor integer
---@field patch integer

---Ensure minimum required Neovim version is met
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

---Verify that a plugin dependency is installed and report its status
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

---Type utility: check if value is a table
---@return boolean
local function is_table(v)
  return type(v) == "table"
end

---Type utility: check if a value is a string
---@return boolean
local function is_string(v)
  return type(v) == "string"
end

---Type utility: check if value is an array of strings (optionally of fixed length)
---@param len? integer
---@return boolean
local function is_string_array(v, len)
  if not is_table(v) then
    return false
  end
  if len and #v ~= len then
    return false
  end
  for _, e in ipairs(v) do
    if not is_string(e) then
      return false
    end
  end
  return true
end

---Type utility: check if value is a function
---@return boolean
local function is_function(v)
  return type(v) == "function"
end

---Validate a single GrepContext and report any field issues
---@param ctx GrepContext
---@param name string
---@return boolean
local function check_grep_context(ctx, name)
  local has_problem = false
  if not is_string(ctx.label) then
    vim.health.warn(string.format("Context '%s' is missing a valid 'label'", name))
    has_problem = true
  end
  if ctx.icon and not is_string_array(ctx.icon, 2) then
    vim.health.warn(string.format("Context '%s' has invalid 'icon' (expected string[2])", name))
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
    if picker.default_group and not is_string(picker.default_group) then
      vim.health.warn("'picker.default_group' should be a string")
      has_problem = true
    end
    if picker.title_fmt and not is_string(picker.title_fmt) then
      vim.health.warn("'picker.title_fmt' should be a string")
      has_problem = true
    end
    if picker.keymaps then
      if not is_table(picker.keymaps) then
        vim.health.warn("'picker.opts' should be a table")
        has_problem = true
      else
        for idx, entry in ipairs(picker.keymaps) do
          if not is_string(entry[1]) then
            vim.health.warn(string.format("'picker.keymaps[%d]': [1] should be a string", idx))
            has_problem = true
          end
          if not is_function(entry[2]) then
            vim.health.warn(string.format("'picker.keymaps[%d]': [2] should be a function", idx))
            has_problem = true
          end
          if entry.mode and not (is_string(entry.mode) or is_string_array(entry.mode)) then
            vim.health.warn(string.format("'picker.keymaps[%d]': mode should be a string or string[]", idx))
            has_problem = true
          end
        end
      end
    end
  end

  if not has_problem then
    vim.health.ok("'picker' is valid")
  end
end

-- Main health entry point for `:checkhealth`
return {
  check = function()
    vim.health.start("fzf-lua-grep-context")

    check_nvim_version({ major = 0, minor = 10, patch = 0 })
    check_plugin("fzf-lua", "fzf-lua", true)
    check_plugin("nui.nvim", "nui.text", true)

    local opts = require("fzf-lua-grep-context.config").options
    check_contexts(opts.contexts)
    check_picker(opts.picker)
  end,
}
