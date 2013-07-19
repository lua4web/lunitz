local oop = require "loop.simple"
local aux = require "lunitz.aux"

local event = oop.class()

function event:__init(t)
	local info = debug.getinfo(4, "Sl")
	return oop.rawnew(self, {
		type = t.type,
		ok = t.ok,
		source = info.short_src,
		line = info.currentline,
		name = t.name,
		msg = t.msg
	})
end

function event:report()
	local start = "    %s:%s: "
	if self.type == "assertion" then
		if self.ok then
			return (start .. "%s is OK\r\n"):format(self.source, self.line, self.name)
		else
			return (start .. "%s %s\r\n"):format(self.source, self.line, self.name, self.msg)
		end
	elseif self.type == "skip" then
		if self.msg then
			return (start .. "skipped (%s)\r\n"):format(self.source, self.line, self.msg)
		else
			return (start .. "skipped\r\n"):format(self.source, self.line)
		end
	elseif self.type == "say" then
		return (start .. "%s\r\n"):format(self.source, self.line, self.msg)
	end
end

return event
