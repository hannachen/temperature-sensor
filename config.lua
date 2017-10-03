local moduleName = ...
local M = {}
_G[moduleName] = M

local SSID="XXX"
local PASS="XXX"
local IP="0.0.0.0"
local GATEWAY="0.0.0.0"

function M.getSSID()
    return SSID
end

function M.getPASS()
    return PASS
end

function M.getIP()
    return IP
end

function M.getGATEWAY()
    return GATEWAY
end

return M