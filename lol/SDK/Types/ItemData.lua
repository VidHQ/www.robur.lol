ItemData = {}
ItemData.__index = ItemData

setmetatable(
    ItemData,
    {
        __call = function(cls, ...)
            return cls.new(...)
        end
    }
)

ItemData.new = function(obj)
    local self = setmetatable({}, ItemData)

    self.Object = obj

    return self
end

function ItemData:Name() -- ToDo
end

function ItemData:Id() -- ToDo
end

function ItemData:Stacks() -- ToDo
end

function ItemData:MaxStacks() -- ToDo
end

function ItemData:Range() -- ToDo
end

function ItemData:Cooldown() -- ToDo
end