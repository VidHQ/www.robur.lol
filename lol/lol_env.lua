require("utils.clean")
require("common.log")
clean.module("env", clean.seeall, log.setup)

winapi = require("winapi")

function getMouseWorldPosition()
	local hud = ffi.cast("hud_t**", _G.lol_HudInstance)[0]
	local x = tonumber(hud.clickmanager.x)
	local y = tonumber(hud.clickmanager.y)
	local z = tonumber(hud.clickmanager.z)
	return x,y,z
end

function getAttackCastDelay(object)
	asmcall.cdecl(_G.lol_GetAttackCastDelay, object)
	local ret = asmcall_pushfloat_fstp_x87_C()
	return ret
end

function getAttackDelay(object)
	asmcall.cdecl(_G.lol_GetAttackDelay, object)
	local ret = asmcall_pushfloat_fstp_x87_C()
	return ret
end

function isMinion(object)
	local ret = asmcall.cdecl(_G.lol_IsMinion, object)
	if bit.band(ret, 0xf) ~= 0 then
		return true
	else
		return false
	end
end

function isMissile(object)
	local ret = asmcall.cdecl(_G.lol_IsMissile, object)
	if bit.band(ret, 0xf) ~= 0 then
		return true
	else
		return false
	end
end

function isHero(object)
	local ret = asmcall.cdecl(_G.lol_IsHero, object)
	if bit.band(ret, 0xf) ~= 0 then
		return true
	else
		return false
	end
end

function isTargetable(object)
	local ret = asmcall.fastcall(_G.lol_IsTargetable, {eax = 0, ecx = object})
	if bit.band(ret, 0xf) ~= 0 then
		return true
	else
		return false
	end
end

function isEnemy(player, object)
	local player_team = tonumber(player.team)
	local object_team = tonumber(object.team)
	if player_team == 100 and object_team == 200 then
		return true
	elseif player_team == 200 and object_team == 100 then
		return true
	else
		return false
	end
end

function getPos(object)
	if object.position ~= nil then
		x = tonumber(object.position.x)
		y = tonumber(object.position.y)
		z = tonumber(object.position.z)
		return x, y, z
	end
end

function getBoundingRadius(object)
	asmcall.fastcall(_G.lol_GetBoundingRadius, {eax = 0, ecx = object})
	local ret = asmcall_pushfloat_fstp_x87_C()
	return ret
end

function drawCircle(object)
	local color = ffi.new("int[1]", 1)
	color[0] = 0x00ff00

	asmcall.cdecl(_G.lol_DrawCircle, object.position, object.attackRange, color, 0, 0.0, 0, 0.5)
end

function getGameTime()
	local gametime = ffi.cast("float*", _G.lol_GameTime)[0]
	return tonumber(gametime)
end

function getGameTicks()
	return getGameTime() * 1000
end

function getPlayer()
	local player = ffi.cast("gameobject_t*", _G.local_player)
	return player
end

function isInAttackRange(player, object)
	local obj_bound = getBoundingRadius(object)
	local player_bound = getBoundingRadius(player)
	local playerDist = getDistance(player, object)
	local attackRange = tonumber(player.attackRange)
	return playerDist <= attackRange + obj_bound + player_bound
end

function checkTeam(object)
	local team = tonumber(object.team)
	if team == 100 or team == 200 then
		return true
	else
		return false
	end
end

function isAlive(object)
	local ret = asmcall.fastcall(_G.lol_IsAlive, {eax = 0, ecx = object})
	if bit.band(ret, 0xf) ~= 0 then
		return true
	else
		return false
	end
end

function isThing(object)
	local ret = asmcall.cdecl(_G.lol_IsThing, object)
	if bit.band(ret, 0xf) ~= 0 then
		return true
	else
		return false
	end
end

function checkType(object, o_type)
	local eax = tonumber(ffi.cast("uint8_t*", object + 0x58)[0])
	local esi = tonumber(ffi.cast("uint8_t*", object + 0x51)[0])
	local unknown_array = ffi.cast("uint32_t*", object + 0x5c)
	local eax = tonumber(unknown_array[eax])
	if bit.band(eax, o_type) ~= 0 then
		return true
	else
		return false
	end
end

function getString(arg)
	local result = ""
	if arg ~= nil then
		if arg.len <= 15 and arg.len > 0 then
			local ptr = ffi.cast("char*", arg.type.buf)
			result = str(ptr)
		else
			result = str(arg.type.ptr)
		end
	end
	return result
end


function getObjects()
	local object_manager = ffi.cast("objectmanager_t**", _G.lol_ObjectManager)[0]
	local objects = {}
	local player = getPlayer()
	local start = winapi.getTickCount()
	objects.minions = {}
	objects.heroes = {}
	local i = 0
	while true do
		local object = object_manager.objects[i]
		if object ~= nil then
			local number = ptrtonumber(object)
			if number == 1 or number == 0 then
				break
			end
			local team = tonumber(object.team)
			if isEnemy(player, object) or tonumber(object.team) == 300 then
				if isHero(object) and isTargetable(object) then
					INFO("Champion name: %s", getString(object.championName))
					if isInAttackRange(player, object) then
						table.insert(objects.heroes, object)
					end
				elseif isMinion(object) and isTargetable(object) then
					if isInAttackRange(player, object) then
						table.insert(objects.minions, object)
					end
				end
			end
		end
		i = i + 1
	end
	INFO("Found %d minions and %d heroes in %dms", #objects.minions,
		#objects.heroes, winapi.getTickCount() - start)
	return objects
end

function getDistance(object1, object2)
	local o1_x, o1_y, o1_z = getPos(object1)
	local o2_x, o2_y, o2_z = getPos(object2)
	local dx = o1_x - o2_x
	local dy = o1_y - o2_y
	local dz = o1_z - o2_z
	return math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
end

function isOnMyTeam(object)
	local player_team = tonumber(getPlayer().team)
	local object_team = tonumber(object.team)
    return player_team == object_team
end

function MoveToMouse()
    local x,y,z = getMouseWorldPosition()
    local vector = ffi.new("Vector[1]")[0]
    vector.x = x
    vector.y = y
    vector.z = z
    _G.player.moveTo(vector)
end

function WorldToScreen(vectorIn)
	local vectorOut = ffi.new("Vector[1]")[0]
	asmcall.cdecl(_G.lol_WorldToScreen, vectorIn, vectorOut)
	return vectorOut
end

function Attack(object)
    _G.player.attackTarget(object)
    _G.Orbwalker.LastAATick = getGameTicks()
end

function getDistanceFast(object1, object2)
	local o1_x, o1_y, o1_z = getPos(object1)
	local o2_x, o2_y, o2_z = getPos(object2)
	local dx = o1_x - o2_x
	local dz = o1_z - o2_z
	return (dx * dx) + (dz * dz)
end

return _M
