require("utils.ffi_ctypes")

ffi.cdef [[
typedef struct _Vector {
	float x;
	float y;
	float z;
} Vector;

typedef struct string_t {
	union {
		char buf[15];
		char *ptr;
	} type;
	uint32_t len;
	uint32_t len_max;
} string_t;

typedef struct spelldata_t {
  char padding_0[0x58-0x0]; 
  char* missileName;
  char padding_1[0x7c-0x5c]; 
  char* spellName;
  char padding_2[0x418-0x80]; 
  float missileSpeed;
} spelldata_t;

typedef struct spellinfo_t {
  char padding_0[0x18-0x0]; 
  string_t spellName;
  char padding_1[0x44-0x30]; 
  spelldata_t* spellData; 
} spellinfo_t;

typedef struct spellslot_t {
  char padding_0[0x20-0x0]; 
  uint32_t level;
  char padding_1[0x28-0x24]; 
  float time;
  char padding_2[0x134-0x2c]; 
  spellinfo_t* spellInfo;  
} spellslot_t;

typedef struct spellbook_t {
  /* 0x00000 */ char unknown_1[0x00508-0x00000];
  spellslot_t* spellSlot[10];
} spellbook_t;

typedef struct gameobect_t {
  char padding_0[0x20-0x0]; 
  __int16 id;
  char padding_1[0x4c-0x22]; 
  uint32_t team;
  char padding_2[0x6c-0x50]; 
  string_t name;
  char padding_3[0xcc-0x84]; 
  uint32_t networkId;
  char padding_4[0x1d8-0xd0]; 
  Vector position;
  char padding_5[0x450-0x1e4]; 
  bool visibility;
  char padding_6[0xf70-0x451]; 
  uint32_t checkIt;
  char padding_7[0xfa8-0xf74]; 
  float currentHp;
  char padding_8[0xfb8-0xfac]; 
  float maxHp;
  char padding_9[0x1274-0xfbc]; 
  float cooldownReduction;
  char padding_10[0x1284-0x1278]; 
  float maxCooldownReduction;
  char padding_11[0x1318-0x1288]; 
  float tenacity;
  char padding_12[0x1364-0x131c]; 
  float magicPen;
  char padding_13[0x1368-0x1368]; 
  float ignoreArmorPercent;
  char padding_14[0x136c-0x136c]; 
  float ignoreMagicResistPercent;
  char padding_15[0x1380-0x1370]; 
  float lethality;
  char padding_16[0x13cc-0x1384]; 
  float abilityPower;
  char padding_17[0x13dc-0x13d0]; 
  float bonusAd;
  char padding_18[0x1414-0x13e0]; 
  float bonusAttackSpeed;
  char padding_19[0x1428-0x1418]; 
  float lifesteal;
  char padding_20[0x1438-0x142c]; 
  float baseAttackSpeed;
  char padding_21[0x145c-0x143c]; 
  float baseAd;
  char padding_22[0x1460-0x1460]; 
  float crit;
  char padding_23[0x146c-0x1464]; 
  float totalMR;
  char padding_24[0x1470-0x1470]; 
  float bonusMR;
  char padding_25[0x1474-0x1474]; 
  float baseHpRegen;
  char padding_26[0x1478-0x1478]; 
  float totalHpRegen;
  char padding_27[0x147c-0x147c]; 
  float movementSpeed;
  char padding_28[0x1484-0x1480]; 
  float totalArmor;
  char padding_29[0x1488-0x1488]; 
  float bonusArmor;
  char padding_30[0x148c-0x148c]; 
  float baseArmor;
  char padding_31[0x14a4-0x1490]; 
  float attackRange;
  char padding_32[0x2230-0x14a8]; 
  int32_t combatType;
  char padding_33[0x2af0-0x2234]; 
  spellbook_t spellbook;
  char padding_34[0x35ac-0x3020]; 
  string_t championName;
  char padding_35[0x4ef4-0x35c4]; 
  int32_t level;
  
} gameobject_t;

typedef struct spellInfo_t {
	char pad_0x0000[0x4]; //0x0000
	__int16 slotId; //0x0004 
	char pad_0x0006[0x36]; //0x0006
	DWORD spellInfoPtr; //0x003C 
	char pad_0x0040[0x38]; //0x0040
	Vector fromVec; //0x0078 
	Vector toVec; //0x0084 
	char pad_0x0090[0x448]; //0x0090
	unsigned char N00000139; //0x04D8 
	unsigned char isAutoAttack; //0x04D9 
	char pad_0x04DA[0x6]; //0x04DA
	__int32 MaybeTargetId; //0x04E0 
	char pad_0x04E4[0x35C]; //0x04E4
} spellInfo_t;

typedef struct objectmanager_t {
/* 0x0000000 */	uint32_t unknown_1;
/* 0x0000004 */	uint32_t unknown_2;
/* 0x0000008 */	uint32_t maxObjects;
/* 0x000000c */	uint32_t unknown_4;
/* 0x0000010 */ uint32_t unknown_5;
/* 0x0000014 */ gameobject_t **objects;
/* 0x0000018 */ gameobject_t **lastobject;
} objectmanager_t;

typedef struct localplayer_t {
	/* 0x00000 */ char unknown_1[0x2AF0-0x00000];
	spellbook_t spellBook;
} localplayer_t;

typedef struct clickmanager_t {
	/* 0x00000000 */ char unknown_1[0x0001c-0x00000];
	/* 0x0000001c */ float x;
	/* 0x00000020 */ float y;
	/* 0x00000024 */ float z;
} clickmanager_t;

typedef struct hud_t {
	/* 0x00000000 */ char unknown_1[0x00014-0x00000];
	/* 0x00000014 */ clickmanager_t *clickmanager;
} hud_t;

typedef struct aimanager_t {
	char unknown_1[0x00198-0x00000];
	bool isMoving;
	char unknown_1[0x50];
	bool isDashing1;
	bool isDashing2;
	bool isDashing3;
	bool isDashing4;
	bool isDashing5;
} aimanager_t;

typedef struct spellCastInfo_t {
  spellinfo_t* spellInfo;
  char padding_1[0x4-0x4]; 
  __int16 slotId;
  char padding_2[0x78-0x6]; 
  Vector fromVec;
  char padding_3[0x84-0x84]; 
  Vector toVec;
  char padding_4[0xb8-0x90]; 
  __int16 targetId;
  char padding_5[0x4d9-0xba]; 
  char isAutoAttack;
} spellCastInfo_t;

typedef struct missile_t {
	char pad_0x0000[0x20];//0x0000
	__int16 id;//0x0020 
	char pad_0x0022[0x4A];//0x0022
	string_t name;//0x006C 
	char pad_0x0070[0x20B];//0x0070
	uint16_t sourceId;//0x0290 
	char pad_0x0292[0x16];//0x0292
	Vector fromVec;//0x02A8 
	Vector toVec;//0x02B4 
	char pad_0x02C0[0x24];//0x02C0
	unsigned char isAutoAttack;//0x02E4 
} missile_t;

typedef struct netclient_t{
} netclient_t;


typedef struct buffinfo_t{
  char padding_0[0x8-0x0];
  char* buffName;
} buffinfo_t;

typedef struct buffentry_t{
  char padding_0[0x8-0x0];
  buffinfo_t* buffInfo;
  float startTime;
  float endTime;
} buffentry_t;

typedef int (__stdcall *DrawCircle)(Vector* pos, float range, int* color, int a4, float a5, int a6, float alpha);
typedef float (__stdcall *GetAttackDelay)(gameobject_t *object);
typedef aimanager_t* (__thiscall *GetAiManager)(gameobject_t *object);
typedef int (__thiscall *GetPing)(netclient_t *object);
typedef bool(__cdecl* WorldToScreen)(Vector* p_World, Vector* p_Screen);
]]
