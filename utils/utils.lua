local utils = {}

--- @param table table
function utils.count(table)
    local count = 0
    for _, _ in pairs(table) do
        count = count + 1
    end
    return count
end

--- @param data any
function utils.is_list(data)
    if type(data) ~= "table" then
        return false
    end

    local count = 0
    for key, value in pairs(data) do
        if type(key) ~= "number" then
            return false
        end
        count = count + 1
    end

    return count == #data
end

return utils
