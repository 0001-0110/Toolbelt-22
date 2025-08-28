--- @class Stream<TKey, TValue>
--- @diagnostic disable-next-line: undefined-doc-name
--- @field _data table<TKey, TValue>
local Stream = {}
Stream.__index = Stream

--- @param iterator_factory fun(table: table<TKey, TValue>, previous_key: TKey): TKey, TValue
local function create_stream(iterator_factory)
    local stream = { _iterator_factory = iterator_factory }
    setmetatable(stream, Stream)
    return stream
end

--- @generic TKey
--- @generic TValue
--- @param array table<TKey, TValue>
--- @return Stream<TKey, TValue>
function Stream.from(table)
    return create_stream(function()
        return next, table, nil
    end)
end

--- @generic TKey
--- @generic TValue
--- @param self Stream<TKey, TValue>
--- @return fun(table: table<TKey, TValue>, previous_key: TKey): Tkey, TValue, table<TKey, TValue>, TKey
function Stream:iterate()
    -- Calls the factory to build the iterator, but still doesn't evaluate any values
    return self._iterator_factory()
end

--- @generic TKey
--- @generic TValue
--- @param self Stream<TKey, TValue>
--- @return table<TKey, TValue>
function Stream:to_table()
    local table = {}
    for key, value in self:iterate() do
        table[key] = value
    end
    return table
end

--- @generic TKey
--- @generic TValue
--- @param self Stream<TKey, TValue>
--- @param predicate fun(key: TKey, value: TValue): boolean
--- @return Stream<TKey, TValue>
function Stream:where(predicate)
    function where_iterator_factory()
        local iterator, table, previous_key = self._iterator_factory()
        function where_iterator(table, previous_key)
            while true do
                local key, value = iterator(table, previous_key)
                if key == nil then
                    return nil
                end
                if predicate(key, value) then
                    return key, value
                end
                previous_key = key
            end
        end
        return where_iterator, table, previous_key
    end
    return create_stream(where_iterator_factory)
end

return Stream
