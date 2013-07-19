local _M = {}

local aux = require "lunitz.aux"

function _M.assert_empty(t, msg)
	if type(t) ~= "table" then
		return aux.exprec("table", type(t), msg)
	end
	if next(t) then
		return false, msg or "expected empty table"
	else
		return true
	end
end

function _M.assert_not_empty(t, msg)
	if type(t) ~= "table" then
		return aux.exprec("table", type(t), msg)
	end
	if next(t) then
		return true
	else
		return false, msg or "expected not empty table"
	end
end

return _M
