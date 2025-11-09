rockspec_format = "3.0"
package = "luvar"
version = "scm-1"

dependencies = {
	"lua >= 5.1",
}

test_dependencies = {
	"lua >= 5.1",
	"luacheck",
	"luassert",
	"busted",
	-- "lbase64",
	--  "luafilesystem >= 1.6.3",
}

source = {
	url = "git://github.com/spielhuus/" .. package,
}

-- build = {
-- 	type = "builtin",
-- 	install = {
-- 		bin = {
-- 			lungan = "bin/lungan.lua",
-- 		},
-- 	},
-- 	copy_directories = {
-- 		"rplugin",
-- 	},
-- }
