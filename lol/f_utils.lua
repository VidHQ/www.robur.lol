
clean.module("lol.f_utils", clean.seeall, log.setup)


OrbwalkerModes = { None = 0, Combo = 1, LastHit = 2, WaveClear = 3 }

function isOnMyTeam(object)
	local player_team = tonumber(_G.env.getPlayer().team)
	local object_team = tonumber(object.team)
    return player_team == object_team
end

function MoveToMouse()
    local x,y,z = _G.env.getMouseWorldPosition()
    local vector = ffi.new("Vector[1]")[0]
    vector.x = x
    vector.y = y
    vector.z = z
    _G.player.moveTo(vector)
end

function Attack(object)
    _G.player.attackTarget(object)
end

function getDistanceSqrt(object1, object2)
	local o1_x, o1_y, o1_z = _G.env.getPos(object1)
	local o2_x, o2_y, o2_z = _G.env.getPos(object2)
	local dx = o1_x - o2_x
	local dz = o1_z - o2_z
	return (dx * dx) + (dz * dz)
end

function getDistanceSqrtVec(vector1, vector2)
	local dx = vector1.x - vector2.x
	local dz = vector1.z - vector2.z
	return (dx * dx) + (dz * dz)
end

function isInAttackRange(playerObj, enemyObj)
    local distSqrd = getDistanceSqrt(playerObj, enemyObj)
    local playerFat =_G.env.getBoundingRadius(playerObj)
    local enemyFat =_G.env.getBoundingRadius(enemyObj)
    local playerRange = tonumber(playerObj.attackRange)
    local everything = playerFat + enemyFat + playerRange
    return distSqrd <= everything * everything
end

return _M