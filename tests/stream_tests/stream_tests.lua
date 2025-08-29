local utils = require("utils.utils")
local Stream = require("tools.stream")

local stream_tests = {}

function stream_tests.of_nil()
    local stream = Stream.of(nil)
    local result = stream:to_table()
    assert(next(result) == nil, "Expected empty table from Stream.of(nil)")
end

function stream_tests.of_single()
    local stream = Stream.of("hello")
    local result = stream:to_table()
    assert(#result == 1, "Expected single element")
    assert(result[1] == "hello", "Expected 'hello'")
end

function stream_tests.of_list()
    local stream = Stream.of({ "a", "b", "c" })
    local result = stream:to_table()
    assert(#result == 3, "Expected 3 elements")
    assert(result[1] == "a" and result[2] == "b" and result[3] == "c", "List elementstream mismatch")
end

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

function stream_tests.first_or_default_no_predicate_found()
    local stream = Stream.of({ 1, 2, 3 })
    local key, value = stream:first_or_default()
    assert(value == 1, "Expected value 1")
end

function stream_tests.first_or_default_found()
    local stream = Stream.of({ 1, 2, 3 })
    local key, value = stream:first_or_default(function(_, value) return value == 2 end)
    assert(value == 2, "Expected value 2")
end

function stream_tests.first_or_default_not_found()
    local stream = Stream.of({ 1, 2, 3 })
    local key, value = stream:first_or_default(function(_, value) return value == 99 end)
    assert(key == nil and value == nil, "Expected nil, nil when not found")
end

function stream_tests.first_found()
    local stream = Stream.of({ 10, 20, 30 })
    local key, value = stream:first(function(_, value) return value > 15 end)
    assert(value == 20, "Expected 20")
end

function stream_tests.first_not_found_raises()
    local stream = Stream.of({ 1, 2, 3 })
    local ok, err = pcall(function()
        stream:first(function(_, value) return value == 99 end)
    end)
    assert(ok == false, "Expected an error when element not found")
    assert(err:match("No element"), "Expected error message to mention 'No element'")
end

function stream_tests.any_true()
    local stream = Stream.of({ 1, 2, 3 })
    assert(stream:any(function(_, value) return value == 2 end), "Expected any to return true")
end

function stream_tests.any_false()
    local stream = Stream.of({ 1, 2, 3 })
    assert(not stream:any(function(_, value) return value == 99 end), "Expected any to return false")
end

-- Test simple filtering
function stream_tests.where_simple()
    local input = { a = 1, b = 2, c = 3, d = 4 }
    local result = Stream.from(input)
        :where(function(_, value) return value % 2 == 0 end)
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
        :where(function(_, value) return value > 1 end)
        :where(function(_, value) return value % 2 == 0 end)
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
    local result = Stream.from(input):where(function(_, _) return true end):to_table()
    assert(utils.count(result) == 0)
end

-- Test all filtered out
function stream_tests.all_filtered()
    local input = { x = 10, y = 20 }
    local result = Stream.from(input):where(function(_, value) return value > 100 end):to_table()
    assert(utils.count(result) == 0)
end

-- Test that keystream and valuestream are preserved
function stream_tests.keys_and_values()
    local input = { foo = "bar", hello = "world" }
    local result = Stream.from(input):where(function(key, _) return key == "foo" end):to_table()
    assert(result["foo"] == "bar")
    assert(result["hello"] == nil)
end

return stream_tests
