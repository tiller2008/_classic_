
if (GetLocale() ~= "zhTW") then return end

LibItemStatsPatterns = {
	ignore = {
        "^使用",
        "^擊中時可能",
        "寵物的攻擊強度",
	},
    multiple = {
        { key1 = "Healing", key2 = "SpellDamage", pattern = "%+(%d+)治療和%+(%d+)法術傷害(.*)" },
    },
	recursive = {
        "(%+%d+.-)和(.+)",
        "(初級速度)和(.+)",
        "^(.-)及(.+)",
        "^(.-)/(.+)",
	},
	general = {
		{ key = "Armor",     pattern = "護甲$" },
		{ key = "Stamina",   pattern = "耐力" },
		{ key = "Agility",   pattern = "敏捷" },
		{ key = "Strength",  pattern = "力量" },
		{ key = "Intellect", pattern = "智力" },
		{ key = "Spirit",    pattern = "精神" },
		{ key = "hp",        pattern = "生命力$" },
		{ key = "mp",        pattern = "法力$" },
		{ key = "Resilience", pattern = "韌性等級" },		
		{ key = "Stamina|Agility|Strength|Intellect|Spirit", pattern = "所有屬性" },
		{ key = "ManaRestore", pattern = "法力恢復" },
		{ key = "ManaRestore", pattern = "法力回復" },
		{ key = "ResistanceFrost",  pattern = "冰霜抗性" },
		{ key = "ResistanceShadow", pattern = "暗影抗性" },
        { key = "ResistanceShadow", pattern = "陰影抗性" },
		{ key = "ResistanceArcane", pattern = "祕法抗性" },
		{ key = "ResistanceFire",   pattern = "火焰抗性" },
		{ key = "ResistanceNature", pattern = "自然抗性" },
		{ key = "ResistanceHoly",   pattern = "神聖抗性" },
		{ key = "ResistanceFrost|ResistanceShadow|ResistanceArcane|ResistanceFire|ResistanceNature|ResistanceHoly", pattern = "所有抗性" },
		{ key = "DamageFrost",  pattern = "冰霜法術傷害" },
		{ key = "DamageShadow", pattern = "暗影法術傷害" },
		{ key = "DamageArcane", pattern = "祕法法術傷害" },
		{ key = "DamageFire",   pattern = "火焰法術傷害" },
		{ key = "DamageNature", pattern = "自然法術傷害" },
		{ key = "DamageHoly",   pattern = "神聖法術傷害" },
		{ key = "DamageShadow", pattern = "陰影法術傷害" },
		{ key = "DamageFrost",  pattern = "冰霜傷害" },
		{ key = "DamageShadow", pattern = "暗影傷害" },
		{ key = "DamageArcane", pattern = "祕法傷害" },
		{ key = "DamageFire",   pattern = "火焰傷害" },
		{ key = "DamageNature", pattern = "自然傷害" },
		{ key = "DamageHoly",   pattern = "神聖傷害" },
		{ key = "SpellDamage",         pattern = "傷害法術" },
		{ key = "SpellDamage|Healing", pattern = "法術傷害和治療" },
		{ key = "SpellDamage|Healing", pattern = "法術治療和傷害" },
		{ key = "SpellDamage|Healing", pattern = "法術能量" },
		{ key = "SpellDamage|Healing", pattern = "法術傷害" },
		{ key = "SpellStrike",         pattern = "法術穿透力" },
		{ key = "SpellHitRating",      pattern = "法術命中等級" },
		{ key = "SpellCrit",           pattern = "法術致命一擊等級" },
		{ key = "Healing", pattern = "法術治療" },
		{ key = "Healing", pattern = "治療法術" },
		{ key = "Healing", pattern = "治療" },
		{ key = "Dodge",   pattern = "閃躲等級" },
		{ key = "Parry",   pattern = "招架等級" },
		{ key = "Defense", pattern = "防禦等級" },
		{ key = "HitRating", pattern = "命中等級" },
		{ key = "RangedAttackPower", pattern = "遠程攻擊強度" },		
		{ key = "AttackCrit|RangedAttackCrit", pattern = "致命一擊等級" },		
		{ key = "AttackPower|RangedAttackPower", pattern = "攻擊強度" },
		{ key = "Block", pattern = "格擋等級" },
	},
	extra = {
		{ key = "Armor", pattern = "(%d+)點護甲$" },
		{ key = "Block", pattern = "(%d+)格擋$" },
		{ key = "ManaRestore", pattern = "每5秒恢復(%d+)點法力" },
		{ key = "ManaRestore", pattern = "每5秒法力回复%+(%d+)" },
		{ key = "Resilience", pattern = "韌性等級提高(%d+)" },
		{ key = "SpellHitRating", pattern = "提高法術命中等級(%d+)" },
		{ key = "HasteSpell", pattern = "提高法術加速等級(%d+)" },
		{ key = "SpellCrit", pattern = "提高法術致命一擊等級(%d+)" },
		{ key = "SpellStrike", pattern = "法術穿透力提高(%d+)" },		
		{ key = "SpellDamage|Healing", pattern = "所有法術和魔法效果所造成的傷害和治療效果提高最多(%d+)" },
		{ key = "SpellDamage|Healing", pattern = "所有法術和魔法效果所造成的傷害和治療效果提高最多(%d+)" },
		{ key = "Healing", extra = 0.33, pattern = "法術和魔法效果所造成的治療效果提高最多(%d+)" },
		{ key = "DamageFrost", pattern = "冰霜法術和效果所造成的傷害提高最多(%d+)" },
		{ key = "DamageShadow", pattern = "暗影法術和效果所造成的傷害提高最多(%d+)" },
		{ key = "DamageArcane", pattern = "祕法法術和效果所造成的傷害提高最多(%d+)" },
		{ key = "DamageFire", pattern = "火焰法術和效果所造成的傷害提高最多(%d+)" },
		{ key = "DamageNature", pattern = "自然法術和效果所造成的傷害提高最多(%d+)" },
		{ key = "DamageHoly", pattern = "神聖法術和效果所造成的傷害提高最多(%d+)" },
		{ key = "HasteMelee", pattern = "提高加速等級(%d+)" },
		{ key = "RangedAttackPower", pattern = "提高遠程攻擊強度(%d+)" },		
		{ key = "AttackCrit|RangedAttackCrit", pattern = "提高致命一擊等級(%d+)" },		
		{ key = "AttackPower|RangedAttackPower", pattern = "提高攻擊強度(%d+)" },
		{ key = "HitRating", pattern = "提高命中等級(%d+)" },
		{ key = "Parry", pattern = "招架等級提高(%d+)" },
		{ key = "Defense", pattern = "提高防禦等級(%d+)" },
		{ key = "Dodge", pattern = "閃躲等級提高(%d+)" },
		{ key = "Block", pattern = "盾牌的格擋值提高(%d+)" },
		{ key = "Block", pattern = "格擋等級提高(%d+)" },
		{ key = "Block", pattern = "盾牌格擋等級(%d+)" },
		{ key = "ReduceResistance", pattern = "使你法術目標的魔法抗性降低(%d+)點。" },
		{ key = "SpellHitRating", pattern = "法術命中等級提高(%d+)" },
		{ key = "SpellCrit", pattern = "法術致命一擊等級提高(%d+)" },
		{ key = "RangedAttackPower", pattern = "遠程攻擊強度提高(%d+)" },		
		{ key = "AttackCrit|RangedAttackCrit", pattern = "致命一擊等級提高(%d+)" },		
		{ key = "AttackPower|RangedAttackPower", pattern = "攻擊強度提高(%d+)" },
		{ key = "HitRating", pattern = "命中等級提高(%d+)" },
		{ key = "Parry", pattern = "提高招架等級(%d+)" },
		{ key = "Defense", pattern = "防禦等級提高(%d+)" },
		{ key = "Dodge", pattern = "提高閃躲等級(%d+)" },
	},
    percent = {
		{ key = "SpellDamage", baseon = "Intellect", pattern = "法術所造成的傷害提高相當於你總智力的(%d+)%%" },
	},
	special = {
		{ key = "DamageShadow|DamageFrost", value = 54, pattern = "靈魂冰霜$" },
		{ key = "DamageFire|DamageArcane", value = 50, pattern = "烈日火焰$" },
		{ key = "ResistanceComa", value = 5, pattern = "昏迷抗性" },
		{ key = "ManaRestore|HealthRestore", value = 4, pattern = "活力$" },
		{ key = "AttackPower|RangedAttackPower", value = 70, pattern = "野性$" },		
		{ key = "MountSpeed", value = 4, pattern = "秘銀馬刺" },
		{ key = "MountSpeed", value = 2, pattern = "坐騎移動速度略微提升" },
		{ key = "MountSpeed", value = 10, pattern = "坐騎速度提高10%%" },
		{ key = "MountSpeed", value = 3, pattern = "坐騎速度提高3%%" },
		{ key = "RunSpeed", value = 8, pattern = "略微提高移動速度" },
		{ key = "RunSpeed", value = 8, pattern = "略微提高奔跑速度" },
		{ key = "RunSpeed", value = 8, pattern = "移動速度略微提升" },
		{ key = "RunSpeed", value = 8, pattern = "初級速度" },		
		{ key = "SpellDamage|Healing", value = 42, pattern = "超強巫師之油" },
		{ key = "SpellDamage|Healing", value = 16, pattern = "次級巫師之油" },
		{ key = "SpellDamage|Healing", value = 8, pattern = "初級巫師之油" },
		{ key = "SpellDamage|Healing", value = 24, pattern = "巫師之油" },
		{ key = "ManaRestore", value = 14, pattern = "超強法力之油" },
		{ key = "ManaRestore", value = 12, continue = true, pattern = "卓越法力之油" },
		{ key = "Healing", value = 24, continue = true, pattern = "卓越法力之油" },
	},
    buff = {
		convert = {
			{ from = "並", to = "," },
			{ from = "點和", to = "點," },
		},	
		{ key = "Armor", pattern = "護甲值提高(%d+)"},
		{ key = "Stamina", pattern = "耐力提高(%d+)"},
		{ key = "Spirit", pattern = "提高精神(%d+)"},
		{ key = "ResistanceShadow", pattern = "暗影抗性提高(%d+)"},
		{ key = "Intellect", pattern = "智力提高(%d+)"},
		{ key = "ResistanceFrost", pattern = "冰霜抗性提高(%d+)"},	
		{ key = "Stamina|Agility|Strength|Intellect|Spirit", pattern = "所有屬性提高(%d+)點"},
		{ key = "ResistanceFrost|ResistanceShadow|ResistanceArcane|ResistanceFire|ResistanceNature|ResistanceHoly", pattern = "所有抗性提高(%d+)點"},
		{ key = "ManaRestore", pattern = "每5秒恢復(%d+)點法力"},
		{ key = "HealthRestore", pattern = "每5秒恢復(%d+)點生命"},
		{ key = "Stamina|Agility|Strength|Intellect|Spirit", percent = true, pattern = "所有屬性提高(%d+)%%"},
		{ key = "SpellCrit", percent = true, pattern = "法術造成致命一擊的機率提高(%d+)%%"},
		{ key = "Dodge", percent = true, pattern = "閃躲機率提高(%d+)%%"},
		{ key = "AttackPower", pattern = "近戰攻擊強度提高(%d+)"},
		{ key = "hp", pattern = "生命力上限提高(%d+)"},
		{ key = "hp", pattern = "生命力提高(%d+)點"},
		{ key = "ResistanceFrost|ResistanceShadow|ResistanceArcane|ResistanceFire|ResistanceNature|ResistanceHoly", pattern = "對所有系別的魔法抗性提高(%d+)"},
		{ key = "SpellDamage", pattern = "提高法術傷害加成(%d+)"},
		{ key = "RangedAttackPower", pattern = "遠程攻擊強度提高(%d+)"},
		{ key = "AttackPower|RangedAttackPower", pattern = "提高攻擊強度(%d+)"},
		{ key = "ResistanceNature", pattern = "自然抗性提高(%d+)"},
		{ key = "Stamina", pattern = "耐力%+(%d+)點"},
		{ key = "Defense", pattern = "防禦等級提高(%d+)"},
		{ key = "Healing", pattern = "治療效果提高(%d+)"},
		{ key = "Healing", pattern = "治療法術效果提高最多(%d+)"},
		{ key = "Agility", pattern = "敏捷提高(%d+)"},
		{ key = "Strength", pattern = "力量提高(%d+)"},
		{ key = "Spirit", pattern = "精神提高(%d+)"},
		{ key = "Intellect|Spirit", pattern = "智力和精神提高(%d+)"},
		{ key = "SpellDamage", pattern = "法術傷害和治療效果提高最多(%d+)"},
		{ key = "SpellCrit", pattern = "法術致命一擊等級提高(%d+)"},		
		{ key = "AttackCrit|RangedAttackCrit", pattern = "致命一擊提高(%d+)"},
		{ key = "SpellDamage", pattern = "法術傷害提高(%d+)"},
		{ key = "SpellDamage", pattern = "法術傷害提高最多(%d+)"},
		{ key = "DamageShadow", baseon = "SpellDamage", percent = true, pattern = "造成的暗影傷害提高(%d+)%%"}, --@todo(法伤+额外暗伤)*系数
		{ key = "ArmorReduce2", pattern = "受到物理攻擊時承受的傷害降低(%d+)%%"},	
	},
    
}

LibItemStatsLocale = {
    Strength = "力量",
    Agility  = "敏捷",
    Stamina = "耐力",
    Intellect = "智力",
    Spirit = "精神",
    Armor = "護甲",
    Resilience = "韌性",
    Defense = "防技",
    Dodge = "閃躲幾率",
    Parry = "招架幾率",
    Block = "格擋幾率",
    ResistanceNature = "自然抗性",
    ResistanceFire = "火焰抗性",
    ResistanceArcane = "祕法抗性",
    ResistanceShadow = "暗影抗性",
    ResistanceFrost = "冰霜抗性",
    ResistanceHoly = "神聖抗性",
    ResistanceComa = "昏迷抗性",
    DamageNature = "自然傷害",
    DamageFire = "火焰傷害",
    DamageArcane = "祕法傷害",
    DamageShadow = "暗影傷害",
    DamageFrost = "冰霜傷害",
    DamageHoly = "神聖傷害",
    HitRating = "物理命中",
    AttackDamage = "近戰傷害",
    AttackSpeed = "近戰速度",
    AttackPower = "近戰強度",
    AttackCrit = "近戰致命",
    HasteMelee = "加速等級",
    RangedAttackDamage = "遠程傷害",
    RangedAttackSpeed = "遠程速度",
    RangedAttackPower = "遠程強度",
    RangedAttackCrit = "遠程致命",
    HasteRanged = "遠程加速等級",
    HasteSpell = "法術加速",
    SpellDamage = "法術傷害",
    Healing = "治療加成",
    SpellHitRating = "法術命中",
    SpellCrit = "法術致命",
    SpellStrike = "法術穿透",
    ManaRestore = "戰鬥回魔",
    HealthRestore = "生命力回復",
    RunSpeed = "移動速度",
    MountSpeed = "坐騎速度",
    Talent = "天賦",
    Suit = "套裝",
    Attribute = "屬性",
    Resistance = "抗性",
    Attack = "近戰&遠程",
    Spell = "法術",
    Health = "生命&法力",
    ReduceResistance = "降低抗性",
    HP = "生命值",
    MP = "法力值",
    ArmorReduce = "物理免傷",
}
