require("common.log")
module("lol", package.seeall, log.setup)

require("common.cave")
require("common.event")
require("utils")

winapi = require("utils.winapi")

local Internals = {}

Internals.GetString = function(arg)
	local result = ""
	if arg ~= nil then
		if arg.len <= 15 and arg.len > 0 then
			local ptr = ffi.cast("char*", arg.type.buf)
			result = str(ptr)
		else
			result = str(arg.type.ptr)
		end
	end
	return result
end

Internals.GetAIManager = function (object)
	local GetAIManagerFn = ffi.cast("GetAiManager", _G.SDK.Offsets.GetAiManager)
	return GetAIManagerFn(object)
end

Internals.GetPing = function ()
    local GetPingFn = ffi.cast("GetPing", _G.SDK.Offsets.GetPing)
    local dis = ffi.cast("netclient_t**", _G.SDK.Offsets.NetClientPtr)[0];
	return tonumber(GetPingFn(dis))
end

return Internals
