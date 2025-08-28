local utils = {}

--- @param table table
function utils.count(table)
    local count = 0
    for _, _ in pairs(table) do
        count = count + 1
    end
    return count
end

return utils
