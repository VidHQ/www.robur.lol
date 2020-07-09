require("common.log")
module("lol", package.seeall, log.setup)

require("common.cave")
require("common.event")
require("utils")

winapi = require("utils.winapi")

local Enumerations = require "lol/SDK/Enumerations"
local IssueOrderType = Enumerations.IssueOrderType

local function IssueOrder(type, ...) -- ToDo
end

local function LevelSpell(slot) -- ToDo
end

local function CastSpell(slot, ...) -- ToDo
end

local function Initialize()
    _G.local_player = ffi.cast("localplayer_t**", _G.SDK.Offsets.LocalPlayer)[0]
end

local function MoveTo(vector)
	if _G.local_player ~= nil then
		local current_poop = tonumber(utils.readUInt32(_G.SDK.Offsets.IssueSock, 0))
		utils.writeUInt32(0x13, _G.SDK.Offsets.IssueSock, 0)
		asmcall.fastcall(_G.SDK.Offsets.IssueOrder, {eax = 0, ecx = _G.local_player, ret = _G.SDK.Offsets.randomRET}, 2, vector, 0, 0, 0xffffff00, 0)
		utils.writeUInt32(current_poop, _G.SDK.Offsets.IssueSock, 0)
	end
end

local function AttackTarget(object)
	if _G.local_player ~= nil then
		local current_poop = tonumber(utils.readUInt32(_G.SDK.Offsets.IssueSock, 0))
		local vector = object.position
		utils.writeUInt32(0x14, _G.SDK.Offsets.IssueSock, 0)
		asmcall.fastcall(_G.SDK.Offsets.IssueOrder, {eax = 0, ecx = _G.local_player, ret = _G.SDK.Offsets.randomRET}, 3, vector, object, 0, 0xffffff00, 0)
		utils.writeUInt32(current_poop, _G.SDK.Offsets.IssueSock, 0)
	end
end

return {
    Initialize = Initialize,
    IssueOrder = IssueOrder,
    LevelSpell = LevelSpell,
    CastSpell = CastSpell,
    MoveTo = MoveTo,
    AttackTarget = AttackTarget

}
