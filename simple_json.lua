-- Simple JSON-like parser for beginners
-- Since we can't use external libraries

local json = {}

-- Simple table to string conversion
function json.encode(t)
    if type(t) == "string" then
        return '"' .. t .. '"'
    elseif type(t) == "number" then
        return tostring(t)
    elseif type(t) == "boolean" then
        return tostring(t)
    elseif type(t) == "table" then
        local result = "{"
        local first = true
        for k, v in pairs(t) do
            if not first then
                result = result .. ","
            end
            result = result .. '"' .. k .. '":' .. json.encode(v)
            first = false
        end
        result = result .. "}"
        return result
    end
    return "null"
end

-- Simple string to table conversion (very basic)
function json.decode(str)
    -- This is a very simple implementation
    -- In practice, you'd want a proper JSON parser
    return {}
end

return json