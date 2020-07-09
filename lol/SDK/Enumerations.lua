local Enumerations = {}

Enumerations.OrbwalkerModes = { 
    None = 0,
    Combo = 1,
    LastHit = 2,
    WaveClear = 3
}

Enumerations.IssueOrderType = {
    HoldPosition = 1,
    MoveTo = 2,
    AttackUnit = 3,
    AutoAttackPet = 4,
    AutoAttack = 5,
    MovePet = 6,
    AttackTo = 7,
    Stop = 10
}

Enumerations.Team = {
    None = 0,
    Order = 100,
    Chaos = 200,
    Neutral = 300
}

Enumerations.CombatType = {
    Melee = 1,
    Ranged = 2
}

Enumerations.DamageType = {
    Physical = 0,
    Magical = 1,
    True = 2,
    Mixed = 3
}

Enumerations.TargetingMode = {
    Priority = 0,
    LowHP = 1,
    MostAD = 2,
    MostAP = 3,
    MostStacks = 4,
    Closest = 5,
    NearMouse = 6
}

Enumerations.ObjectType = {
    -- ToDo
    NeutralMinionCamp = 0,
    obj_AI_Base = 1,
    FollowerObject = 2,
    FollowerObjectWithLerpMovement = 3,
    AIHeroClient = 4,
    obj_AI_Marker = 5,
    obj_AI_Minion = 6,
    LevelPropAI = 7,
    obj_AI_Turret = 8,
    obj_GeneralParticleEmitter = 9,
    MissileClient = 10,
    DrawFX = 11,
    UnrevealedTarget = 12,
    obj_LampBulb = 13,
    obj_Barracks = 14,
    obj_BarracksDampener = 15,
    obj_AnimatedBuilding = 16,
    obj_Building = 17,
    obj_Levelsizer = 18,
    obj_NavPoint = 19,
    obj_SpawnPoint = 20,
    obj_Lake = 21,
    obj_HQ = 22,
    obj_InfoPoint = 23,
    LevelPropGameObject = 24,
    LevelPropSpawnerPoint = 25,
    obj_Shop = 26,
    obj_Turret = 27,
    GrassObject = 28,
    obj_Ward = 29
}

Enumerations.BuffType = {
    -- ToDo
    Internal = 0,
    Aura = 1,
    CombatEnchancer = 2,
    CombatDehancer = 3,
    SpellShield = 4,
    Stun = 5,
    Invisibility = 6,
    Silence = 7,
    Taunt = 8,
    Polymorph = 9,
    Slow = 10,
    Snare = 11,
    Damage = 12,
    Heal = 13,
    Haste = 14,
    SpellImmunity = 15,
    PhysicalImmunity = 16,
    Invulnerability = 17,
    Sleep = 18,
    NearSight = 19,
    Frenzy = 20,
    Fear = 21,
    Charm = 22,
    Poison = 23,
    Suppression = 24,
    Blind = 25,
    Counter = 26,
    Shred = 27,
    Flee = 28,
    Knockup = 29,
    Knockback = 30,
    Disarm = 31
}

Enumerations.CharacterState = {
    -- ToDo
    CanAttack = 1,
    CanCast = 2,
    CanMove = 4,
    Immovable = 8,
    IsStealth = 16,
    RevealSpecificUnit = 32,
    Taunted = 64,
    Feared = 128,
    Fleeing = 256,
    Surpressed = 512,
    Asleep = 1024,
    NearSight = 2048,
    Ghosted = 4096,
    GhostProof = 8192,
    Charmed = 16384,
    NoRender = 32768,
    ForceRenderParticles = 65536,
    DodgePiercing = 131072,
    DisableAmbientGold = 262144,
    DisableAmbientXP = 524288
}

Enumerations.SpellSlot = {
    Unknown = -1,
    Q = 0,
    W = 1,
    E = 2,
    R = 3,
    Summoner1 = 4,
    Summoner2 = 5,
    Item1 = 6,
    Item2 = 7,
    Item3 = 8,
    Item4 = 9,
    Item5 = 10,
    Item6 = 11,
    Trinket = 12,
    Recall = 13
}

Enumerations.Events = {
    OnTick = 1,
    OnStep = 2,
    OnKey = 3,
    OnKeyDown = 4,
    OnKeyUp = 5,
    OnCreateObject = 6,
    OnDeleteObject = 7,
    OnProcessSpell = 8,
    OnIssueOrder = 9,
    OnCastStop = 10,
    OnBasicAttack = 11,
    OnBuffUpdate = 12,
    OnBuffGain = 13,
    OnBuffLost = 14,
    OnVisionGain = 15,
    OnVisionLost = 16,
    OnTeleport = 17,
    PostAutoAttack = 18,
    BeforeAutoAttack = 19,
    OnAutoAttack = 20
}

Enumerations.WindowMessages = {
    KEYDOWN = 0x100,
    KEYUP = 0x101,
    CHAR = 0x102,
    SYSKEYDOWN = 0x104,
    SYSKEYUP = 0x105,
    KEY_FIRST = 0x100,
    KEY_LAST = 0x108
}

Enumerations.AutoAttackResets = {
    ["Sivir_1"] = true,
    ["Camille_0"] = true,
    ["Vi_2"] = true,
}

Enumerations.DashAutoAttackResets = {
    ["Lucian_2"] = true,
    ["Vayne_0"] = true,
    ["Ekko_2"] = true,
}


return Enumerations
