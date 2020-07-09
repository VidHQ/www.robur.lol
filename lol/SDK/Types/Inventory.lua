require "lol/SDK/Types/ItemData"

Inventory = {}
Inventory.__index = Inventory

setmetatable(
    Inventory,
    {
        __call = function(cls, ...)
            return cls.new(...)
        end
    }
)

Inventory.new = function(obj)
    local self = setmetatable({}, Inventory)

    self.Object = obj

    return self
end

function Inventory:Item(slot)
    return ItemData() -- ToDo
end


function Inventory:HasItem(id) -- ToDo
end