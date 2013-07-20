local oop = require "loop.simple"
local aux = require "lunitz.aux"

local event = require "lunitz.event"

local test = oop.class()

function test:__init(name, f)
	return oop.rawnew(self, {
		name = name,
		f = f,
		events = {}
	})
end

function test:add_event(ev)
	table.insert(self.events, event(ev))
end

function test:run(verbose, setup, teardown)
	local ok = true
	local status = "passed"
	local report = aux.buffer()
	local stats = {
		assertions = {
			total = 0,
			passed = 0,
			failed = 0
		}
	}
	
	report:addf("  Test %s: ", self.name)
	report:add("Placeholder", "\r\n")
	
	local not_errored, error_message, error_message_suffix = true, "", ""
	
	if setup then
		not_errored, error_message = xpcall(setup, aux.handler)
	end
	if not not_errored then
		error_message_suffix = " in setup function"
	else
		not_errored, error_message = xpcall(self.f, aux.handler)
	end
	
	if teardown then
		not_errored, error_message = xpcall(teardown, aux.handler)
		if not not_errored then
			error_message_suffix = " in teardown function"
		end
	end
		
	for event_id, event in ipairs(self.events) do
		if event.type == "assertion" then
			stats.assertions.total = stats.assertions.total + 1
			if event.ok then
				stats.assertions.passed = stats.assertions.passed + 1
			else
				stats.assertions.failed = stats.assertions.failed + 1
				status = "failed"
			end
		elseif event.type == "skip" then
			status = "skipped"
		end
		
		ok = ok and (event.ok or event.type == "say")
		
		if not event.ok or verbose then
			report:add(event:report())
		end
	end
	
	if (ok and not not_errored and status ~= "skipped") or error_message_suffix ~= "" then
		status = "errored"
		report:add(error_message)
		ok = false
	end
	
	if ok or status == "skipped" then
		ok = true
		if status == "passed" then
			report[2] = "OK (" .. aux.plural("assertion", stats.assertions.total) .. ")"
		else
			report[2] = "Skipped"
		end
	else
		if status == "failed" then
			report[2] = "Failed assertion #" .. stats.assertions.total
		else
			report[2] = "Error" .. error_message_suffix
		end
	end
	
	report:add("\r\n")
	
	return ok, status, report:result(), stats
end

return test
