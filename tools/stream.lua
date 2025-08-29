local utils = require("utils.utils")

--- @class Stream<TKey, TValue>
local Stream = {}
Stream.__index = Stream

--- @generic TKey
--- @generic TValue
--- @param iterator_factory fun(table: table<TKey, TValue>, previous_key: TKey): TKey, TValue
--- @return Stream<TKey, TValue>
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

--- @generic T
--- @param value T | T[] | nil
--- @return Stream<number, T>
function Stream.of(value)
    if value == nil then
        value = {}
    elseif not utils.is_list(value) then
        value = { value }
    end

    return Stream.from(value)
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
--- @param predicate (fun(key: TKey, value: TValue): boolean) | nil
--- @return TKey | nil, TValue | nil
function Stream:first_or_default(predicate)
    -- Default predicate matching everything
    predicate = predicate or function(_, _)
        return true
    end

    for key, value in self:iterate() do
        if predicate(key, value) then
            return key, value
        end
    end
    return nil, nil
end

--- @generic TKey
--- @generic TValue
--- @param self Stream<TKey, TValue>
--- @param predicate fun(key: TKey, value: TValue): boolean
--- @return TKey, TValue
function Stream:first(predicate)
    local key, value = self:first_or_default(predicate)
    return key or error("No element matched the predicate"), value
end

--- @generic TKey
--- @generic TValue
--- @param self Stream<TKey, TValue>
--- @param predicate fun(key: TKey, value: TValue): boolean
--- @return boolean
function Stream:any(predicate)
    return self:first_or_default(predicate) ~= nil
end

--- @generic TKey
--- @generic TValue
--- @param self Stream<TKey, TValue>
--- @param predicate fun(key: TKey, value: TValue): boolean
--- @return Stream<TKey, TValue>
function Stream:where(predicate)
    function where_iterator_factory()
        local iterator, table, previous_key = self:iterate()
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
