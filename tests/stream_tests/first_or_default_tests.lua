local Stream = require("tools.stream")

local first_or_default_tests = {}

function first_or_default_tests.no_predicate_found()
    local stream = Stream.of({ 1, 2, 3 })
    local _, value = stream:first_or_default()
    assert(value == 1, "Expected value 1")
end

function first_or_default_tests.found()
    local stream = Stream.of({ 1, 2, 3 })
    local _, value = stream:first_or_default(function(_, value)
        return value == 2
    end)
    assert(value == 2, "Expected value 2")
end

function first_or_default_tests.not_found()
    local stream = Stream.of({ 1, 2, 3 })
    local key, value = stream:first_or_default(function(_, value)
        return value == 99
    end)
    assert(key == nil and value == nil, "Expected nil, nil when not found")
end

return first_or_default_tests
