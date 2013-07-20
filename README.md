# lunitz - robust unit testing framework for Lua

lunitz is a unit testing framework inspired by lunit and lunitx. 

## Features

* Testcases are created by a `testcase` call. No need for ugly `module` calls. 
* Testcases can be imported from other files by a `require` call. 
* Tests and testcases are run in the order they are defined. 
* 28 assertion functions + special `fail`, `skip`, `alert` and `say` functions. 
* Custom assertion functions can be easily created and imported. 
* Possibility to ignore assertion fails. 
* `--case` and `--test` command line options for running particular testcases and tests. 
* Testsuit report is customizable with `--verbose`, `--quiet` and `--stats` command line options. 
* No need for a shell script to run testsuit, Lua interpreter is enough. 

## Example

Write a small testsuit with two tests in one testcase: 

```lua
require "lunitz" -- injects testing functions into global environment

testcase "basics" -- new testcase

function this_should_be_ok() -- new test
	say("This should be ok")
	assert_true(2 * 2 == 4)
	assert_string("foo") -- a couple of assertions
	assert_equal(7, 3 + 4)
end

function this_should_fail() -- another test
	alert("I'm afraid this is going to fail...")
	assert_equal(5, 2 * 2)
end

run() -- run the testsuit
```

Run it with command `lua test.lua`: 

```
Running testsuit...

Failed 1 testcase out of 1

Testcase basics: Failed 1 test, caught no errors

  Test this_should_fail: Failed assertion #1
    test.lua:13: I'm afraid this is going to fail...
    test.lua:14: assert_equal expected 5, received 4
```

Get verbose report about every assertion + some statistics with command `lua test.lua -vs`:

```
Running testsuit...

Failed 1 testcase out of 1

Testcase basics: Failed 1 test, caught no errors

  Test this_should_be_ok: OK (3 assertions)
    test.lua:6: This should be ok
    test.lua:7: assert_true is OK
    test.lua:8: assert_string is OK
    test.lua:9: assert_equal is OK

  Test this_should_fail: Failed assertion #1
    test.lua:13: I'm afraid this is going to fail...
    test.lua:14: assert_equal expected 5, received 4

Testcases: 
  Total: 1
  Passed: 0
  Failed: 1
Tests: 
  Total: 2
  Passed: 1
  Failed: 1
  Errors: 0
  Skipped: 0
Assertions: 
  Total: 4
  Passed: 3
  Failed: 1
```

Get quick result whether testsuit is OK or not with command `lua test.lua -q`:

```
Running testsuit...

Failed 1 testcase out of 1
```

Run only `this_should_be_ok` test with command `lua test.lua -t be_ok`:

```
Running testsuit...
  Selecting tests matching pattern "be_ok"...

OK (1 test, 1 testcase)
```

## Reference

TODO: write something here. 

## License

Copyright © 2013 lua4web <lua4web@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
