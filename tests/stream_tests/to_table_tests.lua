local utils = require("utils.utils")
local Stream = require("tools.stream")

local to_table_tests = {}

function to_table_tests.empty_stream()
    local result = Stream.from({}):to_table()
    assert(next(result) == nil, "Expected empty table")
end

function to_table_tests.array_input()
    local result = Stream.from({"a", "b", "c"}):to_table()
    assert(result[1] == "a", "Expected index 1 = 'a'")
    assert(result[2] == "b", "Expected index 2 = 'b'")
    assert(result[3] == "c", "Expected index 3 = 'c'")
end

function to_table_tests.map_input()
    local input = { x = 1, y = 2 }
    local result = Stream.from(input):to_table()
    assert(result.x == 1, "Expected key 'x' = 1")
    assert(result.y == 2, "Expected key 'y' = 2")
end

function to_table_tests.mixed_keys()
    local input = { 10, 20, z = 30 }
    local result = Stream.from(input):to_table()
    assert(result[1] == 10, "Expected index 1 = 10")
    assert(result[2] == 20, "Expected index 2 = 20")
    assert(result.z == 30, "Expected key 'z' = 30")
end

function to_table_tests.all_types()
    local input = {
        test1 = "test1",
        test2 = 2,
        test3 = -4,
        test4 = { "test1" },
        test5 = { test6 = 6 },
    }

    local result = Stream.from(input):to_table()

    assert(utils.count(input) == utils.count(result))
    for key, value in pairs(input) do
        assert(result[key] == value)
    end
end

return to_table_tests
