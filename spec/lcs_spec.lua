local lcs_module = require('lcs')
local lcs = lcs_module.lcs

describe("Longest Common Subsequence", function()

  it("should find the LCS for two simple strings", function()
    assert.are.equal("ADH", lcs("ABCDGH", "AEDFHR"))
  end)

  it("should find the LCS when there are multiple possibilities", function()
    -- Both "ABD" and "ACD" are valid LCSs. The implementation will produce one of them.
    local result = lcs("AGCAT", "GAC")
    assert.is_true(result == "AC" or result == "GA")
  end)

  it("should return an empty string when one of the strings is empty", function()
    assert.are.equal("", lcs("ABC", ""))
    assert.are.equal("", lcs("", "XYZ"))
  end)

  it("should return an empty string when both strings are empty", function()
    assert.are.equal("", lcs("", ""))
  end)

  it("should return an empty string when there is no common subsequence", function()
    assert.are.equal("", lcs("ABC", "DEF"))
  end)

  it("should handle strings that are identical", function()
    assert.are.equal("ABCDEF", lcs("ABCDEF", "ABCDEF"))
  end)

  it("should handle one string being a subsequence of the other", function()
    assert.are.equal("ACE", lcs("ABCDE", "ACE"))
    assert.are.equal("ACE", lcs("ACE", "ABCDE"))
  end)

  it("should handle strings with repeating characters", function()
    assert.are.equal("AAAA", lcs("AAAAA", "BBAAAAB"))
  end)

  it("should handle strings with all different characters but some in common", function()
    assert.are.equal("MJAU", lcs("XMJYAUZ", "MZJAWXU"))
  end)

  it("should handle long strings with a known LCS", function()
    local str1 = "ABCBDAB"
    local str2 = "BDCABA"
    -- Possible LCSs are "BCBA", "BDAB", "BCAB"
    local result = lcs(str1, str2)
    local possible_lcs = { "BCBA", "BDAB", "BCAB" }
    local is_valid = false
    for _, l in ipairs(possible_lcs) do
      if result == l then
        is_valid = true
        break
      end
    end
    assert.is_true(is_valid)
  end)

  it("should handle strings with special characters and spaces", function()
    assert.are.equal(" bcd", lcs("!a b@c#d$", " a-b=c d "))
  end)

  it("should handle strings with numeric characters", function()
    assert.are.equal("1234", lcs("1a2b3c4d", "012345"))
  end)

end)
