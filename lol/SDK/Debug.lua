require("common.log")
module("lol", package.seeall, log.setup)

local Internals = require 'lol/SDK/Internals'

local Debug = {}


Debug.getVectorString =  function (vector)
	if vector ~= nil then
		local x = tonumber(vector.x)
		local y = tonumber(vector.y)
		local z = tonumber(vector.z)
		local result = string.format("%f | %f | %f", x, y, z)
		return result
	else
		return nil
	end
end

local function getString(arg)
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

local function GetObjectTypeName(object)
	if object == nil then
		return 0;
    end

    local v1 = object
    local v2 = 0
    local v3 = 	tonumber(ffi.cast("uint8_t*", ptrtonumber(object) + 5)[0])
    -- if v3 > 1 then
    --     INFO("v3 is %d", v3)
    -- end
    local temp1 = tonumber(ffi.cast("uint8_t*", ptrtonumber(object) + 12)[0])
	local temp2 = 4 * temp1 + 16
    local a1 =  ptrtonumber(object) + temp2
	if v3 > 0 then
        local v4 = ptrtonumber(v1) + 8
        -- for i = 0, v3, 1 do
            local v5 = 	tonumber(ffi.cast("uint32_t*", v4)[0])
            v4 = v4 + 1
            a1 = ptrtonumber(a1) + v2
            a1 = tonumber(ffi.cast("uint32_t*", a1)[0])
            a1 = bit.bxor(a1, bit.bnot(v5))
        -- end
    end

    -- local v6 = 	tonumber(ffi.cast("uint8_t*", ptrtonumber(object) + 6)[0])
    -- if v6 > 0 then
    --     INFO("v6 is %d", v6)
    -- end
	-- if v6 > 0 then
	-- 	local v7 = 4 - v6
	-- 	if v7 < 4 then
	-- 		local v8 = ptrtonumber(ffi.cast("char*", v7 + v1 + 8)[0])
	-- 		repeat
	-- 			local v9 = ffi.cast("char", v8)
	-- 			v8 = v8 + 4
	-- 			a1 = tonumber(ffi.cast("uint8_t*", a1+v7)[0])
	-- 			a1 = bit.bxor(a1, bit.bnot(v9))
	-- 			v7 = v7 + 1
	-- 		until(v7 < 4)
	-- 	end
    -- end
    
	return ptrtonumber(a1)
end

Debug.GetObjectTypeName = function ()
	local minions = _G.SDK.ObjectManager.Objects

	for networkId, minion in pairs(minions) do
		local adress = GetObjectTypeName(minion.Object)
		-- local ptr = ffi.cast("char*", ptrtonumber(adress)+0x1C)
		-- local result = str(ptr)
		local strrr = ffi.cast("string_t*", ptrtonumber(adress)+0x1C)[0]
		local result = getString(strrr)
		INFO("Object %s, %s, 0x%x", minion:Name(), result, adress)
	end	
end

Debug.PrintGameObjectInformation = function(obj)
	INFO("id %d", obj.id);
	INFO("team %d", obj.team);
	INFO("name %s", getString(obj.name));
	INFO("networkId %d", obj.networkId);
	INFO("position %s", Debug.getVectorString(obj.position));
	INFO("visibility %s", obj.visibility);
	INFO("checkIt %d", obj.checkIt);
	INFO("currentHp %f", obj.currentHp);
	INFO("maxHp %f", obj.maxHp);
	INFO("cooldownReduction %f", obj.cooldownReduction);
	INFO("maxCooldownReduction %f", obj.maxCooldownReduction);
	INFO("tenacity %f", obj.tenacity);
	INFO("magicPen %f", obj.magicPen);
	INFO("ignoreArmorPercent %f", obj.ignoreArmorPercent);
	INFO("ignoreMagicResistPercent %f", obj.ignoreMagicResistPercent);
	INFO("lethality %f", obj.lethality);
	INFO("bonusAd %f", obj.bonusAd);
	INFO("abilityPower %f", obj.abilityPower);
	INFO("baseAd %f", obj.baseAd);
	INFO("totalArmor %f", obj.totalArmor);
	INFO("bonusArmor %f", obj.bonusArmor);
	INFO("totalMR %f", obj.totalMR);
	INFO("bonusMR %f", obj.bonusMR);
	INFO("movementSpeed %f", obj.movementSpeed);
	INFO("attackRange %f", obj.attackRange);
	INFO("combatType %d", obj.combatType);
	INFO("championName %s", getString(obj.championName));
	INFO("level %d", obj.level);
end

Debug.GetString = getString

return Debug
