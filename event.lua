local class = require "30log"
local aux = require "lunitz.aux"

local event = class()

function event:__init(t)
	local info = debug.getinfo(4, "Sl")
	self.type = t.type
	self.ok = t.ok
	self.source = info.short_src
	self.line = info.currentline
	self.name = t.name
	self.msg = t.msg
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
