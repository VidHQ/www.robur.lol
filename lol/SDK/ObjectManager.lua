require("common.log")
module("lol", package.seeall, log.setup)

require("common.cave")
require("common.event")
require("utils")

winapi = require("utils.winapi")

local Enumerations = require "lol/SDK/Enumerations"

require "lol/SDK/Types/GameObject"

local Objects = {}

local Heroes = {}
local AllyHeroes = {}
local EnemyHeroes = {}

local Minions = {}
local AllyMinions = {}
local EnemyMinions = {}
local NeutralMinions = {}

local Turrets = {}
local AllyTurrets = {}
local EnemyTurrets = {}

local Inhibitors = {}
local AllyInhibitors = {}
local EnemyInhibitors = {}

local Nexus = {}
local AllyNexus = {}
local EnemyNexus = {}

local Missiles = {}

local function OnCreateObject(object, networkId)
    -- INFO("New object: " .. object:Name())
    Objects[networkId] = object

    if object:IsHero() then
        Heroes[networkId] = object

        if object:IsAlly() then
            AllyHeroes[networkId] = object
        elseif object:IsEnemy() then
            EnemyHeroes[networkId] = object
        end
    elseif object:IsMinion() then
        Minions[networkId] = object

        if object:IsAlly() then
            AllyMinions[networkId] = object
        elseif object:IsEnemy() then
            EnemyMinions[networkId] = object
        elseif object:IsNeutral() then
            NeutralMinions[networkId] = object
        end
    elseif object:IsTurret() then
        Turrets[networkId] = object

        if object:IsAlly() then
            AllyTurrets[networkId] = object
        elseif object:IsEnemy() then
            EnemyTurrets[networkId] = object
        end
    elseif object:IsInhibitor() then
        Inhibitors[networkId] = object

        if object:IsAlly() then
            AllyInhibitors[networkId] = object
        elseif object:IsEnemy() then
            EnemyInhibitors[networkId] = object
        end
    elseif object:IsNexus() then
        Nexus[networkId] = object

        if object:IsAlly() then
            AllyNexus[networkId] = object
        elseif object:IsEnemy() then
            EnemyNexus[networkId] = object
        end
    elseif object:IsMissile() then
        Missiles[networkId] = object
    end
end

local function OnDeleteObject(object)
    local networkId = object:NetworkId()

    Objects[networkId] = nil

    if object:IsHero() then
        Heroes[networkId] = nil

        if object:IsAlly() then
            AllyHeroes[networkId] = nil
        elseif object:IsEnemy() then
            EnemyHeroes[networkId] = nil
        end
    elseif object:IsMinion() then
        Minions[networkId] = nil

        if object:IsAlly() then
            AllyMinions[networkId] = nil
        elseif object:IsEnemy() then
            EnemyMinions[networkId] = nil
        elseif object:IsNeutral() then
            NeutralMinions[networkId] = nil
        end
    elseif object:IsTurret() then
        Turrets[networkId] = nil

        if object:IsAlly() then
            AllyTurrets[networkId] = nil
        elseif object:IsEnemy() then
            EnemyTurrets[networkId] = nil
        end
    elseif object:IsInhibitor() then
        Inhibitors[networkId] = nil

        if object:IsAlly() then
            AllyInhibitors[networkId] = nil
        elseif object:IsEnemy() then
            EnemyInhibitors[networkId] = nil
        end
    elseif object:IsNexus() then
        Nexus[networkId] = nil

        if object:IsAlly() then
            AllyNexus[networkId] = nil
        elseif object:IsEnemy() then
            EnemyNexus[networkId] = nil
        end
    elseif object:IsMissile() then
        Missiles[networkId] = nil
    end
end

local function GetUnderMouseObject() -- ToDo
end

local function GetObjectByNetworkdId(networkId)
    return Objects[networkId]
end

local function GetObjectsByType(type) -- ToDo: Check if this actually works // GameObject:IsType
    local objects = {}

    for networkId, object in pairs(Objects) do
        if object ~= nil and object:IsType(type) then
            objects[object:NetworkId()] = object
        end
    end

    return objects
end

local function Initialize()
    local objectManager = ffi.cast("objectmanager_t**", _G.SDK.Offsets.ObjectManager)[0]
    local i = 0

    while true do
        local object = objectManager.objects[i]

        if object ~= nil then
            local number = ptrtonumber(object)

            if number == 1 or number == 0 then
                break
            end

            if tonumber(object.networkId) ~= 0 then
                local team = tonumber(object.team)

                if team == Enumerations.Team.Order or team == Enumerations.Team.Chaos or team == Enumerations.Team.Neutral then
                    local obj = GameObject(object)
                    OnCreateObject(obj, obj:NetworkId())
                end
            end
        end

        i = i + 1
    end

    _G.SDK.EventHandler.AddEvent(Enumerations.Events.OnCreateObject, OnCreateObject)
    _G.SDK.EventHandler.AddEvent(Enumerations.Events.OnDeleteObject, OnDeleteObject)

    INFO("ObjectManager Initialized")
end

return {
    Initialize = Initialize,
    GetUnderMouseObject = GetUnderMouseObject,
    GetObjectByNetworkdId = GetObjectByNetworkdId,
    GetObjectsByType = GetObjectsByType,
    Objects = Objects,
    Heroes = Heroes,
    AllyHeroes = AllyHeroes,
    EnemyHeroes = EnemyHeroes,
    Minions = Minions,
    AllyMinions = AllyMinions,
    EnemyMinions = EnemyMinions,
    NeutralMinions = NeutralMinions,
    Turrets = Turrets,
    AllyTurrets = AllyTurrets,
    EnemyTurrets = EnemyTurrets,
    Inhibitors = Inhibitors,
    AllyInhibitors = AllyInhibitors,
    EnemyInhibitors = EnemyInhibitors,
    Nexus = Nexus,
    AllyNexus = AllyNexus,
    EnemyNexus = EnemyNexus,
    Missiles = Missiles
}
