---@param text string
---@param query string
---@return integer, integer[]
local function fuzzy_match(text, query)
  local t_i, q_i = 1, 1
  local positions = {}

  while t_i <= #text and q_i <= #query do
    if text:sub(t_i, t_i):lower() == query:sub(q_i, q_i):lower() then
      table.insert(positions, t_i - 1) -- 0-based position
      q_i = q_i + 1
    end
    t_i = t_i + 1
  end

  if #positions < #query then
    return 0, {} -- not matched
  end

  local score = 0

  for _, pos in ipairs(positions) do
    -- Normalize by text length: earlier match = higher score
    score = score + (1 - (pos / #text))
  end

  for i = 2, #positions do
    if positions[i] == positions[i - 1] + 1 then
      score = score + 1 -- consecutive match bonus
    end
  end

  if positions[1] == 0 then
    score = score + 2 -- starts-with bonus
  end

  return score, positions
end

return fuzzy_match
