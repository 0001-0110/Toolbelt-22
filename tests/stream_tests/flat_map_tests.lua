local utils = require("utils.utils")
local Stream = require("tools.stream")

local flat_map_tests = {}

function flat_map_tests.basic_flatten()
    local input = { { 1, 2 }, { 3 }, { 4, 5 } }
    local result = Stream.from(input)
        :flat_map(function(inner)
            return inner
        end)
        :to_table()

    assert(utils.count(result) == 5, "Expected 5 elements")
    for i = 1, 5 do
        assert(result[i] == i, "Mismatch at index " .. i)
    end
end

function flat_map_tests.empty_lists()
    local input = { {}, { 1 }, {}, { 2, 3 }, {} }
    local result = Stream.from(input)
        :flat_map(function(inner)
            return inner
        end)
        :to_table()

    assert(utils.count(result) == 3, "Expected 3 elements")
    assert(result[1] == 1 and result[2] == 2 and result[3] == 3, "Flattened elements mismatch")
end

function flat_map_tests.map_to_custom()
    local input = { 1, 2, 3 }
    local result = Stream.from(input)
        :flat_map(function(value)
            return { value, value * 10 }
        end)
        :to_table()

    assert(utils.count(result) == 6, "Expected 6 elements")
    assert(result[1] == 1 and result[2] == 10, "Mismatch for first value")
    assert(result[3] == 2 and result[4] == 20, "Mismatch for second value")
    assert(result[5] == 3 and result[6] == 30, "Mismatch for third value")
end

function flat_map_tests.with_empty_input()
    local input = {}
    local result = Stream.from(input)
        :flat_map(function(inner)
            return inner
        end)
        :to_table()

    assert(utils.count(result) == 0, "Expected empty result for empty input")
end

function flat_map_tests.with_many_operations()
    local input = { 1, 2, 3 }
    local result = Stream.from(input)
        :flat_map(function(value)
            return { value, value * 10, value * 100 }
        end)
        :take(6)
        :where(function(_, value)
            return value >= 10
        end)
        :flat_map(function(value)
            return { value, value + 1 }
        end)
        :where(function(_, value)
            return value == 10
        end)
        :to_table()

    assert(utils.count(result) == 1, "Expected 1 element, got " .. utils.count(result))
    assert(result[1] == 10)
end

return flat_map_tests
