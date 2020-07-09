require("common.log")
module("lol", package.seeall, log.setup)

_G.robur32 = require("lol.robur32")

require("common.cave")
require("common.event")
require("utils")

Vector3 = {}
Vector3.__index = Vector3

setmetatable(
    Vector3,
    {
        __name = "Vector3",
        __call = function(cls, ...)
            return cls.new(...)
        end
    }
)

local function IsVector3(v)
    return v.x and v.y and v.z
end

Vector3.new = function(x, y, z)
    local self = setmetatable({}, Vector3)

    self.x = x
    self.y = y
    self.z = z

    return self
end

Vector3.__add = function(left, right)
    if IsVector3(left) and IsVector3(right) then
        return Vector3(left.x + right.x, left.y + right.y, left.z + right.z)
    elseif IsVector3(left) and right then
        return Vector3(left.x + right, left.y + right, left.z + right)
    elseif left and IsVector3(right) then
        return Vector3(left + right.x, left + right.y, left + right.z)
    end
end

Vector3.__sub = function(left, right)
    if IsVector3(left) and IsVector3(right) then
        return Vector3(left.x - right.x, left.y - right.y, left.z - right.z)
    elseif IsVector3(left) and right then
        return Vector3(left.x - right, left.y - right, left.z - right)
    elseif left and IsVector3(right) then
        return Vector3(left - right.x, left - right.y, left - right.z)
    end
end

Vector3.__mul = function(left, right)
    if IsVector3(left) and IsVector3(right) then
        return Vector3(left.x * right.x, left.y * right.y, left.z * right.z)
    elseif IsVector3(left) and right then
        return Vector3(left.x * right, left.y * right, left.z * right)
    elseif left and IsVector3(right) then
        return Vector3(left * right.x, left * right.y, left * right.z)
    end
end

Vector3.__div = function(left, right)
    if IsVector3(left) and IsVector3(right) then
        return Vector3(left.x / right.x, left.y / right.y, left.z / right.z)
    elseif IsVector3(left) and right then
        return Vector3(left.x / right, left.y / right, left.z / right)
    elseif left and IsVector3(right) then
        return Vector3(left / right.x, left / right.y, left / right.z)
    end
end

Vector3.__tostring = function(left)
    if not IsVector3(left) then
        return "(0, 0, 0)"
    end
    
    return "(" .. left.x .. ", " .. left.y .. ", " .. left.z .. ")"
end

function Vector3:Length()
    return sqrtl(self.x ^ 2 + self.z ^ 2)
end

function Vector3:LengthSquared()
    return self.x ^ 2 + self.z ^ 2
end

function Vector3:Normalize()
    local length = self:Length()
    self.x = self.x / length
    self.z = self.z / length
end

function Vector3:Normalized()
    local result = Vector3(self.x, self.y, self.z)
    result:Normalize()
    return result
end

function Vector3:Extend(v, distance)
    local normalized = (v - self):Normalized()
    self.x = self.x + distance * normalized.x
    self.z = self.z + distance * normalized.z
end

function Vector3:Extended(v, distance)
    local result = Vector3(self.x, self.y, self.z)
    result:Extend(v, distance)
    return result
end

function Vector3:Distance(v)
    local x = self.x - v.x
    local z = self.z - v.z
    return sqrtl(x ^ 2 + z ^ 2)
end

function Vector3:DistanceSquared(vec)
    local x = self.x - vec.x
    local z = self.z - vec.z
    return x ^ 2 + z ^ 2
end

function Vector3:IsInRange(v, range)
    return self:DistanceSquared(v) < range ^ 2
end
