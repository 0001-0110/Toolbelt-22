--- @class Stream<TKey, TValue>
--- @diagnostic disable-next-line: undefined-doc-name
--- @field _data table<TKey, TValue>
local Stream = {}
Stream.__index = Stream

--- @generic TKey
--- @generic TValue
--- @param array table<TKey, TValue>
--- @return Stream<TKey, TValue>
function Stream.from(array)
    local stream = { _data = array }
    setmetatable(stream, Stream)
    return stream
end

function Stream:iterate()
    -- return self., self._data, nil
end

function Stream:to_table()
    -- local table = {}
    -- for key, value in pairs(self:iterate()) do
    --     table[key] = value
    -- end
    -- return table
    return self._data
end

--- @generic TKey
--- @generic TValue
--- @param self Stream<TKey, TValue>
--- @param predicate fun(key: TKey, value: TValue): boolean
--- @return Stream<TKey, TValue>
function Stream:where(predicate)
    local result = {}
    for key, value in pairs(self._data) do
        if predicate(key, value) then
            result[key] = value
        end
    end
    return Stream.from(result)
end

return Stream
