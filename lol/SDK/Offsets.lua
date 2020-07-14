-- for version 10.14

winapi = require("winapi")

local Offsets = {}

local modulePtr = ptrtonumber(winapi.getModuleHandle(0))

Offsets.CastSpell = modulePtr + 0x517C00
Offsets.CastSock = modulePtr + 0x1bfb670
Offsets.GetAttackCastDelay = modulePtr + 0x2b62b0
Offsets.GetAttackDelay = modulePtr + 0x2b63b0
Offsets.PrintChat = modulePtr + 0x57a9d0
Offsets.ChatPtr = modulePtr + 0x1c5d320
Offsets.IssueOrder = modulePtr + 0x18a3a0
Offsets.IssueSock = modulePtr + 0x1bfb674
Offsets.LocalPlayer = modulePtr + 0x3501f1c
Offsets.HudInstance = modulePtr + 0x1c5f96c
Offsets.ObjectManager = modulePtr + 0x1c5f930
Offsets.randomRET = modulePtr + 0xea92a
Offsets.GameTime = modulePtr + 0x34fa7bc
Offsets.GetBoundingRadius = modulePtr + 0x1779c0
Offsets.GetBasicAttack = modulePtr + 0x176a10
Offsets.OnCreateObject = modulePtr + 0x2c8b70
Offsets.OnDeleteObject = modulePtr + 0x2b79e0
Offsets.GetSpellState = modulePtr + 0x50a410
Offsets.GetAiManager = modulePtr + 0x180b90
Offsets.OnProcessSpell = modulePtr + 0x519b00
Offsets.OnCastStop = modulePtr + 0x519f20
Offsets.UnderMouseObject = modulePtr + 0x34ef504
Offsets.OnAddRemoveBuff = modulePtr + 0x4f7dc0
Offsets.GetPing = modulePtr + 0x342ac0
Offsets.NetClientPtr = modulePtr + 0x3508f9c
Offsets.IsHero = modulePtr + 0x1cba80
Offsets.IsMissile = modulePtr + 0x1cbae0
Offsets.IsMinion = modulePtr + 0x1cbac0
Offsets.IsAlive = modulePtr + 0x1b7f20
Offsets.IsBaron = modulePtr + 0x18a2f0
Offsets.IsTurret = modulePtr + 0x1cbc70
Offsets.IsInhibitor = modulePtr + 0x1cb900
Offsets.IsDragon = modulePtr + 0x1883f0
Offsets.IsNexus = modulePtr + 0x1cba00
Offsets.IsNotWall = modulePtr + 0x8ec8c0
Offsets.IsTroy = modulePtr + 0xa8d8b0
Offsets.IsTargetable = modulePtr + 0x1efbe0
Offsets.GetHpBarPos = modulePtr + 0x5a0990
Offsets.WorldToScreen = modulePtr + 0x969aa0
Offsets.SetCharacterModel = modulePtr + 0x1b23d0

Offsets.Spellbook = 0x2AF0
Offsets.BuffMgr = 0x2338
Offsets.BuffArrStart = 0x10
Offsets.BuffArrEnd = 0x14


return Offsets
