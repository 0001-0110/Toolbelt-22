local utils = require("utils.utils")
local Stream = require("tools.stream")

local stream_tests = {}

-- Test converting to a table
function stream_tests.to_table()
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

-- Test simple filtering
function stream_tests.where_simple()
    local input = { a = 1, b = 2, c = 3, d = 4 }
    local result = Stream.from(input)
        :where(function(_, v) return v % 2 == 0 end)
        :to_table()

    assert(result["b"] == 2)
    assert(result["d"] == 4)
    assert(result["a"] == nil)
    assert(result["c"] == nil)
end

-- Test chaining multiple operations
function stream_tests.where_chain()
    local input = { a = 1, b = 2, c = 3, d = 4, e = 5 }
    local result = Stream.from(input)
        :where(function(_, v) return v > 1 end)
        :where(function(_, v) return v % 2 == 0 end)
        :to_table()

    assert(result["b"] == 2)
    assert(result["d"] == 4)
    assert(result["a"] == nil)
    assert(result["c"] == nil)
    assert(result["e"] == nil)
end

-- Test empty table
function stream_tests.empty_table()
    local input = {}
    local result = Stream.from(input):where(function(_, v) return true end):to_table()
    assert(utils.count(result) == 0)
end

-- Test all filtered out
function stream_tests.all_filtered()
    local input = { x = 10, y = 20 }
    local result = Stream.from(input):where(function(_, v) return v > 100 end):to_table()
    assert(utils.count(result) == 0)
end

-- Test that keys and values are preserved
function stream_tests.keys_and_values()
    local input = { foo = "bar", hello = "world" }
    local result = Stream.from(input):where(function(k, v) return k == "foo" end):to_table()
    assert(result["foo"] == "bar")
    assert(result["hello"] == nil)
end

return stream_tests
