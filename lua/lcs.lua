---Calculates the Longest Common Subsequence (LCS) of two strings.
---@param left string The first string.
---@param right string The second string.
---@return string The longest common subsequence.
local function lcs(left, right)
  local len1 = #left
  local len2 = #right

  -- Prepare the table
  local dp = {}
  for i = 0, len1 do
    dp[i] = {}
    for j = 0, len2 do
      dp[i][j] = 0
    end
  end

  -- Collect the matrix
  for i = 1, len1 do
    for j = 1, len2 do
      if string.sub(left, i, i) == string.sub(right, j, j) then
        dp[i][j] = dp[i - 1][j - 1] + 1
      else
        dp[i][j] = math.max(dp[i - 1][j], dp[i][j - 1])
      end
    end
  end

  -- Backtrack the path
  local path = {}
  local i = len1
  local j = len2
  while i > 0 and j > 0 do
    if string.sub(left, i, i) == string.sub(right, j, j) then
      table.insert(path, string.sub(left, i, i))
      i = i - 1
      j = j - 1
    elseif dp[i - 1][j] > dp[i][j - 1] then
      i = i - 1
    else
      j = j - 1
    end
  end

  -- The path is constructed in reverse, so it needs to be reversed.
  local reversed_path = {}
  for k = #path, 1, -1 do
    table.insert(reversed_path, path[k])
  end

  return table.concat(reversed_path, '')
end

return {
  lcs = lcs
}
