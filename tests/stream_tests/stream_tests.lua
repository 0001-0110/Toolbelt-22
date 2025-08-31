local take_tests = require("tests.stream_tests.take_tests")
local any_tests = require("tests.stream_tests.any_tests")
local first_or_default_tests = require("tests.stream_tests.first_or_default_tests")
local first_tests = require("tests.stream_tests.first_tests")
local of_tests = require("tests.stream_tests.of_tests")
local to_array_tests = require("tests.stream_tests.to_array_tests")
local to_table_tests = require("tests.stream_tests.to_table_tests")
local where_tests = require("tests.stream_tests.where_tests")

local testfiles = {
    any_tests = any_tests,
    first_or_default_tests = first_or_default_tests,
    first_tests = first_tests,
    of_tests = of_tests,
    take_tests = take_tests,
    to_array_tests = to_array_tests,
    to_table_tests = to_table_tests,
    where_tests = where_tests,
}

local stream_tests = {}

for testfile_name, testfile in pairs(testfiles) do
    for testcase_name, testcase_function in pairs(testfile) do
        stream_tests[testfile_name .. "/" .. testcase_name] = testcase_function
    end
end

return stream_tests
