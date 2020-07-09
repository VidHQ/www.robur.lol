require "lol/SDK/Types/Vector3"

SpellInfo = {}
SpellInfo.__index = SpellInfo

setmetatable(
    SpellInfo,
    {
        __call = function(cls, ...)
            return cls.new(...)
        end
    }
)

SpellInfo.new = function(obj)
    local self = setmetatable({}, SpellInfo)

    self.Object = obj

    return self
end

function SpellInfo:Slot()
    return tonumber(self.Object.slotId)
end

function SpellInfo:StartPosition()
    return Vector3(self.Object.fromVec)
end

function SpellInfo:EndPosition()
    return Vector3(self.Object.toVec)
end

function SpellInfo:IsAutoattack()
    return tonumber(self.Object.isAutoAttack) == 1
end