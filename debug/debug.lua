local debug = {}

local function is_debug()
    return settings.startup["22_tb_debug"]
end

local function is_runtime()
    return game ~= nil
end

--- @param data any
function debug.log(data)
    local message = serpent.line(data)
    log(message)
    if is_runtime() then
        print(message)
    end
end

-- If debug is disabled, replace all debug functions by empty functions
if not is_debug() then
    for key, _ in pairs(debug) do
        debug[key] = function() end
    end
end
return debug
