---Perform basic fuzzy matching and scoring of query against text
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

  -- Base score: match positions (earlier is better)
  for _, pos in ipairs(positions) do
    score = score + (1 - (pos / #query))
  end

  -- Bonus for consecutive matches
  for i = 2, #positions do
    if positions[i] == positions[i - 1] + 1 then
      score = score + 1.5
    end
  end

  -- Bonus if match starts at beginning
  if positions[1] == 0 then
    score = score + 2
  end

  -- Bonus for density: tighter span means higher density
  local span = positions[#positions] - positions[1] + 1
  local density = #query / span
  score = score + density * 2 -- Weighted for moderate influence

  -- Mild penalty for long candidates relative to query
  score = score - math.log((#text - #query + 1)) * 0.1

  -- Big bonus for exact match
  if text:lower() == query:lower() then
    score = score + 100
  end

  return score, positions
end

return fuzzy_match
