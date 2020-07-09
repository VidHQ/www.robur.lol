winapi = require("winapi")

_G.lol_ptr = winapi.getModuleHandle(0)

_G.lol_num = ptrtonumber(lol_ptr)

-- Same goes with lol
_G.lol_CastSpell = lol_num + 0x509540
_G.lol_CastSock = lol_num + 0x1be8658
_G.lol_GetAttackCastDelay = lol_num + 0x2b2500
_G.lol_GetAttackDelay = lol_num + 0x2b2600
_G.lol_PrintChat = lol_num + 0x5937f0
_G.lol_ChatPtr = lol_num + 0x1C4F5F8
_G.lol_IssueOrder = lol_num + 0x186310
_G.lol_IssueSock = lol_num + 0x1be865c
_G.lol_IsTargetable = lol_num + 0x1ec150
_G.lol_IsHero = lol_num + 0x1c3e90
_G.lol_IsMissile = lol_num + 0x1c3ef0
_G.lol_IsMinion = lol_num + 0x1c3ed0
_G.lol_IsAlive = lol_num + 0x1b1a60
_G.lol_LocalPlayer = lol_num + 0x34f489c
_G.lol_HudInstance = lol_num + 0x1c51c30
_G.lol_ObjectManager = lol_num + 0x1c51bf4
_G.lol_randomRET = lol_num + 0xe57ba
_G.lol_GameTime = lol_num + 0x34ecaec
_G.lol_GetBoundingRadius = lol_num + 0x175110
_G.lol_WorldToScreen = lol_num + 0x95a650
