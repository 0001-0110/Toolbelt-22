local utils = {}

--- @param table table
function utils.count(table)
    local count = 0
    for _, _ in pairs(table) do
        count = count + 1
    end
    return count
end

--- Check if the given data is an integer
--- @param data any
--- @return boolean
function utils.is_int(data)
    return type(data) == "number" and math.floor(data) == data
end

--- Check if the given argument is an array, meaing it has continuous keys that start at 1
--- @param data any
--- @return boolean
function utils.is_array(data)
    if type(data) ~= "table" then
        return false
    end

    local count = 0
    for key, _ in pairs(data) do
        if type(key) ~= "number" then
            return false
        end
        count = count + 1
    end

    return count == #data
end

return utils
