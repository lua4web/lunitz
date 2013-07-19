require "lunitz"

import "assert_empty"

testcase "This should pass"

function Equality_assertions()
	assert_equal(0, 0)
	assert_not_equal(-1, 1)
	assert_true(true)
	assert_false(false)
	assert_nan(0/0)
	assert_not_nan(1/0)
end

function Typecheck_assertions()
	assert_nil(nil)
	assert_not_nil(not nil)
	assert_boolean(true)
	assert_not_boolean(1)
	assert_number(0)
	assert_not_number("0")
	assert_string("0")
	assert_not_string(0)
	assert_table(_G)
	assert_not_table(_g)
	assert_function(assert_function)
	assert_not_function(not assert_function)
	assert_thread(coroutine.create(function() end))
	assert_not_thread("not thread")
	assert_userdata(io.stdin)
	assert_not_userdata("stderr")
end

function Special_assertions()
	assert_truthy("0")
	assert_falsy(nil)
	assert_error(function() (nil)() end)
	assert_not_error(function() end)
	assert_match(".*", "foo")
	assert_not_match(".+", "")
end

function Custom_assertion()
	assert_empty({})
	assert_not_empty(_G)
end

require "fails"

run()
