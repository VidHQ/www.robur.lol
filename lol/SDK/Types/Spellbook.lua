require "lol/SDK/Types/SpellData"

Spellbook = {}
Spellbook.__index = Spellbook

setmetatable(
    Spellbook,
    {
        __call = function(cls, ...)
            return cls.new(...)
        end
    }
)

Spellbook.new = function(obj)
    local self = setmetatable({}, Spellbook)

    self.Object = obj

    return self
end

function Spellbook:ActiveSpellSlot() -- ToDo
end

function Spellbook:Spell(slot)
    return SpellData() -- ToDo
end
