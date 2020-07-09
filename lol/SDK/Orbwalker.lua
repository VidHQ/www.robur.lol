-- clean.module("Orbwalker", clean.seeall, log.setup)
require("common.log")
module("lol", package.seeall, log.setup)

require("common.cave")
require("common.event")
require("utils")

winapi = require("utils.winapi")


local Enums = require 'lol/SDK/Enumerations'
local Events = Enums.Events
local OrbwalkerModes = Enums.OrbwalkerModes
local AutoAttackResets = Enums.AutoAttackResets
local DashAutoAttackResets = Enums.DashAutoAttackResets
local LocalPlayer
local PlayerControl

-- local PlayerControl = require("lol.lol_player")


local Orbwalker = {}

Orbwalker.Mode = OrbwalkerModes.None
Orbwalker.LastAATick = 0


local minMoveDistance = 4225 --65*65
local isMelee = false;

local autoAttackStarted = false
local autoAttackCompleted = false

local function getMouseWorldPosition()
	local hud = ffi.cast("hud_t**", _G.SDK.Offsets.HudInstance)[0]
	local x = tonumber(hud.clickmanager.x)
	local y = tonumber(hud.clickmanager.y)
	local z = tonumber(hud.clickmanager.z)
	return x,y,z
end

local function CanMove()
    -- INFO("can move ? last aa tick %d. Next MOVE: %d, can Move ? %s", Orbwalker.LastAATick, Orbwalker.LastAATick + LocalPlayer:AttackCastDelay() * 1000, _G.SDK.TickCount() > Orbwalker.LastAATick + LocalPlayer:AttackCastDelay() * 1000)
    return _G.SDK.TickCount() > Orbwalker.LastAATick + LocalPlayer:AttackCastDelay() * 1000
end

local function CanAttack()
    -- if _G.SDK.LocalPlayer:HasBuff("JhinPassiveReload") or _G.SDK.LocalPlayer:HasBuff("jhinpassivereload") then
    --     return false
    -- end
    -- if autoAttackStarted then return false end;
    -- INFO("can attack ? last aa tick %d. Next: %d, can attack ? %s", Orbwalker.LastAATick, Orbwalker.LastAATick + LocalPlayer:AttackDelay() * 1000, _G.SDK.TickCount() > Orbwalker.LastAATick + LocalPlayer:AttackDelay() * 1000)
    -- if _G.SDK.LocalPlayer:ChampionName() == "Graves" then
    --     local attackDelay = 1.0740296828 * 1000 * _G.SDK.LocalPlayer:AttackDelay() - 716.2381256175

    --     if _G.SDK.TickCount() >= Orbwalker.LastAATick + attackDelay and (_G.SDK.LocalPlayer:HasBuff("GravesBasicAttackAmmo1") or _G.SDK.LocalPlayer:HasBuff("gravesbasicattackammo1"))  then
    --         return true
    --     end

    --     return false
    -- end
   return _G.SDK.TickCount() > Orbwalker.LastAATick + LocalPlayer:AttackDelay() * 1000
end

local function getDistanceSqrtVec(playerx, playerz, toX, toZ)
	local dx = playerx - toX
	local dz = playerz - toZ
	return (dx * dx) + (dz * dz)
end

local function Move()
    -- INFO("in move")
    local x,y,z = getMouseWorldPosition()
    -- INFO("%d, %d, %d", x,y,z)
    if getDistanceSqrtVec(LocalPlayer:Position().x, LocalPlayer:Position().z, x, z) >= minMoveDistance then
        local toPos = ffi.new("Vector[1]")[0]
        toPos.x = x
        toPos.y = y
        toPos.z = z
        -- INFO("try to move")
        PlayerControl.MoveTo(toPos)
        -- INFO("after move")
    end
end

local function FirePreAutoAttackEvent()
    _G.SDK.EventHandler.FireEvent(Events.BeforeAutoAttack)
end

local function triggerOnAutoAttackEvent()
    _G.SDK.EventHandler.FireEvent(Events.OnAutoAttack)
end

local function triggerPostAutoAttackEvent()
    _G.SDK.EventHandler.FireEvent(Events.PostAutoAttack)
end

local function ResetAutoAttack()
    _G.SDK.Orbwalker.LastAATick = 0
end

local function Attack(target)
    -- INFO("attacked")
    FirePreAutoAttackEvent()
    PlayerControl.AttackTarget(target.Object)
    -- autoAttackStarted = true
end

local function onProcessSpell(sender, spellInfo)
    -- INFO("onProcessSpell: Sender NetworkID: %d", sender.Object.networkId)
    -- INFO("onProcessSpell: Player NetowrkID: %d", LocalPlayer.Object.networkId)
    -- INFO("onProcessSpell (%f): Player 0x%x", _G.SDK.GameTime(), ptrtonumber(LocalPlayer.Object))
    if sender:IsMe() then
        if spellInfo:IsAutoattack() then
            Orbwalker.LastAATick = _G.SDK.TickCount() - _G.SDK.Ping()
            -- INFO("last aa tick is %d or %d", Orbwalker.LastAATick, _G.SDK.TickCount() - _G.SDK.Ping())
            autoAttackStarted = false
            triggerOnAutoAttackEvent()
            delay(LocalPlayer:AttackCastDelay() * 1000, triggerPostAutoAttackEvent)
        else
            local key = string.format("%s_%d", sender:ChampionName(), spellInfo:Slot())
            if AutoAttackResets[key] or DashAutoAttackResets[key] then
                ResetAutoAttack()
            end
        end
    end
end

local function onIssueOrder(order, bla, blub)
    if order == 3 then
        -- Orbwalker.LastAATick =  _G.SDK.TickCount() + _G.SDK.Ping()
        -- INFO("last aa tick set %d", Orbwalker.LastAATick)
    end
end

local function onAutoAttack()
    -- triggerInAutoAttackEvent()
    -- autoAttackStarted = true
    -- delay(30, triggerPostAutoAttackEvent
end

local function missleCreated(obj)
    -- local ptr = ptrtonumber(obj);
    -- INFO("missle ptr: 0x%x", ptr)
    -- INFO("%d, %d, %d", tonumber(obj.isAutoAttack), tonumber(obj.sourceId), _G.env.getPlayer().id)
    -- INFO("%s", _G.env.getString(obj.name))
    if obj.sourceId == _G.env.getPlayer().id and obj.isAutoAttack then
        autoAttackCompleted = true
        triggerPostAutoAttackEvent()
    end
end

local function onStopCast(spellBook, sender)
    if sender:IsMe() then
        INFO("AUTOCAST STOPPED")
        ResetAutoAttack();
        autoAttackStarted = false
    end
end

Orbwalker.Orbwalk = function(target)
    local aiman = _G.SDK.Internals.GetAIManager(_G.SDK.LocalPlayer.Object)
    if aiman.isDashing4 and aiman.isMoving then return end
    -- if autoAttackStarted and not autoAttackCompleted then return end

    -- if autoAttackStarted and autoAttackCompleted then
    --     autoAttackStarted = false
    --     autoAttackCompleted = false
    -- end

    if target ~= nil and CanAttack() then
        Attack(target)
    elseif CanMove() then
        Move()
    end
end

Orbwalker.Initialize = function ()
    -- _G.SDK.EventHandler.AddEvent(Events.OnCastStop, onStopCast)
    _G.SDK.EventHandler.AddEvent(Events.OnProcessSpell, onProcessSpell)
    -- _G.SDK.EventHandler.AddEvent(Events.OnIssueOrder, onIssueOrder)
    LocalPlayer = _G.SDK.LocalPlayer
    PlayerControl = _G.SDK.Controller
end

return Orbwalker