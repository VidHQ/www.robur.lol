require("utils.clean")
require("common.log")
clean.module("player", clean.seeall, log.setup)

_G.local_player = ffi.cast("localplayer_t**", _G.SDK.Offsets.LocalPlayer)[0]

function moveTo(vector)
	if _G.local_player ~= nil then
		local current_poop = tonumber(utils.readUInt32(_G.SDK.Offsets.IssueSock, 0))
		utils.writeUInt32(0x13, _G.SDK.Offsets.IssueSock, 0)
		asmcall.fastcall(_G.SDK.Offsets.IssueOrder, {eax = 0, ecx = _G.local_player, ret = _G.SDK.Offsets.randomRET}, 2, vector, 0, 0, 0xffffff00, 0)
		utils.writeUInt32(current_poop, _G.SDK.Offsets.IssueSock, 0)
	end
end

function attackTarget(object)
	if _G.local_player ~= nil then
		local current_poop = tonumber(utils.readUInt32(_G.SDK.Offsets.IssueSock, 0))
		local vector = object.position
		utils.writeUInt32(0x14, _G.SDK.Offsets.IssueSock, 0)
		asmcall.fastcall(_G.SDK.Offsets.IssueOrder, {eax = 0, ecx = _G.local_player, ret = _G.SDK.Offsets.randomRET}, 3, vector, object, 0, 0xffffff00, 0)
		utils.writeUInt32(current_poop, _G.SDK.Offsets.IssueSock, 0)
	end
end

return _M
