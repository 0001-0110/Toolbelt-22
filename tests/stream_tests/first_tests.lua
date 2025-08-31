local Stream = require("tools.stream")

local first_tests = {}

function first_tests.found()
    local stream = Stream.of({ 10, 20, 30 })
    local _, value = stream:first(function(_, value)
        return value > 15
    end)
    assert(value == 20, "Expected 20")
end

function first_tests.not_found_raises()
    local stream = Stream.of({ 1, 2, 3 })
    local ok, err = pcall(function()
        stream:first(function(_, value)
            return value == 99
        end)
    end)
    assert(ok == false, "Expected an error when element not found")
    assert(err:match("No element"), "Expected error message to mention 'No element'")
end

return first_tests
