require("common.log")
module("lol", package.seeall, log.setup)

require("common.cave")
require("common.event")
require("utils")

winapi = require("utils.winapi")

local Enumerations = require "lol/SDK/Enumerations"
local Events = Enumerations.Events
local WindowMessages = Enumerations.WindowMessages

require "lol/SDK/Types/GameObject"
require "lol/SDK/Types/Vector3"
require "lol/SDK/Types/SpellCastInfo"

local SelectedTarget = nil
local Mode = Enumerations.TargetingMode.LowHP

local function IsInvulnerable(target, damageType) -- ToDo
    return false
end

local function GetRealAutoAttackRange(target)
    local result = _G.SDK.LocalPlayer:AttackRange() + _G.SDK.LocalPlayer:BoundingRadius()

    if _G.SDK.LocalPlayer:ChampionName() == "Caitlyn" then
        if target:HasBuff("caitlynyordletrapinternal") then
            result = result + 650
        end
    end

    return result + target:BoundingRadius()
end

local function IsValidTarget(target, range, damageType)
    range = range or GetRealAutoAttackRange(target)
    type = damageType or Enumerations.DamageType.Physical

    return target:IsVisible() and target:IsAlive() and target:IsTargetable() and  _G.SDK.LocalPlayer:DistanceSqrd(target) <= (range ^ 2) and
        not IsInvulnerable(target, type)
end

local function GetTarget(range, damageType)
    local target = nil

    if SelectedTarget ~= nil and IsValidTarget(SelectedTarget, range, damageType) then
        return SelectedTarget
    end

    for networkId, hero in pairs(_G.SDK.ObjectManager.EnemyHeroes) do
        if IsValidTarget(hero, range, damageType) then
            if target == nil then
                target = hero
            end

            if Mode == Enumerations.TargetingMode.Priority then -- ToDo: Add priorities for all heroes
            elseif Mode == Enumerations.TargetingMode.Closest then
                if _G.SDK.LocalPlayer:Distance(hero) < _G.SDK.LocalPlayer:Distance(target) then
                    target = hero
                end
            elseif Mode == Enumerations.TargetingMode.LowHP then
                if hero:Health() < target:Health() then
                    target = hero
                end
            elseif Mode == Enumerations.TargetingMode.MostAD then
                if hero:AttackDamage() > target:AttackDamage() then
                    target = hero
                end
            elseif Mode == Enumerations.TargetingMode.MostAP then
                if hero:AbilityPower() > target:AbilityPower() then
                    target = hero
                end
            elseif Mode == Enumerations.TargetingMode.MostStacks then -- ToDo: Vayne, Gnar [..]
            elseif Mode == Enumerations.TargetingMode.NearMouse then -- ToDo
            end
        end
    end

    return target
end

local function GetTargetMinion(range, damageType)
    local target = nil

    for networkId, minion in pairs(_G.SDK.ObjectManager.NeutralMinions) do
        if IsValidTarget(minion, range, damageType) then
            if target == nil then
                target = minion
            elseif  minion:Health() < target:Health() then
                target = minion
            end
        end
    end

    if target ~= nil then
        return target
    end

    for networkId, minion in pairs(_G.SDK.ObjectManager.EnemyMinions) do
        if IsValidTarget(minion, range, damageType) then
            if target == nil then
                target = minion
            elseif  minion:Health() < target:Health() then
                target = minion
            end
        end
    end

    return target
end

local function Initialize() -- ToDo: Add LeftMouse event to mark a selected target
    INFO("TargetSelector Initialized")
end

return {
    SelectedTarget = SelectedTarget,
    IsInvulnerable = IsInvulnerable,
    GetRealAutoAttackRange = GetRealAutoAttackRange,
    IsValidTarget = IsValidTarget,
    GetTarget = GetTarget,
    GetTargetMinion = GetTargetMinion,
    Initialize = Initialize
}
