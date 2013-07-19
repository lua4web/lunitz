local _M = {}

local aux = require "lunitz.aux"

--------------------------------------------------
-- Equality assertions ---------------------------
--------------------------------------------------

function _M.assert_equal(expected, x, msg)
	if rawequal(expected, x) then
		return true
	else
		if (type(x) == "table" or type(x) == "function" or type(x) == "userdata") and type(x) == type(expected) then
			return aux.exprec(aux.tostring(expected), "different " .. aux.tostring(x), msg)
		else
			return aux.exprec(aux.tostring(expected), aux.tostring(x), msg)
		end
	end
end

function _M.assert_not_equal(unexpected, received, msg)
	if rawequal(unexpected, received) then
		return aux.unexp(aux.tostring(unexpected), msg)
	else
		return true
	end
end

function _M.assert_true(x, msg)
	return _M.assert_equal(true, x, msg)
end

function _M.assert_false(x, msg)
	return _M.assert_equal(false, x, msg)
end

function _M.assert_nan(x, msg)
	if rawequal(x, x) then
		return aux.exprec("nan", aux.tostring(x), msg)
	else
		return true
	end
end

function _M.assert_not_nan(x, msg)
	if rawequal(x, x) then
		return true
	else
		return aux.unexp("nan", msg)
	end
end

--------------------------------------------------
-- Typecheck assertions --------------------------
--------------------------------------------------

do
	local typenames = {
		"nil",
		"boolean",
		"number",
		"string",
		"table",
		"function",
		"thread",
		"userdata"
	}
	
	for id, typename in ipairs(typenames) do
		_M["assert_" .. typename] = function(x, msg)
			if type(x) == typenames[id] then
				return true
			else
				return aux.exprec(typenames[id], type(x), msg)
			end
		end
		_M["assert_not_" .. typename] = function(x, msg)
			if type(x) == typenames[id] then
				return aux.unexp(typenames[id], msg)
			else
				return true
			end
		end
	end
end

--------------------------------------------------
-- Special assertions ----------------------------
--------------------------------------------------

function _M.assert_truthy(x, msg)
	if x then
		return true
	else
		return aux.unexp(aux.tostring(x), msg)
	end
end

function _M.assert_falsy(x, msg)
	if x then
		return aux.unexp(aux.tostring(x), msg)
	else
		return true
	end
end

function _M.assert_error(f, msg)
	if type(f) ~= "function" then
		return aux.exprec("function", type(f), msg)
	end
	local status = pcall(f)
	if status then
		return false, msg or "expected error in provided function"
	else
		return true
	end
end

function _M.assert_not_error(f, msg)
	if type(f) ~= "function" then
		return aux.exprec("function", type(f), msg)
	end
	local status = pcall(f)
	if status then
		return true
	else
		return false, msg or "caught unexpected error in provided function"
	end
end

function _M.assert_match(pattern, s, msg)
	if type(pattern) ~= "string" then
		return aux.exprec("pattern to be a string", type(pattern), msg)
	end
	if type(s) ~= "string" then
		return aux.exprec("string", type(s), msg)
	end
	if s:match(pattern) then
		return true
	else
		return aux.exprec("string matching pattern " .. aux.tostring(pattern), aux.tostring(s), msg)
	end
end

function _M.assert_not_match(pattern, s, msg)
	if type(pattern) ~= "string" then
		return aux.exprec("pattern to be a string", type(pattern), msg)
	end
	if type(s) ~= "string" then
		return aux.exprec("string", type(s), msg)
	end
	if s:match(pattern) then
		return aux.unexp("string " .. aux.tostring(s) .. " matching pattern " .. aux.tostring(pattern), msg)
	else
		return true
	end
end

function _M.fail(msg)
	return false, msg or ""
end

return _M
