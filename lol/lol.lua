require("common.log")
module("lol", package.seeall, log.setup)

_G.robur32 = require("lol.robur32")

require("common.cave")
require("common.event")
require("utils")

nk = require("lol.nuklear")

winapi = require("utils.winapi")
require("common.remote")

require("lol.lol_cdefs")

local AllSkinNames = require "lol/SDK/StaticData/SkinNames"

function getVectorString(vector)
	if vector ~= nil then
		local x = tonumber(vector.x)
		local y = tonumber(vector.y)
		local z = tonumber(vector.z)
		local result = string.format("%f|%f|%f", x, y, z)
		return result
	else
		return nil
	end
end

_G.SDK = require "lol/SDK"

local Enums = require "lol/SDK/Enumerations"
local Events = Enums.Events
local OrbwalkerModes = Enums.OrbwalkerModes
local SPACE_ACTIVE = false

function printChat(text)
	if chat_ptr ~= nil then
		asmcall.fastcall(_G.lol_PrintChat, {eax = 0, ecx = chat_ptr}, text, 0);
	end
end


function anti_afk(e)
	local player = _G.SDK.LocalPlayer.Object
	_G.SDK.Controller.MoveTo(player.position)
end

function processTermination()
	remote.close()
end

function _G.antiAfk(activate)
	if activate then
		INFO("Activating anti afk")
		timer(1000, anti_afk)
	else
		INFO("Deactivating anti afk")
		unregister(anti_afk)
	end
end

afk_flag = 0

SkinId = 0
Skins = {}
SkinCount = 0

function lol_widget(ctx)
	local flags = bit.bor(nk.NK_WINDOW_BORDER, nk.NK_WINDOW_MOVABLE, nk.NK_WINDOW_SCALABLE, nk.NK_WINDOW_MINIMIZABLE, nk.NK_WINDOW_TITLE)
	if nk_begin_C (ctx, "www.robur.lol", 50, 50, 360, 280, flags) then
		--nk_layout_row_dynamic_C (ctx, 30, 1)
		-- nk_layout_row_static_C (ctx, 30, 300, 1)
		-- if nk_button_label_C (ctx, "button") == 1 then
		-- 	INFO("button")
		-- end
		nk_layout_row_dynamic_C (ctx, 30, 2)
		if nk_option_label_C (ctx, "Anti AFK", afk_flag) == 1 then
			if afk_flag == 0 then
				_G.antiAfk (true)
				afk_flag = 1
			end
		else
			if afk_flag == 1 then
				_G.antiAfk (false)
				afk_flag = 0
			end
		end
		nk_layout_row_static_C (ctx, 30, 335, 1)
		local index = nk_property_int_C (ctx, Skins[SkinId], 0, SkinId, SkinCount, 1, 5.0)
		if index ~= SkinId then
			SkinId = index
			INFO("Applying SkinId %d", SkinId)
			SetCharacterSkin(SkinId)
		end

	end
	nk_end_C (ctx)
end

function drawCircle3D(buffer, vPos, points, radius, color, thickness)
	local flPoint = 3.14159265359 * 2.0 / points
	flAngle = 0
	for flAngle = 0, (3.14159265359 * 2.0), flPoint
	do
		local start = ffi.new("Vector[1]")[0]
		start.x = radius * math.cos(flAngle) + vPos.x
		start.y = vPos.y
		start.z = radius * math.sin(flAngle) + vPos.z

		local vEnd = ffi.new("Vector[1]")[0]
		vEnd.x = radius * math.cos(flAngle + flPoint) + vPos.x
		vEnd.y = vPos.y
		vEnd.z = radius * math.sin(flAngle + flPoint) + vPos.z

		local toStart = ffi.new("Vector[1]")[0]
		local toEnd = ffi.new("Vector[1]")[0]
		if asmcall.cdecl(_G.SDK.Offsets.WorldToScreen, start, toStart) and  asmcall.cdecl(_G.SDK.Offsets.WorldToScreen, vEnd, toEnd) then
			nk_stroke_line_C(buffer, toStart.x, toStart.y, toEnd.x, toEnd.y, thickness, color)
		end
	end
end

function drawLineFromTo(buffer, v1, v2, color)
	local toStart = ffi.new("Vector[1]")[0]
	local toEnd = ffi.new("Vector[1]")[0]
	asmcall.cdecl(_G.SDK.Offsets.WorldToScreen, v1, toStart)
	asmcall.cdecl(_G.SDK.Offsets.WorldToScreen, v2, toEnd)
	nk_stroke_line_C(buffer, toStart.x, toStart.y, toEnd.x, toEnd.y, 1.0, color)
end


function lol_overlay(buffer)
	local pos = _G.SDK.LocalPlayer.Object.position
	local localPlayerRange = _G.SDK.LocalPlayer:TrueAttackRange()
	drawCircle3D(buffer, pos, 100.0, localPlayerRange, 0x00ff00ff, 1.0)

	local turrets = _G.SDK.ObjectManager.EnemyTurrets
	for networkId, turret in pairs(turrets) do
		if _G.SDK.LocalPlayer:DistanceSqrd(turret) <= 1500 ^ 2 then
			local turretPos = turret.Object.position
			local turretRange = 750.0 + turret:BoundingRadius()
			drawCircle3D(buffer, turretPos, 100.0, turretRange, 0xff0000ff, 1.0)
		end
	end
end

function SetCharacterSkin(id)
	asmcall.fastcall(_G.SDK.Offsets.SetCharacterModel, {eax = 0, ecx = ptrtonumber(_G.SDK.LocalPlayer.Object)}, _G.SDK.LocalPlayer.Object.championName, id, 1);
end

local Keys = {
    [" "] = OrbwalkerModes.Combo,
    ["X"] = OrbwalkerModes.WaveClear,
}

local function OnKeyDown(e)
    if Keys[e.char] then
        _G.SDK.Orbwalker.Mode = Keys[e.char]
    end
end

local function OnKeyUp(e)
    if Keys[e.char] then
        _G.SDK.Orbwalker.Mode = OrbwalkerModes.None
    end
end

function Load()
	nk_init_C ()
    remote.init(2337)
    _G.robur32.init()
    _G.SDK.Initialize()

	INFO("Player is playing: %s", _G.SDK.LocalPlayer:ChampionName())

	Skins = AllSkinNames[_G.SDK.LocalPlayer:ChampionName()]
	SkinCount = table.getn(Skins)
	INFO("Skins for %s found: %d", _G.SDK.LocalPlayer:ChampionName(), SkinCount)

	_G.add_widget(lol_widget)
	_G.add_overlay(lol_overlay)

    cave.intercept_pre("TerminateProcess", getProcAddress("ntdll", "NtTerminateProcess"), remote.close)

    _G.SDK.EventHandler.AddEvent(Events.OnStep, function ()
        if _G.SDK.Orbwalker.Mode == OrbwalkerModes.None then return end
		local target
		if _G.SDK.Orbwalker.Mode == OrbwalkerModes.Combo then
			target = _G.SDK.TargetSelector.GetTarget()
		elseif _G.SDK.Orbwalker.Mode == OrbwalkerModes.WaveClear then
			target = _G.SDK.TargetSelector.GetTargetMinion()
		end
        _G.SDK.Orbwalker.Orbwalk(target)
    end)

    _G.SDK.EventHandler.AddEvent(Events.OnKeyDown, OnKeyDown)
    _G.SDK.EventHandler.AddEvent(Events.OnKeyUp, OnKeyUp)
end

Load()