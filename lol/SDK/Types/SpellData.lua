SpellData = {}
SpellData.__index = SpellData

setmetatable(
    SpellData,
    {
        __call = function(cls, ...)
            return cls.new(...)
        end
    }
)

SpellData.new = function(obj)
    local self = setmetatable({}, SpellData)

    self.Object = obj

    return self
end

function SpellData:Name() -- ToDo
end

function SpellData:Level() -- ToDo
end

function SpellData:ManaCost() -- ToDo
end

function SpellData:Ammo() -- ToDo
end

function SpellData:MaxAmmo() -- ToDo
end

function SpellData:AmmoRechargeTime() -- ToDo
end

function SpellData:AmmoRechargeTimeRemaining() -- ToDo
end

function SpellData:Cooldown() -- ToDo
end

function SpellData:CooldownRemaining() -- ToDo
end

function SpellData:CastRange() -- ToDo
end

function SpellData:CastRadius() -- ToDo
end

function SpellData:Speed() -- ToDo
end

function SpellData:Width() -- ToDo
end
