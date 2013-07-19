local aux = {}

local buffer

do
	buffer = {}

	function buffer:add(...)
		for i, s in ipairs(table.pack(...)) do
			table.insert(self, s)
		end
		return self
	end

	function buffer:addf(fmt, ...)
		self:add(fmt:format(...))
		return self
	end

	function buffer:result()
		return table.concat(self)
	end
end

function aux.buffer()
	return setmetatable({}, {__index = buffer})
end

function aux.addtable(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			t1[k] = t1[k] or {}
			aux.addtable(t1[k], v)
		else
			t1[k] = (t1[k] or 0) + v
		end
	end
end

function aux.plural(name, count)
	if count == 0 then
		return "no " .. name .. "s"
	elseif count == 1 then
		return "1 " .. name
	else
		return count .. " " .. name .. "s"
	end
end

function aux.handler(errobj)
	local traceback = debug.traceback(nil, 2)
	traceback = traceback:gsub("\t", "      ")
	traceback = "S" .. traceback:sub(2, -1)
	return ("    %s\r\n    %s\r\n"):format(tostring(errobj), traceback)
end

local tostring_actions = {
	["nil"] = function(x)
		return "nil"
	end,
	["boolean"] = function(x)
		if x then
			return "true"
		else
			return "false"
		end
	end,
	["number"] = function(x)
		return x
	end,
	["string"] = function(x)
		local s = ("%q"):format(x)
		if s:len() > 50 then
			s = s:sub(1, 50) .. "...\""
		end
		return s
	end
}

function aux.tostring(x)
	return (tostring_actions[type(x)] or type)(x)
end

function aux.exprec(expected, received, msg)
	return false, msg or ("expected " .. expected .. ", received " .. received)
end

function aux.unexp(unexpected, msg)
	return false, msg or ("received unexpected " .. unexpected)
end

return aux
