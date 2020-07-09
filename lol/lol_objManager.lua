
f_utils = require("lol.f_utils")

clean.module("lol_objManager", clean.seeall, log.setup)

enemyMinions = {}
enemyHeroes = {}


function init()
	local object_manager = ffi.cast("objectmanager_t**", _G.lol_ObjectManager)[0]
	local i = 0
	while true do
		local object = object_manager.objects[i]
		if object ~= nil then
			local number = ptrtonumber(object)
			if number == 1 or number == 0 then
				break
			end
			local netId = tonumber(object.networkId)
			local team = tonumber(object.team)
			if netId ~= 0 and (team == 100 or team == 200 or team == 300) then
				handleNewObj(object, netId)
			end
		end
		i = i + 1
	end
	INFO("lol_objManager init done")
end


function  handleNewObj(obj, networkId)
	local team = obj.team;
	if (team == 100 or team == 200 or team == 300) and _G.env.isMissile(obj) then
		local missile = ffi.cast("missile_t*", ptrtonumber(obj))
		_G.Orbwalker.missleCreated(missile)
	elseif not f_utils.isOnMyTeam(obj) then
		if _G.env.isHero(obj)  then
			enemyHeroes[networkId] = obj
		elseif _G.env.isMinion(obj) then
			enemyMinions[networkId] = obj
		end
	end
end

function handleDeletedObj(obj)
	local networkId = tonumber(obj.networkId)
	if _G.env.isHero(obj)  then
		enemyHeroes[networkId] = nil
	elseif _G.env.isMinion(obj) then
		enemyMinions[networkId] = nil
	end
end

-- for debug
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

return _M