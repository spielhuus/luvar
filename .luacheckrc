-- Only allow symbols available in all Lua versions
std = "min"

-- Get rid of "unused argument self"-warnings
self = false

-- The unit tests can use busted
files["spec"].std = "+busted"

-- This file itself
files[".luacheckrc"].ignore = { "111", "112", "131" }

-- Theme files, ignore max line length
files["spec/*"].ignore = { "631" }

exclude_files = {
	-- "lua/lungan/providers/replicate.lua",
	-- "lua/lungan/nvim/cmp/frontmatter.lua",
}
