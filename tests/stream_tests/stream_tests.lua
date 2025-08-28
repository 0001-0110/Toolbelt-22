local utils = require("utils.utils")
local Stream = require("tools.stream")

local stream_tests = {}

function stream_tests.to_table()
    local source = {
        test1 = "test1",
        test2 = 2,
        test3 = -4,
        test4 = { "test1" },
        test5 = { test6 = 6 },
    }

    local result = Stream.from(source):to_table()

    assert(utils.count(source) == utils.count(result))
    for key, value in pairs(source) do
        assert(result[key] == value)
    end
end

return stream_tests
