testcase ("This shouldn't pass", {ignore_fails = true})

function Equality_assertions()
	assert_equal(1, 0)
	assert_not_equal(1, 1)
	assert_true(false)
	assert_false(true)
	assert_nan(1/0)
	assert_not_nan(0/0)
end

function Typecheck_assertions()
	assert_nil(not nil)
	assert_not_nil(nil)
	assert_boolean(1)
	assert_not_boolean(true)
	assert_number("0")
	assert_not_number(0)
	assert_string(0)
	assert_not_string("0")
	assert_table(_g)
	assert_not_table(_G)
	assert_function(not assert_function)
	assert_not_function(assert_function)
	assert_thread("not thread")
	assert_not_thread(coroutine.create(function() end))
	assert_userdata("stderr")
	assert_not_userdata(io.stdin)
end

function Special_assertions()
	assert_truthy(nil)
	assert_falsy("0")
	assert_error(function() end)
	assert_not_error(function() (nil)() end)
	assert_match(".+", "")
	assert_not_match(".*", "foo")
end

function Custom_assertion()
	assert_empty(_G)
	assert_not_empty({})
end
