local utils = require("utils.utils")
local Stream = require("tools.stream")

local take_tests = {}

function take_tests.basic()
    local input = {1, 2, 3, 4, 5}
    local result = Stream.from(input):take(3):to_table()

    assert(#result == 3, "Expected 3 elements")
    for i = 1, 3 do
        assert(result[i] == i, "Element mismatch at index " .. i)
    end
end

function take_tests.zero()
    local input = {1, 2, 3}
    local result = Stream.from(input):take(0):to_table()

    assert(#result == 0, "Expected 0 elements")
end

function take_tests.more_than_available()
    local input = {10, 20}
    local result = Stream.from(input):take(5):to_table()

    assert(#result == 2, "Expected 2 elements")
    assert(result[1] == 10 and result[2] == 20, "Values do not match input")
end

function take_tests.with_where()
    local input = {1, 2, 3, 4, 5}
    local result = Stream.from(input):where(function(_, value)
            return value % 2 == 1
        end):take(2):to_table()

    assert(utils.count(result) == 2, "Expected 2 elements after filtering")
    assert(result[1] == 1 and result[3] == 3, "Filtered elements mismatch")
end

return take_tests
