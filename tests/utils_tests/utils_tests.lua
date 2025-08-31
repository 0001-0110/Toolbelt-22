local utils = require("utils.utils")

local utils_tests = {}

function utils_tests.count_test_empty()
    local result = utils.count({})
    assert(result == 0)
end

function utils_tests.count_test_simple_array()
    local input = { 1, 2, 3 }
    local result = utils.count(input)
    assert(result == 3)
end

function utils_tests.count_test_array_with_nil()
    local input = { 1, 2, 3, nil }
    local result = utils.count(input)
    assert(result == 3)
end

function utils_tests.count_test_simple_table()
    local input = { one = 1, two = 2, three = 3 }
    local result = utils.count(input)
    assert(result == 3)
end

function utils_tests.count_test_table_with_nil()
    local input = { one = 1, two = 2, three = 3, null = nil }
    local result = utils.count(input)
    assert(result == 3)
end

return utils_tests
