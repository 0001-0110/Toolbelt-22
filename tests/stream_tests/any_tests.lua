local Stream = require("tools.stream")

local any_tests = {}

function any_tests.is_true()
    local stream = Stream.of({ 1, 2, 3 })
    assert(stream:any(function(_, value) return value == 2 end), "Expected any to return true")
end

function any_tests.is_false()
    local stream = Stream.of({ 1, 2, 3 })
    assert(not stream:any(function(_, value) return value == 99 end), "Expected any to return false")
end

return any_tests
