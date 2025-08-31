local Stream = require("tools.stream")

local of_tests = {}

function of_tests.nil_value()
    local stream = Stream.of(nil)
    local result = stream:to_table()
    assert(next(result) == nil, "Expected empty table from Stream.of(nil)")
end

function of_tests.single_value()
    local stream = Stream.of("hello")
    local result = stream:to_table()
    assert(#result == 1, "Expected single element")
    assert(result[1] == "hello", "Expected 'hello'")
end

function of_tests.list()
    local stream = Stream.of({ "a", "b", "c" })
    local result = stream:to_table()
    assert(#result == 3, "Expected 3 elements")
    assert(result[1] == "a" and result[2] == "b" and result[3] == "c", "List elementstream mismatch")
end

return of_tests
