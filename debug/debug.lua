local debug = {}

function debug.is_debug()
    -- TODO
    return true
end

--- @param data any
function debug.log(data)
    if not debug.is_debug() then
        return
    end

    local message = serpent.block(data)
    log(message)
    if game then
        print(message)
    end
end

return debug
