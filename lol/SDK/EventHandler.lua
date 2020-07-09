require("common.log")
module("lol", package.seeall, log.setup)

require("common.cave")
require("common.event")
require("utils")

winapi = require("utils.winapi")

local Enumerations = require "lol/SDK/Enumerations"
local Events = Enumerations.Events
local Team = Enumerations.Team
local WindowMessages = Enumerations.WindowMessages

require "lol/SDK/Types/GameObject"
require "lol/SDK/Types/Vector3"
require "lol/SDK/Types/SpellCastInfo"

local Callbacks = {
    [Events.OnTick] = {},
    [Events.OnStep] = {},
    [Events.OnKey] = {},
    [Events.OnKeyDown] = {},
    [Events.OnKeyUp] = {},
    [Events.OnCreateObject] = {},
    [Events.OnDeleteObject] = {},
    [Events.OnProcessSpell] = {},
    [Events.OnIssueOrder] = {},
    [Events.PostAutoAttack] = {},
    [Events.BeforeAutoAttack] = {},
    [Events.OnAutoAttack] = {},
    [Events.OnCastStop] = {}
}

local function OnTick()
    local funcs = Callbacks[Events.OnTick]

    for i = 1, #funcs do
        funcs[i]()
    end
end

local function OnStep()
    local funcs = Callbacks[Events.OnStep]

    for i = 1, #funcs do
        funcs[i]()
    end
end

local function OnKey(e)
    local funcs = Callbacks[Events.OnKey]

    for i = 1, #funcs do
        funcs[i](e)
    end
end

local function OnKeyDown(e)
    local funcs = Callbacks[Events.OnKeyDown]

    for i = 1, #funcs do
        funcs[i](e)
    end
end

local function OnKeyUp(e)
    local funcs = Callbacks[Events.OnKeyUp]

    for i = 1, #funcs do
        funcs[i](e)
    end
end

local function OnCreateObject(context)
    local funcs = Callbacks[Events.OnCreateObject]

    local objPtr = context.reg32.ecx
    local obj = ffi.cast("gameobject_t*", objPtr)
    local networkId = tonumber(context:getArg(1, "uint32_t"))
    local team = tonumber(obj.team)

    if team == Team.Order or team == Team.Chaos or team == Team.Neutral then
        for i = 1, #funcs do
            funcs[i](GameObject(obj), networkId)
        end
    end
end

local function OnDeleteObject(context)
    local funcs = Callbacks[Events.OnDeleteObject]

    local obj = context:getArg(1, "gameobject_t*")
    local team = tonumber(obj.team)

    if team == Team.Order or team == Team.Chaos or team == Team.Neutral then
        for i = 1, #funcs do
            funcs[i](GameObject(obj))
        end
    end
end

local function OnProcessSpell(context)
    local funcs = Callbacks[Events.OnProcessSpell]

    local dis = context.reg32.ecx
    local spellInfo = SpellCastInfo(context:getArg(1, "spellInfo_t*")[0])
    local sender = GameObject(ffi.cast("gameobject_t*", dis - 0x2AF0))

    for i = 1, #funcs do
        funcs[i](sender, spellInfo)
    end
end

local function OnIssueOrder(context)
    local funcs = Callbacks[Events.OnIssueOrder]

    local order = tonumber(context:getArg(1, "uint32_t"))
    local pos = context:getArg(2, "Vector*")[0]
    local targetObj = context:getArg(3, "gameobject_t*")[0]

    for i = 1, #funcs do
        funcs[i](order, Vector3(pos.x, pos.y, pos.z), GameObject(targetObj))
    end
end

local function OnCastStop(context)
    local funcs = Callbacks[Events.OnCastStop]

    local spellbook = tonumber(context.reg32.ecx) -- todo
    local sender = GameObject(ffi.cast("gameobject_t*", spellbook - 0x2AF0))

    for i = 1, #funcs do
        funcs[i](spellbook, sender)
    end
end

local function FireEvent(event, ...)
    local funcs = Callbacks[event]
    for i = 1, #funcs do
        funcs[i](...)
    end
end

local EventHandler = {}

local function AddEvent(event, func)
    Callbacks[event][#Callbacks[event] + 1] = func
end

local function RemoveEvent(event, func)
    for i = 1, #Callbacks[event] do
        if Callbacks[event][i] == func then
            Callbacks[event][i] = nil
        end
    end
end

local function OnGetPing(context)
    local dis = context.reg32.ecx
    INFO("hook ping 0x%x", ptrtonumber(dis))
end

local function OnGetSpellState(context)
    local dis = context.reg32.ecx
    INFO("get spellstate 0x%x", ptrtonumber(dis))
end

local function getVectorString(vector)
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

function OnSetCharacterModel(context)
    local champName = context:getArg(1, "string_t*")
    if Internals.GetString(champName) == _G.SDK.LocalPlayer:ChampionName() then
        context:setArg (2, 21)
    end
end

local function OnGetHpBarPos(context)
	local dis = context.reg32.ecx
	local idk = context:getArg(1, "Vector*")
    INFO("0x%x", ptrtonumber(dis))
end

local function hook_castspell(context)
	local spellbook = context.reg32.ecx
	local slot = context:getArg(1, "uint32_t")
	local id = context:getArg(2, "uint32_t")
	local targetPos = context:getArg(3, "Vector*")
	local startPos = context:getArg(4, "Vector*")
	local NetworkID = context:getArg(5, "uint32_t")
	INFO("CastSpell(0x%x|0x%x|0x%x|(%s)|(%s)|0x%x", tonumber(spellbook), tonumber(slot), tonumber(id), getVectorString(targetPos), getVectorString(startPos), tonumber(NetworkID))
end


local function OnGetBasicAttack(context)
	local disObj = context.reg32.ecx
    local idk = context:getArg(1, "uint32_t")
    local go = GameObject(ffi.cast("gameobject_t*", disObj))
	INFO("On Basic Attack: 0x%x, %d, %s", ptrtonumber(disObj), tonumber(idk), go:Name())
end



local function Initialize()
    -- timer(1, OnTick)
    timer(20, OnStep)

    -- window proc events
    register(
        event.USERINPUT,
        function(e)
            LASTEVENT = e

            if e.message >= WindowMessages.KEY_FIRST and e.message <= WindowMessages.KEY_LAST then
                OnKey(e)

                if (e.message == WindowMessages.KEYDOWN) or (e.message == WindowMessages.SYSKEYDOWN) then
                    OnKeyDown(
                        {
                            e = e,
                            keycode = e.wparam,
                            char = string.char(e.wparam),
                            lparam = string.format("%.08X", e.lparam)
                        }
                    )
                end
                if (e.message == WindowMessages.KEYUP) or (e.message == WindowMessages.SYSKEYUP) then
                    OnKeyUp(
                        {
                            e = e,
                            keycode = e.wparam,
                            char = string.char(e.wparam),
                            lparam = string.format("%.08X", e.lparam)
                        }
                    )
                end
            end
        end
    )

    -- game hooks
    cave.intercept_pre("CreateObj", _G.SDK.Offsets.OnCreateObject, OnCreateObject)
    cave.intercept_pre("DeleteObj", _G.SDK.Offsets.OnDeleteObject, OnDeleteObject)
    cave.intercept_pre("ProcessSpell", _G.SDK.Offsets.OnProcessSpell, OnProcessSpell)
    cave.intercept_pre("CastStop", _G.SDK.Offsets.OnCastStop, OnCastStop)
    -- cave.intercept_pre("SetCharacterModel", _G.SDK.Offsets.SetCharacterModel, OnSetCharacterModel)

    -- cave.intercept_pre("GetHPBarPos", _G.SDK.Offsets.GetHpBarPos, OnGetHpBarPos)

    -- cave.intercept_pre("GetBasicAttack", _G.SDK.Offsets.GetBasicAttack, OnGetBasicAttack)
    -- cave.intercept_pre("IssueOrder", _G.SDK.Offsets.IssueOrder, OnIssueOrder)
    -- cave.intercept_pre("GetSpellState", _G.SDK.Offsets.GetSpellState, OnGetSpellState)
    -- cave.intercept_pre("GetPing", _G.SDK.Offsets.GetPing, OnGetPing)
    -- cave.intercept_pre("CastSpell", _G.SDK.Offsets.CastSpell, hook_castspell)


    INFO("EventHandler Initialized")
end

return {
    AddEvent = AddEvent,
    RemoveEvent = RemoveEvent,
    FireEvent = FireEvent,
    Initialize = Initialize
}
