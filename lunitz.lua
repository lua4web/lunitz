local _M = {}

local alt_getopt = require "alt_getopt"

local long_opts = {
	verbose = "v",
	stats = "s",
	quick = "q",
	case = "c",
	test = "t"
}

local target = _G

local mt = getmetatable(target) or {}
mt.__index = _M
setmetatable(target, mt)

local testsuit = require "lunitz.testsuit"()

local function printf(fmt, ...)
	io.write(fmt:format(...))
end

local function show_stats(stats)
	printf("Testcases: \r\n")
	printf("  Total: %d\r\n", stats.testcases.total)
	printf("  Passed: %d\r\n", stats.testcases.passed)
	printf("  Failed: %d\r\n", stats.testcases.failed)
		
	printf("Tests: \r\n")
	printf("  Total: %d\r\n", stats.tests.total)
	printf("  Passed: %d\r\n", stats.tests.passed)
	printf("  Failed: %d\r\n", stats.tests.failed)
	printf("  Errors: %d\r\n", stats.tests.errored)
	printf("  Skipped: %d\r\n", stats.tests.skipped)
		
	printf("Assertions: \r\n")
	printf("  Total: %d\r\n", stats.assertions.total)
	printf("  Passed: %d\r\n", stats.assertions.passed)
	printf("  Failed: %d\r\n\r\n", stats.assertions.failed)
end

function _M.testcase(name, params)
	local testcase_id = testsuit:add_testcase(name, params)
	
	local mt = getmetatable(target) or {}
	function mt.__newindex(t, k, v)
		if type(v) == "function" then
			testsuit:add_test(testcase_id, k, v)
		else
			rawset(t, k, v)
		end
	end
	setmetatable(target, mt)
end

local function import_assertion(f, name)
	local function assertion(...)
		local ok, msg = f(...)
		local event = {
			type = "assertion",
			ok = ok,
			name = name,
			msg = msg
		}
		testsuit:add_event(event)
		if not ok and not testsuit.testcases[testsuit.current_testcase_id].ignore_fails then
			error(nil, 2)
		end
	end
	_M[name] = assertion
end

local function filter(t, pat)
	local i = 1
	while i <= #t do
		if not string.match(t[i].name, pat) then
			table.remove(t, i)
		else
			i = i + 1
		end
	end
end

function _M.import(lib)
	for name, f in pairs(require(lib)) do
		import_assertion(f, name)
	end
end

function _M.skip(msg)
	local event = {
		type = "skip",
		ok = true,
		msg = msg
	}
	testsuit:add_event(event)
	error(nil, 2)
end

function _M.say(msg)
	local event = {
		type = "say",
		ok = true,
		msg = msg
	}
	testsuit:add_event(event)
end

function _M.run()
	local opts = alt_getopt.get_opts(arg, "vsqc:t:", long_opts)
	
	printf("Running testsuit...\r\n")
	
	if opts.c then
		printf("  Selecting testcases matching pattern %q...\r\n", opts.c)
		filter(testsuit.testcases, opts.c)
	end
	
	if opts.t then
		printf("  Selecting tests matching pattern %q...\r\n", opts.t)
		local testcase_id = 1
		while testcase_id <= #testsuit.testcases do
			filter(testsuit.testcases[testcase_id].tests, opts.t)
			if #testsuit.testcases[testcase_id].tests == 0 then
				table.remove(testsuit.testcases, testcase_id)
			else
				testcase_id = testcase_id + 1
			end
		end
	end
	
	printf("\r\n")
	
	local ok, report, stats = testsuit:run(opts.v)
	
	if not opts.q then
		printf(report)
	else
		printf(report:sub(report:find(".-\r\n")) .. "\r\n")
	end
	
	if opts.s then
		show_stats(stats)
	end
end

function _M.import(lib)
	for name, f in pairs(require(lib)) do
		import_assertion(f, name)
	end
end

_M.import "lunitz.assertions"

return _M
