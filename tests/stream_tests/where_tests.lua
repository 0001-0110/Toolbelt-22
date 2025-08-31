local utils = require("utils.utils")
local Stream = require("tools.stream")

local where_tests = {}

-- Test simple filtering
function where_tests.simple()
    local input = { a = 1, b = 2, c = 3, d = 4 }
    local result = Stream.from(input)
        :where(function(_, value)
            return value % 2 == 0
        end)
        :to_table()

    assert(result["b"] == 2)
    assert(result["d"] == 4)
    assert(result["a"] == nil)
    assert(result["c"] == nil)
end

-- Test chaining multiple operations
function where_tests.chain()
    local input = { a = 1, b = 2, c = 3, d = 4, e = 5 }
    local result = Stream.from(input)
        :where(function(_, value)
            return value > 1
        end)
        :where(function(_, value)
            return value % 2 == 0
        end)
        :to_table()

    assert(result["b"] == 2)
    assert(result["d"] == 4)
    assert(result["a"] == nil)
    assert(result["c"] == nil)
    assert(result["e"] == nil)
end

-- Test empty table
function where_tests.empty_table()
    local input = {}
    local result = Stream.from(input)
        :where(function(_, _)
            return true
        end)
        :to_table()
    assert(utils.count(result) == 0)
end

-- Test all filtered out
function where_tests.all_filtered()
    local input = { x = 10, y = 20 }
    local result = Stream.from(input)
        :where(function(_, value)
            return value > 100
        end)
        :to_table()
    assert(utils.count(result) == 0)
end

-- Test that keystream and valuestream are preserved
function where_tests.keys_and_values()
    local input = { foo = "bar", hello = "world" }
    local result = Stream.from(input)
        :where(function(key, _)
            return key == "foo"
        end)
        :to_table()
    assert(result["foo"] == "bar")
    assert(result["hello"] == nil)
end

return where_tests
