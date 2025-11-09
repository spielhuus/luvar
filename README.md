# Luvar

[![tests](https://img.shields.io/github/actions/workflow/status/spielhuus/luvar/busted.yml?branch=main&style=for-the-badge&label=Tests)](https://github.com/spielhuus/luvar/actions/workflows/test.yml)
[![luacheck](https://img.shields.io/github/actions/workflow/status/spielhuus/luvar/luacheck.yml?branch=main&style=for-the-badge&label=Luacheck)](https://github.com/spielhuus/luvar/actions/workflows/luacheck.yml)
[![luals](https://img.shields.io/github/actions/workflow/status/spielhuus/luvar/llscheck.yml?branch=main&style=for-the-badge&label=luals)](https://github.com/spielhuus/luvar/actions/workflows/llscheck.yml)
[![License-MIT](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](https://github.com/spielhuus/luvar/blob/main/LICENSE)

**Luvar** is a Lua library that provides algorithms for comparing sequences of text. It includes implementations for calculating the Longest Common Subsequence (LCS) and for generating detailed character-based and line-based differences between two strings, based on the Myers diff algorithm.

This library is ideal for tasks that require comparing text, such as version control systems, automated testing frameworks, and interactive development tools.

## Goals

*   **Compare** two strings to find their longest common subsequence.
*   **Generate** a detailed set of differences between two blocks of text.
*   **Support** both character-by-character and line-by-line comparison.
*   **Provide** a simple and intuitive API for developers.

## Features

*   **Longest Common Subsequence (LCS)**: Implements a standard dynamic programming algorithm to find the LCS between two strings.
*   **Myers Diff Algorithm**: Utilizes an efficient algorithm to find the shortest edit script (insertions and deletions) to transform one string into another.
*   **Character-based Diff**: Generates a detailed diff by comparing strings character by character, including support for multi-byte UTF-8 characters.
*   **Line-based Diff**: Generates a diff by comparing strings line by line, making it suitable for comparing documents or code files.
*   **Pure Lua**: Written entirely in Lua, making it easy to integrate into any Lua project.

## Installation

You can install `luvar` using your favorite package manager for Lua.

### [Luarocks](https://luarocks.org/)

```bash
git clone git@github.com:spielhuus/luvar.git
cd luvar
luarocks make --local
```

You can also copy the file `lua/lcs.lua` or `lua/diff.lua` to your source folder.

## Usage

Luvar provides two main modules: `lcs` for finding the Longest Common Subsequence and `diff` for generating detailed differences.

### 1. Longest Common Subsequence (lcs)

The `lcs` module provides a single function to find the longest common subsequence of characters between two strings.

```lua
local lcs_module = require('lcs')
local lcs = lcs_module.lcs

-- Find the LCS for two simple strings
local result1 = lcs("ABCDGH", "AEDFHR")
print(result1) -- "ADH"

-- Handle strings with no common subsequence
local result2 = lcs("ABC", "DEF")
print(result2) -- ""

-- Handle identical strings
local result3 = lcs("ABCDEF", "ABCDEF")
print(result3) -- "ABCDEF"
```

### 2. Generating Diffs

The `diff` module allows you to generate a sequence of changes (additions, deletions, or unchanged) between two strings, either character by character or line by line.

#### Character-based Diff

Use `Diff.from_chars()` to compare two strings at the character level.

```lua
local Diff = require('diff')

local left_string = "apply"
local right_string = "apple"

local diff_instance = Diff.from_chars(left_string, right_string)
local changes = diff_instance:diff()

-- The result is a table of changes
for _, item in ipairs(changes) do
  print(string.format("Change: '%s', Content: '%s'", item.change, item.content))
end

-- Expected output:
-- Change: '=', Content: 'a'
-- Change: '=', Content: 'p'
-- Change: '=', Content: 'p'
-- Change: '=', Content: 'l'
-- Change: '-', Content: 'y'
-- Change: '+', Content: 'e'
```

#### Line-based Diff

Use `Diff.from_lines()` to compare two multi-line strings. This is useful for comparing files or documents.

```lua
local Diff = require('diff')

local left_text = [[
first line
old second line
third line
]]

local right_text = [[
first line
new second line
third line
]]

local diff_instance = Diff.from_lines(left_text, right_text)
local changes = diff_instance:diff()

for _, item in ipairs(changes) do
  print(string.format("Change: '%s', Content: '%s'", item.change, item.content))
end

-- Expected output:
-- Change: '=', Content: 'first line'
-- Change: '-', Content: 'old second line'
-- Change: '+', Content: 'new second line'
-- Change: '=', Content: 'third line'
```

## Development

To run the busted tests localy type:

```bash
eval $(luarocks path --lua-version 5.1 --tree .venv)
luarocks test --lua-version 5.1 --tree .venv
```
