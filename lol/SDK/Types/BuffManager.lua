require "lol/SDK/Types/BuffData"

BuffManager = {}
BuffManager.__index = BuffManager

setmetatable(
    BuffManager,
    {
        __call = function(cls, ...)
            return cls.new(...)
        end
    }
)

BuffManager.new = function(obj)
    local self = setmetatable({}, BuffManager)

    self.Object = obj

    return self
end

function BuffManager:Buffs() -- ToDo
end

function BuffManager:HasBuff(name) -- ToDo
    return false
end

function BuffManager:HasBuffOfType(type) -- ToDo
    return false
end
