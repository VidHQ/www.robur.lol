require "lol/SDK/Types/Vector3"

SpellCastInfo = {}
SpellCastInfo.__index = SpellCastInfo

setmetatable(
    SpellCastInfo,
    {
        __call = function(cls, ...)
            return cls.new(...)
        end
    }
)

SpellCastInfo.new = function(obj)
    local self = setmetatable({}, SpellCastInfo)

    self.Object = obj

    return self
end

function SpellCastInfo:Slot()
    return tonumber(self.Object.slotId)
end

function SpellCastInfo:StartPosition()
    return Vector3(self.Object.fromVec)
end

function SpellCastInfo:EndPosition()
    return Vector3(self.Object.toVec)
end

function SpellCastInfo:IsAutoattack()
    return tonumber(self.Object.isAutoAttack) == 1
end