f_utils = require("lol.f_utils")

clean.module("lol_hooks", clean.seeall, log.setup)

function init()
	createEvents()
	initHooks()
end

function getVectorString(vector)
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

function hook_onCreateObj(context)
	local objPtr = context.reg32.ecx
	local obj = ffi.cast("gameobject_t*", objPtr)
	local networkId = tonumber(context:getArg(1, "uint32_t"))
	_G.ObjManager.handleNewObj(obj, networkId)
end

function hook_onDeleteObj(context)
	-- local objMgrPtr = context.reg32.ecx
	local obj = context:getArg(1, "gameobject_t*")
	_G.ObjManager.handleDeletedObj(obj)
end

function hook_castspell(context)
	local spellbook = context.reg32.ecx
	local slot = context:getArg(1, "uint32_t")
	local id = context:getArg(2, "uint32_t")
	local targetPos = context:getArg(3, "Vector*")
	local startPos = context:getArg(4, "Vector*")
	local NetworkID = context:getArg(5, "uint32_t")
	INFO("CastSpell(0x%x|0x%x|0x%x|(%s)|(%s)|0x%x", tonumber(spellbook), tonumber(slot), tonumber(id), getVectorString(targetPos), getVectorString(startPos), tonumber(NetworkID))
end

function hook_onProcessSpell(context)
	local dis = context.reg32.ecx
	local spelldata = context:getArg(1, "spellInfo_t*")[0]
	local eventObj = {
		sender = ffi.cast("gameobject_t*", dis - 0x2AD8),
		spellInfo = spelldata
	}
	_G.fire(event.onProcessSpell, "", eventObj)

	-- local isAutoAttack = ffi.cast("char*", ptrtonumber(spelldata) + 0x4D9)[0];

	-- INFO("onProcessSpell: (0x%x | 0x%x)", ptrtonumber(dis), ptrtonumber(spelldata))
	-- INFO("onProcessSpell: (%d)", tonumber(spelldata.slotId))
	-- INFO("onProcessSpell: (%d)", tonumber(spelldata.isAutoAttack))

	-- sleep(600)
end

function hook_onIssueOrder(context)
	local order = context:getArg(1, "uint32_t")
	local pos = context:getArg(2, "Vector*")[0]
	local target = context:getArg(3, "gameobject_t*")[0]
	local eventObj = {
		order = tonumber(order),
		position = pos,
		target = target
	}
	_G.fire(event.onIssueOrder, "", eventObj)
end

function hook_onCastStop(context)
	local spellbook = context.reg32.ecx
	local eventObj = {
		spellbook = tonumber(spellbook),
		sender = ffi.cast("gameobject_t*", spellbook - 0x2AD8),
	}
	_G.fire(event.onCastStop, "", eventObj)
end

function hook_onAddRemoveBuff(context)
	local idk = context.reg32.ecx
	
	local bh = ffi.cast("buffhost_t*", idk)
	local bi = bh.buffinstance
	-- local buffname = _G.env.getString(bi.buffname)

	-- INFO("BUFF ADDED/REMOVED 0x%x %d %s", ptrtonumber(idk), isActive, buffname)
	INFO("BUFF ADDED/REMOVED 0x%x", ptrtonumber(idk))
	INFO("BUFF ADDED/REMOVED 0x%x", ptrtonumber(bi))
	-- INFO("BUFF ADDED/REMOVED %s", str(buffname))
	-- _G.env.sleep(60000)
end

function createEvents()
	createEvent("onProcessSpell")
	createEvent("onIssueOrder")
	createEvent("onCastStop")
	INFO("Hook-events created.")
end

function initHooks()
	cave.intercept_pre("CreateObj", _G.lol_CreateObject, hook_onCreateObj)
	cave.intercept_pre("DeleteObj", _G.lol_DeleteObject, hook_onDeleteObj)
	-- cave.intercept_pre("CommonAutoAttack", _G.lol_OnCommonAutoAttack, hook_onCommonAutoAttack) -- scheint nicht zu gehen :<
	cave.intercept_pre("ProcessSpell", _G.lol_OnProcessSpell, hook_onProcessSpell)
	cave.intercept_pre("IssueOrder", _G.lol_IssueOrder, hook_onIssueOrder)
	cave.intercept_pre("CastStop", _G.lol_OnCastStop, hook_onCastStop)
	-- cave.intercept_pre("AddRemoveBuff", _G.lol_OnAddRemoveBuff, hook_onAddRemoveBuff)
	-- cave.intercept_pre("CastSpell", _G.lol_CastSpell, hook_castspell)
	INFO("Hooks placed")
end




return _M
