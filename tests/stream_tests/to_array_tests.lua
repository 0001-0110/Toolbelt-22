local Stream = require("tools.stream")

local to_array_tests = {}

function to_array_tests.empty_stream()
    local result = Stream.from({}):to_array()
    assert(#result == 0, "Expected empty array")
end

function to_array_tests.array_input()
    local result = Stream.from({ "a", "b", "c" }):to_array()
    assert(#result == 3, "Expected length 3")
    assert(result[1] == "a" and result[2] == "b" and result[3] == "c", "Expected ordered values")
end

function to_array_tests.map_input()
    local input = { x = 1, y = 2 }
    local result = Stream.from(input):to_array()
    -- order is not guaranteed for map keys, but both values must be present
    table.sort(result)
    assert(result[1] == 1 and result[2] == 2, "Expected values {1, 2}")
end

function to_array_tests.mixed_keys()
    local input = { 10, 20, z = 30 }
    local result = Stream.from(input):to_array()
    table.sort(result)
    assert(result[1] == 10 and result[2] == 20 and result[3] == 30, "Expected values {10,20,30}")
end

return to_array_tests
