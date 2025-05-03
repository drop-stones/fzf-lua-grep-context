---@param timeout integer
---@param filetype string
local function startinsert(timeout, filetype)
  local elapsed = 0
  local interval = 10
  local timer = vim.uv.new_timer()

  if not timer then
    return
  end

  timer:start(
    0,
    interval,
    vim.schedule_wrap(function()
      elapsed = elapsed + interval
      local bufnr = vim.api.nvim_get_current_buf()
      local ft = vim.bo[bufnr].filetype

      if ft == filetype then
        vim.defer_fn(function()
          if vim.api.nvim_get_mode().mode ~= "i" then
            vim.cmd("startinsert")
          end
        end, 10)
        timer:stop()
      elseif elapsed >= timeout then
        timer:stop()
      end
    end)
  )
end

return startinsert
