package = "lunitz"
version = "0.1-1"
source = {
	url = "git://github.com/lua4web/lunitz.git",
	tag = "v0.1"
}
description = {
	summary = "Robust unit testing framework for Lua",
	detailed = [[lunitz is a unit testing framework inspired by lunit and lunitx. It preserves most of their features and adds several new ones, such as constant execution order of tests and testcases, clean syntax of testcase and test declaraions, possibility to ignore assertion fails and more. Testcases can be required from other files without anything but a require() call, and custom assertion functions can be easily created and imported. 
]],
	homepage = "http://github.com/lua4web/lunitz",
	license = "MIT/X11"
}
dependencies = {
	"lua >= 5.1, < 5.3",
	"30log >= 0.5",
	"alt-getopt >= 0.7"
}
build = {
	type = "builtin",
	modules = {
		lunitz = "lunitz.lua",
		["lunitz.testsuit"] = "testsuit.lua",
		["lunitz.testcase"] = "testcase.lua",
		["lunitz.test"] = "test.lua",
		["lunitz.event"] = "event.lua",
		["lunitz.aux"] = "aux.lua",
		["lunitz.assertions"] = "assertions.lua"
	}
}
