local oop = require "loop.simple"
local aux = require "lunitz.aux"

local test = require "lunitz.test"

local testcase = oop.class()

function testcase:__init(name, params)
	params = params or {}
	return oop.rawnew(self, {
		name = name,
		setup = params.setup,
		teardown = params.teardown,
		ignore_fails = params.ignore_fails,
		tests = {}
	})
end

function testcase:add_test(name, f)
	table.insert(self.tests, test(name, f))
	return #self.tests
end

function testcase:add_event(event)
	return self.tests[self.current_test_id]:add_event(event)
end

function testcase:run(verbose)
	local ok = true
	local report = aux.buffer()
	local stats = {
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
	
	report:addf("Testcase %s: ", self.name)
	report:add("Placeholder", "\r\n\r\n")
	
	for test_id, test in ipairs(self.tests) do
		self.current_test_id = test_id
		
		local test_ok, test_status, test_report, test_stats = test:run(verbose, self.setup, self.teardown)
		
		stats.tests.total = stats.tests.total + 1
		stats.tests[test_status] = stats.tests[test_status] + 1
		
		ok = ok and test_ok
		
		if not test_ok or verbose then
			report:add(test_report)
		end
		
		aux.addtable(stats, test_stats)
	end
	
	if ok then
		report[2] = "OK (" .. aux.plural("test", stats.tests.total) .. ", skipped " .. aux.plural("test", stats.tests.skipped) .. ")"
	else
		report[2] = "Failed " .. aux.plural("test", stats.tests.failed) .. ", caught " .. aux.plural("error", stats.tests.errored)
	end
	
	return ok, report:result(), stats
end

return testcase
