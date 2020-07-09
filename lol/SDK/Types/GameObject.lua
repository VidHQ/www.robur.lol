require("common.log")
module("lol", package.seeall, log.setup)

_G.robur32 = require("lol.robur32")

require("common.cave")
require("common.event")
require("utils")

local Internals = require "lol/SDK/Internals"
local Enumerations = require "lol/SDK/Enumerations"
local Team = Enumerations.Team

require "lol/SDK/Types/Vector3"
require "lol/SDK/Types/Spellbook"
require "lol/SDK/Types/SpellData"
require "lol/SDK/Types/Inventory"
require "lol/SDK/Types/BuffManager"

GameObject = {}
GameObject.__index = GameObject

setmetatable(
    GameObject,
    {
        __name = "GameObject",
        __call = function(cls, ...)
            return cls.new(...)
        end
    }
)

GameObject.new = function(obj)
    if obj == nil then
        return nil
    end

    local self = setmetatable({}, GameObject)

    self.Object = obj
    self.Spellbook = Spellbook() -- ToDo
    self.BasicAttack = SpellData() -- ToDo
    self.Inventory = Inventory() -- ToDo
    self.BuffManager = BuffManager() -- ToDo

    return self
end

function GameObject:IsMe()
    return self.Object == _G.SDK.LocalPlayer.Object
end

function GameObject:IsAlly()
    return self:Team() == _G.SDK.LocalPlayer:Team()
end

function GameObject:IsEnemy()
    return (self:Team() == Team.Order and _G.SDK.LocalPlayer:Team() == Team.Chaos) or
        (self:Team() == Team.Chaos and _G.SDK.LocalPlayer:Team() == Team.Order)
end

function GameObject:IsAllyTo(object)
    return self:Team() == object:Team()
end

function GameObject:IsEnemyTo(object)
    return (self:Team() == Team.Order and object:Team() == Team.Chaos) or
        (self:Team() == Team.Chaos and object:Team() == Team.Order)
end

function GameObject:IsNeutral()
    return self:Team() == Team.Neutral
end

function GameObject:Distance(to)
    if to.__name == "GameObject" then
        to = to:Position()
    end

    return self:Position().Distance(to)
end

function GameObject:DistanceSqrd(to)
    local pos = to:Position()
    return self:Position():DistanceSquared(pos)
end

function GameObject:HealthBarPosition() -- ToDo
end

function GameObject:ActionState() -- ToDo
end

function GameObject:IsType(type) -- ToDo: Check if this actually works
    local eax = tonumber(ffi.cast("uint8_t*", object + 0x58)[0])
    local esi = tonumber(ffi.cast("uint8_t*", object + 0x51)[0])
    local unknown_array = ffi.cast("uint32_t*", object + 0x5c)
    local eax = tonumber(unknown_array[eax])

    return bit.band(eax, o_type) ~= 0
end

function GameObject:IsHero()
    local ret = asmcall.cdecl(_G.SDK.Offsets.IsHero, self.Object)

    return bit.band(ret, 0xf) ~= 0
end

function GameObject:IsMinion()
    local ret = asmcall.cdecl(_G.SDK.Offsets.IsMinion, self.Object)

    return bit.band(ret, 0xf) ~= 0
end

function GameObject:IsDragon()
    local ret = asmcall.cdecl(_G.SDK.Offsets.IsDragon, self.Object)

    return bit.band(ret, 0xf) ~= 0
end

function GameObject:IsBaron()
    local ret = asmcall.cdecl(_G.SDK.Offsets.IsBaron, self.Object)

    return bit.band(ret, 0xf) ~= 0
end

function GameObject:IsZombie() -- ToDo
end

function GameObject:IsMissile()
    local ret = asmcall.cdecl(_G.SDK.Offsets.IsMissile, self.Object)

    return bit.band(ret, 0xf) ~= 0
end

function GameObject:IsTurret()
    local ret = asmcall.cdecl(_G.SDK.Offsets.IsTurret, self.Object)

    return bit.band(ret, 0xf) ~= 0
end

function GameObject:IsInhibitor()
    local ret = asmcall.cdecl(_G.SDK.Offsets.IsInhibitor, self.Object)

    return bit.band(ret, 0xf) ~= 0
end

function GameObject:IsNexus()
    local ret = asmcall.cdecl(_G.SDK.Offsets.IsNexus, self.Object)

    return bit.band(ret, 0xf) ~= 0
end

function GameObject:IsBuilding()
    local ret = asmcall.cdecl(_G.SDK.Offsets.IsBuilding, self.Object)

    return bit.band(ret, 0xf) ~= 0
end

function GameObject:IsTargetable()
    local ret = asmcall.fastcall(_G.SDK.Offsets.IsTargetable, {eax = 0, ecx = self.Object})

    return bit.band(ret, 0xf) ~= 0
end

function GameObject:IsAlive()
    local ret = asmcall.fastcall(_G.SDK.Offsets.IsAlive, {eax = 0, ecx = self.Object})

    return bit.band(ret, 0xf) ~= 0
end

function GameObject:IsVisible()
    return self.Object.visibility -- ToDo: check if bool or byte
end

function GameObject:IsVisibleOnScreen() -- ToDo
end

function GameObject:Name()
    return Internals.GetString(self.Object.name)
end

function GameObject:ChampionName()
    return Internals.GetString(self.Object.championName)
end

function GameObject:SkinName() -- ToDo
end

function GameObject:Id()
    return tonumber(self.Object.id)
end

function GameObject:CampNumber() -- ToDo
end

function GameObject:NetworkId()
    return tonumber(self.Object.networkId)
end

function GameObject:Team()
    return tonumber(self.Object.team)
end

function GameObject:AttackRange()
    return tonumber(self.Object.attackRange)
end

function GameObject:TrueAttackRange()
    return self:AttackRange() + self:BoundingRadius()
end

function GameObject:Position()
    return Vector3(self.Object.position.x, self.Object.position.y, self.Object.position.z)
end

function GameObject:Direction() -- ToDo
end

function GameObject:Health()
    return tonumber(self.Object.currentHp)
end

function GameObject:MaxHealth()
    return tonumber(self.Object.maxHp)
end

function GameObject:HealthPercent()
    return self:Health() / self:MaxHealth() * 100
end

function GameObject:PhysicalShield() -- ToDo
end

function GameObject:MagicShield() -- ToDo
end

function GameObject:Shield()
    return self:PhysicalShield() + self:MagicShield()
end

function GameObject:Lifesteal()
    return tonumber(self.Object.lifesteal)
end

function GameObject:BaseHealthRegeneration()
    return tonumber(self.Object.baseHpRegen)
end

function GameObject:BonusHealthRegeneration()
    return self:HealthRegeneration() - self:BaseHealthRegeneration() -- ToDo: check if base is modified by * or +
end

function GameObject:HealthRegeneration()
    return tonumber(self.Object.totalHpRegen)
end

function GameObject:Mana() -- ToDo
end

function GameObject:MaxMana() -- ToDo
end

function GameObject:ManaPercent()
    return self:Mana() / self:MaxMana() * 100
end

function GameObject:CombatType()
    return tonumber(self.Object.combatType)
end

function GameObject:IsMelee()
    return self:CombatType() == Enumerations.CombatType.Melee
end

function GameObject:IsRanged()
    return self:CombatType() == Enumerations.CombatType.Ranged
end

function GameObject:Experience()
    return {
        Level = tonumber(self.Object.level),
        Experience = 0, -- ToDo
        ExperienceNeeded = 0 -- ToDo
    }
end

function GameObject:BoundingRadius()
    asmcall.fastcall(_G.SDK.Offsets.GetBoundingRadius, {eax = 0, ecx = self.Object})
    return tonumber(asmcall_pushfloat_fstp_x87_C())
end

function GameObject:AttackDelay()
    asmcall.cdecl(_G.SDK.Offsets.GetAttackDelay, self.Object)
    return tonumber(asmcall_pushfloat_fstp_x87_C())
end

function GameObject:AttackCastDelay()
    asmcall.cdecl(_G.SDK.Offsets.GetAttackCastDelay, self.Object)
    return tonumber(asmcall_pushfloat_fstp_x87_C())
end

function GameObject:MovementSpeed()
    return tonumber(self.Object.movementSpeed)
end

function GameObject:CriticalChance()
    return tonumber(self.Object.crit)
end

function GameObject:BaseAttackDamage()
    return tonumber(self.Object.baseAd)
end

function GameObject:BonusAttackDamage()
    return tonumber(self.Object.bonusAd)
end

function GameObject:AttackDamage()
    return self:BaseAttackDamage() + self:BonusAttackDamage()
end

function GameObject:AbilityPower()
    return tonumber(self.Object.abilityPower)
end

function GameObject:BaseArmor()
    return self:Armor() - self:BonusArmor()
end

function GameObject:BonusArmor()
    return tonumber(self.Object.bonusArmor)
end

function GameObject:Armor()
    return tonumber(self.Object.totalArmor)
end

function GameObject:BaseMagicResist()
    return self:MagicResist() - self:BonusMagicResist()
end

function GameObject:BonusMagicResist()
    return tonumber(self.Object.bonusMR)
end

function GameObject:MagicResist()
    return tonumber(self.Object.totalMR)
end

function GameObject:FlatArmorPenetration()
    return tonumber(self.Object.lethality)
end

function GameObject:PercentArmorPenetration()
    return tonumber(self.Object.ignoreArmorPercent)
end

function GameObject:FlatMagicPenetration()
    return tonumber(self.Object.magicPen)
end

function GameObject:PercentMagicPenetration()
    return tonumber(self.Object.ignoreMagicResistPercent)
end

function GameObject:BaseAttackSpeed()
    return tonumber(self.Object.baseAttackSpeed)
end

function GameObject:AttackSpeedModifier()
    return tonumber(self.Object.bonusAttackSpeed)
end

function GameObject:AttackSpeed()
-- ToDo: Check for active lethal tempo buff (does anything else increase the max attackspeed?)
    return math.min(2.5, self:BaseAttackSpeed() * self:AttackSpeedModifier())
end

function GameObject:Spellbook()
    return self.Spellbook
end

function GameObject:BasicAttack()
    return self.BasicAttack
end

function GameObject:Inventory()
    return self.Inventory
end

function GameObject:BuffManager()
    return self.BuffManager
end

function GameObject:HasBuff(name)
    -- return self.BuffManager:HasBuff(name)
    local objPtr = ptrtonumber(self.Object);
    local begin = tonumber(ffi.cast("uint32_t*", objPtr + 0x2338 + 0x10)[0])
    local ending = tonumber(ffi.cast("uint32_t*", objPtr + 0x2338 + 0x14)[0])
    local current = begin
    local gameTime = _G.SDK.GameTime()

    while current < ending do
        local entry = ffi.cast("buffentry_t**", current)[0]
        if entry ~= nil and ptrtonumber(entry) > 0x1000 and entry.startTime <= gameTime and entry.endTime > gameTime then
            local buffInfo = entry.buffInfo
            local buffname = str(ffi.cast("char*", ptrtonumber(buffInfo) + 0x8))
            if name == buffname then
                return true
            end
            -- local buffName = str(buffInfo.buffName)
            -- INFO("buffname: %s", buffName)
        end
        current = current + 0x8
    end

    return false
end

function GameObject:BuffNames()
    local objPtr = ptrtonumber(self.Object);
    local begin = tonumber(ffi.cast("uint32_t*", objPtr + 0x2338 + 0x10)[0])
    -- INFO("begin: 0x%x", begin)
    local ending = tonumber(ffi.cast("uint32_t*", objPtr + 0x2338 + 0x14)[0])
    local current = begin
    local gameTime = _G.SDK.GameTime()

    local ret = {}

    while current < ending do
        local entry = ffi.cast("buffentry_t**", current)[0]
        if entry ~= nil and ptrtonumber(entry) > 0x1000 and entry.startTime <= gameTime and entry.endTime > gameTime then
            local buffInfo = entry.buffInfo
            local buffname = str(ffi.cast("char*", ptrtonumber(buffInfo) + 0x8))
            -- local buffName = str(buffInfo.buffName)
            -- INFO("buffname: %s", buffName)
            table.insert(ret, buffname)
        end
        current = current + 0x8
    end

    return ret
end