f_utils = require("lol.f_utils")

clean.module("lol_targetselector", clean.seeall, log.setup)

function GetValidObjsInAARange(objTable)
    local playerObj = _G.env.getPlayer()
    local rtn = {}
    for key, value in pairs(objTable) do
        -- and value.visible
        if value ~= nil and _G.env.isAlive(value) and _G.env.isTargetable(value)  and f_utils.isInAttackRange(playerObj, value) then
            table.insert(rtn, value)
        end
    end
    return rtn
end

function CompareToHp(a, b)
    return tonumber(a.hp) < tonumber(b.hp)
end

function CompareToDistance(a, b)
    local playerObj = _G.env.getPlayer()
    local aDist = f_utils.getDistanceSqrt(playerObj, a)
    local bDist = f_utils.getDistanceSqrt(playerObj, b)
    return aDist < bDist
end

function GetLowestHP(objs)
    local objsInRange = GetValidObjsInAARange(objs)
    if table.getn(objsInRange) == 0 then
        return nil
    end
    table.sort(objsInRange, CompareToHp)
    return objsInRange[0] or objsInRange[1]
end

function findTarget(orbwalkerMode)
    if orbwalkerMode == f_utils.OrbwalkerModes.Combo then
        return GetLowestHP(_G.ObjManager.enemyHeroes)
    elseif orbwalkerMode == f_utils.OrbwalkerModes.LastHit then
        return GetLowestHP(_G.ObjManager.enemyMinions)
    elseif orbwalkerMode == f_utils.OrbwalkerModes.WaveClear then
        return GetLowestHP(_G.ObjManager.enemyMinions)
    end

    return nil
end

return _M