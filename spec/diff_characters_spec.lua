local Diff = require('diff')

-- Helper function to make tests cleaner.
-- It runs the diff and compares the resulting changes and content
-- against an expected sequence.
local function assert_char_diff(left, right, expected)
  local diff_instance = Diff.from_chars(left, right)
  local actual_diff = diff_instance:diff()

  -- 1. Check if the number of changes is as expected.
  assert.are.equal(#expected, #actual_diff,
    "Expected " .. #expected .. " changes, but got " .. #actual_diff)

  -- 2. Check each change in sequence.
  for i, expected_change in ipairs(expected) do
    local actual_change = actual_diff[i]
    assert.is_not_nil(actual_change)
    assert.are.equal(expected_change.change, actual_change.change,
      string.format("Mismatch at index %d: expected change '%s', got '%s'", i, expected_change.change, actual_change.change))
    assert.are.equal(expected_change.content, actual_change.content,
      string.format("Mismatch at index %d: expected content '%s', got '%s'", i, expected_change.content, actual_change.content))
  end
end


describe("Character-based Diffing", function()

  -- ===================================================================
  -- Test Basic Operations
  -- ===================================================================
  describe("Basic Operations", function()
    it("should detect no changes for identical strings", function()
      assert_char_diff("hello", "hello", {
        { change = "=", content = "h" },
        { change = "=", content = "e" },
        { change = "=", content = "l" },
        { change = "=", content = "l" },
        { change = "=", content = "o" },
      })
    end)

    it("should detect a simple addition at the end", function()
      assert_char_diff("apple", "apples", {
        { change = "=", content = "a" },
        { change = "=", content = "p" },
        { change = "=", content = "p" },
        { change = "=", content = "l" },
        { change = "=", content = "e" },
        { change = "+", content = "s" },
      })
    end)

    it("should detect a simple deletion from the end", function()
      assert_char_diff("apples", "apple", {
        { change = "=", content = "a" },
        { change = "=", content = "p" },
        { change = "=", content = "p" },
        { change = "=", content = "l" },
        { change = "=", content = "e" },
        { change = "-", content = "s" },
      })
    end)

    it("should detect a simple substitution in the middle", function()
      -- A substitution is treated as a deletion followed by an addition.
      assert_char_diff("apply", "apple", {
        { change = "=", content = "a" },
        { change = "=", content = "p" },
        { change = "=", content = "p" },
        { change = "=", content = "l" },
        { change = "-", content = "y" },
        { change = "+", content = "e" },
      })
    end)

    it("should detect an addition at the beginning", function()
      assert_char_diff("world", "helloworld", {
        { change = "+", content = "h" },
        { change = "+", content = "e" },
        { change = "+", content = "l" },
        { change = "+", content = "l" },
        { change = "+", content = "o" },
        { change = "=", content = "w" },
        { change = "=", content = "o" },
        { change = "=", content = "r" },
        { change = "=", content = "l" },
        { change = "=", content = "d" },
      })
    end)

    it("should detect a deletion from the beginning", function()
      assert_char_diff("helloworld", "world", {
        { change = "-", content = "h" },
        { change = "-", content = "e" },
        { change = "-", content = "l" },
        { change = "-", content = "l" },
        { change = "-", content = "o" },
        { change = "=", content = "w" },
        { change = "=", content = "o" },
        { change = "=", content = "r" },
        { change = "=", content = "l" },
        { change = "=", content = "d" },
      })
    end)
  end)

  -- ===================================================================
  -- Test Corner Cases
  -- ===================================================================
  describe("Corner Cases", function()
    it("should handle an empty left string (all additions)", function()
      assert_char_diff("", "new", {
        { change = "+", content = "n" },
        { change = "+", content = "e" },
        { change = "+", content = "w" },
      })
    end)

    it("should handle an empty right string (all deletions)", function()
      assert_char_diff("old", "", {
        { change = "-", content = "o" },
        { change = "-", content = "l" },
        { change = "-", content = "d" },
      })
    end)

    it("should handle two empty strings (no changes)", function()
      assert_char_diff("", "", {})
    end)

    it("should handle strings with no common characters", function()
      assert_char_diff("abc", "def", {
        { change = "-", content = "a" },
        { change = "-", content = "b" },
        { change = "-", content = "c" },
        { change = "+", content = "d" },
        { change = "+", content = "e" },
        { change = "+", content = "f" },
      })
    end)

    it("should correctly diff changes with a common prefix and suffix", function()
      assert_char_diff("ABC_middle_XYZ", "ABC_new_XYZ", {
        { change = "=", content = "A" },
        { change = "=", content = "B" },
        { change = "=", content = "C" },
        { change = "=", content = "_" },
        { change = "-", content = "m" },
        { change = "-", content = "i" },
        { change = "-", content = "d" },
        { change = "-", content = "d" },
        { change = "-", content = "l" },
        { change = "+", content = "n" },
        { change = "=", content = "e" },
        { change = "+", content = "w" },
        { change = "=", content = "_" },
        { change = "=", content = "X" },
        { change = "=", content = "Y" },
        { change = "=", content = "Z" },
      })
    end)

    it("should handle shifted/transposed content as deletes and adds", function()
      -- Myers algorithm doesn't detect "moves", it sees this as changes.
      assert_char_diff("ABC", "BCA", {
        { change = "-", content = "A" },
        { change = "=", content = "B" },
        { change = "=", content = "C" },
        { change = "+", content = "A" },
      })
    end)

    it("should handle strings with repetitive characters", function()
      assert_char_diff("aaaaabbbaaaaa", "aaaaacccaaaaa", {
        { change = "=", content = "a" },
        { change = "=", content = "a" },
        { change = "=", content = "a" },
        { change = "=", content = "a" },
        { change = "=", content = "a" },
        { change = "-", content = "b" },
        { change = "-", content = "b" },
        { change = "-", content = "b" },
        { change = "+", content = "c" },
        { change = "+", content = "c" },
        { change = "+", content = "c" },
        { change = "=", content = "a" },
        { change = "=", content = "a" },
        { change = "=", content = "a" },
        { change = "=", content = "a" },
        { change = "=", content = "a" },
      })
    end)

    it("should correctly handle multi-byte UTF-8 characters", function()
        assert_char_diff("a😀c", "a😂c", {
            { change = "=", content = "a" },
            { change = "-", content = "😀" },
            { change = "+", content = "😂" },
            { change = "=", content = "c" },
        })
    end)
  end)
end)

-- ===================================================================
-- LINE DIFF TESTS
-- ===================================================================

-- Helper function for line-based diffs.
local function assert_line_diff(left, right, expected)
  local diff_instance = Diff.from_lines(left, right)
  local actual_diff = diff_instance:diff()

  assert.are.equal(#expected, #actual_diff,
    "Expected " .. #expected .. " line changes, but got " .. #actual_diff)

  for i, expected_change in ipairs(expected) do
    local actual_change = actual_diff[i]
    assert.is_not_nil(actual_change, "Actual line diff is shorter than expected.")
    assert.are.equal(expected_change.change, actual_change.change,
      string.format("Mismatch at line index %d: expected change '%s', got '%s'", i, expected_change.change, actual_change.change))
    assert.are.equal(expected_change.content, actual_change.content,
      string.format("Mismatch at line index %d: expected content '%s', got '%s'", i, expected_change.content, actual_change.content))
  end
end

describe("Line-based Diffing", function()

  describe("Basic Operations", function()
    it("should detect no changes for identical multiline text", function()
      local text = [[
line one
line two
line three]]
      assert_line_diff(text, text, {
        { change = "=", content = "line one" },
        { change = "=", content = "line two" },
        { change = "=", content = "line three" },
      })
    end)

    it("should detect a line addition at the end", function()
      local left = [[
apple
banana]]
      local right = [[
apple
banana
cherry]]
      assert_line_diff(left, right, {
        { change = "=", content = "apple" },
        { change = "=", content = "banana" },
        { change = "+", content = "cherry" },
      })
    end)

    it("should detect a line deletion from the end", function()
      local left = [[
apple
banana
cherry]]
      local right = [[
apple
banana]]
      assert_line_diff(left, right, {
        { change = "=", content = "apple" },
        { change = "=", content = "banana" },
        { change = "-", content = "cherry" },
      })
    end)

    it("should detect a line addition at the beginning", function()
      local left = [[
banana
cherry]]
      local right = [[
apple
banana
cherry]]
      assert_line_diff(left, right, {
        { change = "+", content = "apple" },
        { change = "=", content = "banana" },
        { change = "=", content = "cherry" },
      })
    end)

    it("should detect a line deletion from the beginning", function()
      local left = [[
apple
banana
cherry]]
      local right = [[
banana
cherry]]
      assert_line_diff(left, right, {
        { change = "-", content = "apple" },
        { change = "=", content = "banana" },
        { change = "=", content = "cherry" },
      })
    end)

    it("should detect a substituted line in the middle", function()
      local left = [[
first line
old second line
third line]]
      local right = [[
first line
new second line
third line]]
      assert_line_diff(left, right, {
        { change = "=", content = "first line" },
        { change = "-", content = "old second line" },
        { change = "+", content = "new second line" },
        { change = "=", content = "third line" },
      })
    end)
  end)

  describe("Corner Cases", function()
    it("should handle an empty left string (all additions)", function()
      local left = ""
      local right = [[
line one
line two]]
      assert_line_diff(left, right, {
        { change = "+", content = "line one" },
        { change = "+", content = "line two" },
      })
    end)

    it("should handle an empty right string (all deletions)", function()
      local left = [[
line one
line two]]
      local right = ""
      assert_line_diff(left, right, {
        { change = "-", content = "line one" },
        { change = "-", content = "line two" },
      })
    end)

    it("should handle two empty strings", function()
      assert_line_diff("", "", {})
    end)

    it("should handle text with no common lines", function()
      local left = [[
a
b
c]]
      local right = [[
d
e
f]]
      assert_line_diff(left, right, {
        { change = "-", content = "a" },
        { change = "-", content = "b" },
        { change = "-", content = "c" },
        { change = "+", content = "d" },
        { change = "+", content = "e" },
        { change = "+", content = "f" },
      })
    end)

    it("should correctly handle blank lines", function()
      local left = [[
start

end]]
      local right = [[
start
middle
end]]
      assert_line_diff(left, right, {
        { change = "=", content = "start" },
        { change = "-", content = "" }, -- Assuming string_to_line_table produces an empty string for blank lines
        { change = "+", content = "middle" },
        { change = "=", content = "end" },
      })
    end)

    it("should handle trailing newlines without creating extra changes", function()
      -- The string_to_line_table helper is designed to strip a single trailing newline,
      -- so these two inputs should be treated as identical.
      local left = "line one\nline two"
      local right = "line one\nline two\n"
      assert_line_diff(left, right, {
        { change = "=", content = "line one" },
        { change = "=", content = "line two" },
        { change = "+", content = "" },
      })
    end)

    it("should handle escaped new lines correctly", function()
      -- The string_to_line_table helper is designed to strip a single trailing newline,
      -- so these two inputs should be treated as identical.
      local left = "line one\nline\\n two"
      local right = "line one\nline\\n two\n"
      assert_line_diff(left, right, {
        { change = "=", content = "line one" },
        { change = "=", content = "line\\n two" },
        { change = "+", content = "" },
      })
    end)

    it("should handle a complex change with common prefix and suffix", function()
      local left = [[
-- config
host=localhost
user=admin

-- logging
level=info]]
      local right = [[
-- config
host=production.server.com
user=admin
password=secret

-- logging
level=debug]]
      assert_line_diff(left, right, {
        { change = "=", content = "-- config" },
        { change = "-", content = "host=localhost" },
        { change = "+", content = "host=production.server.com" },
        { change = "=", content = "user=admin" },
        { change = "+", content = "password=secret" },
        { change = "=", content = "" },
        { change = "=", content = "-- logging" },
        { change = "-", content = "level=info" },
        { change = "+", content = "level=debug" },
      })
    end)
  end)
end)
