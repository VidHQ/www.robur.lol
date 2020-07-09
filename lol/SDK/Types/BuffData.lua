BuffData = {}
BuffData.__index = BuffData

setmetatable(
    BuffData,
    {
        __call = function(cls, ...)
            return cls.new(...)
        end
    }
)

BuffData.new = function(obj)
    local self = setmetatable({}, BuffData)

    self.Object = obj

    return self
end

function BuffData:Name() -- ToDo
end

function BuffData:Type() -- ToDo
end

function BuffData:Count() -- ToDo
end

function BuffData:RemainingTime() -- ToDo
end

function BuffData:IsPermanent() -- ToDo
end

function BuffData:Caster() -- ToDo
end