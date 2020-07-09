f_utils = require("lol.f_utils")
clean.module("lol_orbwalker", clean.seeall, log.setup)

Mode = f_utils.OrbwalkerModes.None
local LastAATick = 0;
local minMoveDistance = 4225 --65*65
local isMelee = false;

local dashAutoAttackResets = {
    ["Lucian_2"] = true,
    ["Vayne_0"] = true,
}

local autoAttackResets = {
    ["Sivir_1"] = true,
    ["Camille_0"] = true,
}


local autoAttackStarted = false
local autoAttackCompleted = false


function init()
    isMelee = _G.env.getPlayer().attackRange <= 125.0
    _G.register(event.onProcessSpell, onProcessSpell)
    _G.register(event.onIssueOrder, onIssueOrder)
    createEvent("PostAutoAttack")
end

function orbwalk(target)
    local aiman = _G.env.getAIManager(_G.env.getPlayer())
    if aiman.isDashing4 and aiman.isMoving then return end

    -- if autoAttackStarted and not autoAttackCompleted then return end

    -- if autoAttackStarted and autoAttackCompleted then
    --     autoAttackStarted = false
    --     autoAttackCompleted = false
    -- end

    if target ~= nil and CanAttack() then
        f_utils.Attack(target)
    elseif CanMove() then
        move()
    end
end

function CanMove()
    return _G.env.getGameTicks() > LastAATick + _G.env.getAttackCastDelay(_G.local_player) * 1000
end

function CanAttack()
   return _G.env.getGameTicks() > LastAATick + _G.env.getAttackDelay(_G.local_player) * 1000
end

function move()
    local x,y,z = _G.env.getMouseWorldPosition()
    local toPos = ffi.new("Vector[1]")[0]
    toPos.x = x
    toPos.y = y
    toPos.z = z
    if f_utils.getDistanceSqrtVec(_G.env.getPlayer().position, toPos) >= minMoveDistance then
        _G.player.moveTo(toPos)
    end
end

function triggerPreAutoAttackEvent()
    
end

function triggerInAutoAttackEvent()
    
end

function triggerPostAutoAttackEvent()
    _G.fire(event.PostAutoAttack, "", {})
end

function ResetAutoAttack()
    LastAATick = 0
end

function onProcessSpell(e)
    -- INFO("onProcessSpell: Sender NetworkID: %d", e.sender.networkId)
    -- INFO("onProcessSpell: Player NetowrkID: %d", _G.env.getPlayer().networkId)
    if e.sender.networkId == _G.env.getPlayer().networkId then
        if e.spellInfo.isAutoAttack == 1 and isMelee then
            -- onAutoAttack()
            delay(_G.env.getAttackCastDelay(_G.local_player) * 1000, triggerPostAutoAttackEvent)
        else
            local key = string.format("%s_%d", _G.env.getString(e.sender.championName), e.spellInfo.slotId)
            if autoAttackResets[key] then
                ResetAutoAttack()
            elseif dashAutoAttackResets[key] then
                ResetAutoAttack()
            end
        end
    end
end

function onIssueOrder(e)
    if e.order == 3 then
        LastAATick =  _G.env.getGameTicks() + 30
    end
end

function onAutoAttack()
    -- triggerInAutoAttackEvent()
    -- autoAttackStarted = true
    -- delay(30, triggerPostAutoAttackEvent
end

function missleCreated(obj)
    -- local ptr = ptrtonumber(obj);
    -- INFO("missle ptr: 0x%x", ptr)
    -- INFO("%d, %d, %d", tonumber(obj.isAutoAttack), tonumber(obj.sourceId), _G.env.getPlayer().id)
    -- INFO("%s", _G.env.getString(obj.name))
    if obj.sourceId == _G.env.getPlayer().id and obj.isAutoAttack then
        autoAttackCompleted = true
        triggerPostAutoAttackEvent()
    end
end

return _M