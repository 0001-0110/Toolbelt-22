local utils = require("utils.utils")

--- @generic TKey
--- @generic TValue
--- @alias Iterator fun(table: table<TKey, TValue>, previous_key: TKey): (TKey, TValue)

--- @generic TKey
--- @generic TValue
--- @alias IteratorFactory fun(): Iterator<TKey, TValue>, table<TKey, TValue>, TKey

--- @class Stream<TKey, TValue>
--- @field _iterator_factory IteratorFactory
local Stream = {}
Stream.__index = Stream

--- @generic TKey
--- @generic TValue
--- @param iterator_factory IteratorFactory
--- @return Stream<TKey, TValue>
local function create_stream(iterator_factory)
    local stream = { _iterator_factory = iterator_factory }
    setmetatable(stream, Stream)
    return stream
end

--- @generic TKey
--- @generic TValue
--- @param table table<TKey, TValue>
--- @return Stream<TKey, TValue>
function Stream.from(table)
    if type(table) ~= "table" then
        error()
    end
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
    elseif not utils.is_array(value) then
        value = { value }
    end

    return Stream.from(value)
end

--- @generic TKey
--- @generic TValue
--- @param self Stream<TKey, TValue>
--- @return Iterator, table<TKey, TValue>, TKey
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
--- @return table<number, TValue>
function Stream:to_array()
    local array = {}
    for _, value in self:iterate() do
        table.insert(array, value)
    end
    return array
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
    local function where_iterator_factory()
        local iterator, state, init_key = self:iterate()
        local function where_iterator(table, previous_key)
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
        return where_iterator, state, init_key
    end
    return create_stream(where_iterator_factory)
end

--- @generic TKey
--- @generic TValue
--- @param self Stream<TKey, TValue>
--- @param count number
--- @return Stream<TKey, TValue>
function Stream:take(count)
    if not utils.is_int(count) then
        error("You can't take a decimal number of elements")
    end

    local function take_iterator_factory()
        local iterator, state, init_key = self:iterate()
        local remaining = count
        local function take_iterator(table, previous_key)
            if remaining == 0 then
                return nil
            end
            remaining = remaining - 1
            return iterator(table, previous_key)
        end
        return take_iterator, state, init_key
    end
    return create_stream(take_iterator_factory)
end

--- Applies a function to each element and flattens the results into a single stream.
--- The mapping function should return a table of values.
--- @generic TValue, TResult
--- @param selector fun(value: TValue): table<any, TResult>
--- @return Stream<number, TResult>
function Stream:flat_map(selector)
    local function flat_map_iterator_factory()
        local outer_iterator, outer_state, outer_key = self:iterate()
        local inner_table, inner_key
        local output_index = 0

        local function flat_map_iterator(_, _)
            -- While loop is necessary in case we need to skip outer elements, like an empty list that would not yield
            -- any inner element
            while true do
                -- If no active inner_table, advance outer iterator
                if inner_table == nil then
                    local outer_value
                    outer_key, outer_value = outer_iterator(outer_state, outer_key)
                    if outer_key == nil then
                        return nil, nil -- outer exhausted
                    end
                    inner_table = selector(outer_value)
                    inner_key = nil
                end

                -- Try to get next inner value
                local inner_value
                inner_key, inner_value = next(inner_table, inner_key)
                if inner_key ~= nil then
                    output_index = output_index + 1
                    return output_index, inner_value
                else
                    -- inner exhausted, reset and loop back to outer
                    inner_table = nil
                end
            end
        end

        return flat_map_iterator, nil, nil
    end

    return create_stream(flat_map_iterator_factory)
end

return Stream
