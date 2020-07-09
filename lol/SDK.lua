require("common.log")
module("lol", package.seeall, log.setup)

require("common.cave")
require("common.event")
require("utils")

winapi = require("utils.winapi")

require("lol/SDK/Types/GameObject")

local SDK = {}

SDK.Offsets = require "lol/SDK/Offsets"
SDK.Debug = require "lol/SDK/Debug"
SDK.Internals = require "lol/SDK/Internals"
SDK.Enumerations = require "lol/SDK/Enumerations"
SDK.EventHandler = require "lol/SDK/EventHandler"
SDK.ObjectManager = require "lol/SDK/ObjectManager"
SDK.Controller = require "lol/SDK/Controller"
SDK.TargetSelector = require "lol/SDK/TargetSelector"
SDK.Orbwalker = require "lol/SDK/Orbwalker"


local AlreadyInitialized = false
SDK.Initialize = function()
    if AlreadyInitialized then
        return
    end

    SDK.LocalPlayer = GameObject(ffi.cast("gameobject_t**", SDK.Offsets.LocalPlayer)[0])
    SDK.Controller.Initialize()
    local toPos = SDK.LocalPlayer.Object.position
    toPos.x = toPos.x + 100.0
    toPos.z = toPos.z + 100.0
    SDK.Controller.MoveTo(toPos)

    SDK.EventHandler.Initialize()
    SDK.ObjectManager.Initialize()
    SDK.TargetSelector.Initialize()
    SDK.Orbwalker.Initialize()

    AlreadyInitialized = true
    INFO("SDK Initialized")
end

SDK.GameTime = function()
    return tonumber(ffi.cast("float*", SDK.Offsets.GameTime)[0])
end

SDK.TickCount = function()
    return winapi.getTickCount()
end

SDK.Ping = function()
    return SDK.Internals.GetPing()
end

SDK.PrintChat = function(text)
    asmcall.fastcall(SDK.Offsets.PrintChat, {eax = 0, ecx = SDK.Offsets.ChatPtr}, text, 0)
end

return SDK
