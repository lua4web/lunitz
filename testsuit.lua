local oop = require "loop.simple"
local aux = require "lunitz.aux"

local testcase = require "lunitz.testcase"

local testsuit = oop.class{
	testcases = {}
}

function testsuit:add_testcase(name, params)
	table.insert(self.testcases, testcase(name, params))
	return #self.testcases
end

function testsuit:add_test(testcase_id, name, f)
	return self.testcases[testcase_id]:add_test(name, f)
end

function testsuit:add_event(event)
	return self.testcases[self.current_testcase_id]:add_event(event)
end

function testsuit:run(verbose)
	local ok = true
	local report = aux.buffer()
	local stats = {
		testcases = {
			total = 0,
			passed = 0,
			failed = 0
		},
		tests = {
			total = 0,
			passed = 0,
			skipped = 0,
			failed = 0,
			errored = 0
		},
		assertions = {
			total = 0,
			passed = 0,
			failed = 0
		}
	}
	
	report:add("Placeholder", "\r\n\r\n")
	
	for testcase_id, testcase in ipairs(self.testcases) do
		self.current_testcase_id = testcase_id
		
		local testcase_ok, testcase_report, testcase_stats = testcase:run(verbose)
		
		stats.testcases.total = stats.testcases.total + 1
		if testcase_ok then
			stats.testcases.passed = stats.testcases.passed + 1
		else
			stats.testcases.failed = stats.testcases.failed + 1
		end
		
		ok = ok and testcase_ok
		
		if not testcase_ok or verbose then
			report:add(testcase_report)
		end
		
		aux.addtable(stats, testcase_stats)
	end
	
	if ok then
		report[1] = "OK (" .. aux.plural("test", stats.tests.total) .. ", " .. aux.plural("testcase", stats.testcases.total) .. ")"
	else
		report[1] = "Failed " .. aux.plural("testcase", stats.testcases.failed) .. " out of " .. stats.testcases.total
	end
	
	return ok, report:result(), stats
end

return testsuit
