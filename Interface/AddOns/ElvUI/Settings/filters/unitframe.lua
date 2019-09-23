local E, L, V, P, G = unpack(select(2, ...)); --Engine

--Lua functions
local unpack = unpack
local strlower = string.lower
--WoW API / Variables
local IsPlayerSpell = IsPlayerSpell

local function Defaults(priorityOverride)
	return {
		enable = true,
		priority = priorityOverride or 0,
		stackThreshold = 0
	}
end

G.unitframe.aurafilters = {};

-- These are debuffs that are some form of CC
G.unitframe.aurafilters.CCDebuffs = {
	type = 'Whitelist',
	spells = {
	--Druid
	--Hunter
	--Mage
	--Paladin
	--Priest
	--Rogue
	--Shaman
	--Warlock
	--Warrior
	--Racial
	},
}

-- These are buffs that can be considered "protection" buffs
G.unitframe.aurafilters.TurtleBuffs = {
	type = 'Whitelist',
	spells = {
	-- Druid
	--Hunter
	--Mage
	--Paladin
	--Priest
	--Rogue
	--Shaman
	--Warlock
	--Warrior
	--Racial
	},
}

G.unitframe.aurafilters.PlayerBuffs = {
	type = 'Whitelist',
	spells = {
	-- Druid
	--Hunter
	--Mage
	--Paladin
	--Priest
	--Rogue
	--Shaman
	--Warlock
	--Warrior
	--Racial
	},
}

-- Buffs that really we dont need to see
G.unitframe.aurafilters.Blacklist = {
	type = 'Blacklist',
	spells = {
	},
}

--[[
	This should be a list of important buffs that we always want to see when they are active
	bloodlust, paladin hand spells, raid cooldowns, etc..
]]
G.unitframe.aurafilters.Whitelist = {
	type = 'Whitelist',
	spells = {
	},
}

-- RAID DEBUFFS: This should be pretty self explainitory
G.unitframe.aurafilters.RaidDebuffs = {
	type = 'Whitelist',
	spells = {
	},
}

--[[
	RAID BUFFS:
	Buffs that are provided by NPCs in raid or other PvE content.
	This can be buffs put on other enemies or on players.
]]
G.unitframe.aurafilters.RaidBuffsElvUI = {
	type = 'Whitelist',
	spells = {
		--Mythic/Mythic+
		--Raids
	},
}

-- Spells that we want to show the duration backwards
E.ReverseTimer = {

}

-- BuffWatch: List of personal spells to show on unitframes as icon
local function ClassBuff(id, point, color, anyUnit, onlyShowMissing, style, displayText, decimalThreshold, textColor, textThreshold, xOffset, yOffset, sizeOverride)
	local r, g, b = unpack(color)

	local r2, g2, b2 = 1, 1, 1
	if textColor then
		r2, g2, b2 = unpack(textColor)
	end

	return {
		enabled = true,
		id = id,
		point = point,
		color = {r = r, g = g, b = b},
		anyUnit = anyUnit,
		onlyShowMissing = onlyShowMissing,
		style = style or 'coloredIcon',
		displayText = displayText or false,
		decimalThreshold = decimalThreshold or 5,
		textColor = {r = r2, g = g2, b = b2},
		textThreshold = textThreshold or -1,
		xOffset = xOffset or 0,
		yOffset = yOffset or 0,
		sizeOverride = sizeOverride or 0
	}
end

G.unitframe.buffwatch = {
	PRIEST = {
		[194384] = ClassBuff(194384, "TOPRIGHT", {1, 1, 0.66}),          -- Atonement
		[214206] = ClassBuff(214206, "TOPRIGHT", {1, 1, 0.66}),          -- Atonement (PvP)
		[41635]  = ClassBuff(41635, "BOTTOMRIGHT", {0.2, 0.7, 0.2}),     -- Prayer of Mending
		[193065] = ClassBuff(193065, "BOTTOMRIGHT", {0.54, 0.21, 0.78}), -- Masochism
		[139]    = ClassBuff(139, "BOTTOMLEFT", {0.4, 0.7, 0.2}),        -- Renew
		[6788]   = ClassBuff(6788, "BOTTOMLEFT", {0.89, 0.1, 0.1}),       -- Weakened Soul
		[17]     = ClassBuff(17, "TOPLEFT", {0.7, 0.7, 0.7}, true),      -- Power Word: Shield
		[47788]  = ClassBuff(47788, "LEFT", {0.86, 0.45, 0}, true),      -- Guardian Spirit
		[33206]  = ClassBuff(33206, "LEFT", {0.47, 0.35, 0.74}, true),   -- Pain Suppression
	},
	DRUID = {
		[774]    = ClassBuff(774, "TOPRIGHT", {0.8, 0.4, 0.8}),   		-- Rejuvenation
		[155777] = ClassBuff(155777, "RIGHT", {0.8, 0.4, 0.8}),   		-- Germination
		[8936]   = ClassBuff(8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}),		-- Regrowth
		[33763]  = ClassBuff(33763, "TOPLEFT", {0.4, 0.8, 0.2}),  		-- Lifebloom
		[48438]  = ClassBuff(48438, "BOTTOMRIGHT", {0.8, 0.4, 0}),		-- Wild Growth
		[207386] = ClassBuff(207386, "TOP", {0.4, 0.2, 0.8}),     		-- Spring Blossoms
		[102351] = ClassBuff(102351, "LEFT", {0.2, 0.8, 0.8}),    		-- Cenarion Ward (Initial Buff)
		[102352] = ClassBuff(102352, "LEFT", {0.2, 0.8, 0.8}),    		-- Cenarion Ward (HoT)
		[200389] = ClassBuff(200389, "BOTTOM", {1, 1, 0.4}),      		-- Cultivation
	},
	PALADIN = {
		[53563]  = ClassBuff(53563, "TOPRIGHT", {0.7, 0.3, 0.7}),          -- Beacon of Light
		[156910] = ClassBuff(156910, "TOPRIGHT", {0.7, 0.3, 0.7}),         -- Beacon of Faith
		[200025] = ClassBuff(200025, "TOPRIGHT", {0.7, 0.3, 0.7}),         -- Beacon of Virtue
		[1022]   = ClassBuff(1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true),    -- Hand of Protection
		[1044]   = ClassBuff(1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true),  -- Hand of Freedom
		[6940]   = ClassBuff(6940, "BOTTOMRIGHT", {0.89, 0.1, 0.1}, true), -- Hand of Sacrifice
		[223306] = ClassBuff(223306, 'BOTTOMLEFT', {0.7, 0.7, 0.3}),       -- Bestow Faith
		[287280] = ClassBuff(287280, 'TOPLEFT', {0.2, 0.8, 0.2}),          -- Glimmer of Light (Artifact HoT)
	},
	SHAMAN = {
		[61295]  = ClassBuff(61295, "TOPRIGHT", {0.7, 0.3, 0.7}),   	 -- Riptide
		[974] = ClassBuff(974, "BOTTOMRIGHT", {0.2, 0.2, 1}), 	 -- Earth Shield
	},
	ROGUE = {
		[57934] = ClassBuff(57934, "TOPRIGHT", {0.89, 0.09, 0.05}),		 -- Tricks of the Trade
	},
	WARRIOR = {
		[114030] = ClassBuff(114030, "TOPLEFT", {0.2, 0.2, 1}),     	 -- Vigilance
		[3411]   = ClassBuff(3411, "TOPRIGHT", {0.89, 0.09, 0.05}), 	 -- Intervene
	},
	PET = {
		-- Warlock Pets
		[193396] = ClassBuff(193396, 'TOPRIGHT', {0.6, 0.2, 0.8}, true), -- Demonic Empowerment
		-- Hunter Pets
		[272790] = ClassBuff(272790, 'TOPLEFT', {0.89, 0.09, 0.05}, true), -- Frenzy
		[136]   = ClassBuff(136, 'TOPRIGHT', {0.2, 0.8, 0.2}, true)      -- Mend Pet
	},
	HUNTER = {}, --Keep even if it's an empty table, so a reference to G.unitframe.buffwatch[E.myclass][SomeValue] doesn't trigger error
	DEMONHUNTER = {},
	WARLOCK = {},
	MAGE = {},
	DEATHKNIGHT = {},

	ALL = {
	--	ClassBuff(740, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, nil, nil, 14, true), --Äþ¾²
		[97463] = ClassBuff(97463, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, -10, 0, 14, true),--¼¯½áÄÅº°*
		[64844] = ClassBuff(64844, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, -10, nil, 14, true), --ÉñÊ¥ÔÞÃÀÊ«*
		[81782] = ClassBuff(81782, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, -10, nil, 14, true), --ÕæÑÔÊõ£ºÕÏ*
		[15286] = ClassBuff(15286, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, -10, nil, 14, true), --ÎüÑª¹íµÄÓµ±§
		[31821] = ClassBuff(31821, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, -10, nil, 14, true), --ò¯³Ï¹â»·
		[88611] = ClassBuff(88611, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, -10, nil, 14, true), --ÑÌÎíµ¯*
		[145629] = ClassBuff(145629, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, -10, nil, 14, true), --·´Ä§·¨ÁìÓò
	--	[108280] = ClassBuff(108280, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, nil, nil, 14, true), --ÖÎÁÆÖ®³±Í¼ÌÚ
		[98007] = ClassBuff(98007, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, -10, nil, 14, true), --Áé»êÁ´½ÓÍ¼ÌÚ*
	--	[172106] = ClassBuff(172106, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, -10, nil, 14, true), --ÁéºüÊØ»¤*
	--	[159916] = ClassBuff(159916, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, -10, nil, 14, true), --Ä§·¨ÔöÐ§
	},
	CHAR = { --¸öÈË¼õÉË×é
		[48707] = ClassBuff(48707, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --·´Ä§·¨»¤ÕÖ
		[30823] = ClassBuff(30823, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --ÈøÂúÖ®Å­
		[108271] = ClassBuff(108271, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --ÈøÂúÖ®Å­
		[33206] = ClassBuff(33206, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --Í´¿àÑ¹ÖÆ
		[47585] = ClassBuff(47585, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --ÏûÉ¢
		[871] = ClassBuff(871, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --¶ÜÇ½
		[48792] = ClassBuff(48792, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --±ù·âÖ®ÈÍ
		[498] = ClassBuff(498, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --Ê¥ÓÓÊõ
		[22812] = ClassBuff(22812, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --Ê÷Æ¤Êõ
		[61336] = ClassBuff(61336, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --Éú´æ±¾ÄÜ
		[5277] = ClassBuff(5277, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --ÉÁ±Ü
		[74001] = ClassBuff(74001, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --±¸Õ½¾ÍÐ÷
		[47788] = ClassBuff(47788, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --ÊØ»¤Ö®»ê
		[19263] = ClassBuff(19263, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --ÍþÉå
		[6940] = ClassBuff(6940, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --ÎþÉüÖ®ÊÖ
		[31850] = ClassBuff(31850, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --³ãÈÈ·ÀÓùÕß
		[31224] = ClassBuff(31224, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --°µÓ°¶·Åñ
		[42650] = ClassBuff(42650, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --ÍöÕß´ó¾ü
		[86657] = ClassBuff(86657, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --Ô¶¹ÅÊØÎÀ
		[118038] = ClassBuff(118038, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --½£ÔÚÈËÔÚ
		[115176] = ClassBuff(115176, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --ìøÎòÚ¤Ïë
		[115308] = ClassBuff(115308, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --Æ®Ãì¾Æ
		[120954] = ClassBuff(120954, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --×³µ¨¾Æ
		[115295] = ClassBuff(115295, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --½ðÖÓÕÖ
		[51271] = ClassBuff(51271, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --±ùËªÖ®Öù
		[12975] = ClassBuff(12975, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --ÆÆ¸ª³ÁÖÛ
		[97463] = ClassBuff(97463, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --¼¯½áÄÅº°
		[102342] = ClassBuff(102342, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --ÌúÄ¾Ê÷Æ¤
		[114039] = ClassBuff(114039, "TOP", {1, 0, 0}, true, nil, "texturedIcon", nil, nil, nil, nil, 10, nil, 14, true), --´¿¾»Ö®ÊÖ
	},
}

-- Profile specific BuffIndicator
P.unitframe.filters = {
	buffwatch = {},
}

-- List of spells to display ticks
G.unitframe.ChannelTicks = {
	-- Warlock
	[198590] = 6, -- Drain Soul
	[755]    = 6, -- Health Funnel
	[234153] = 6, -- Drain Life
	-- Priest
	[64843]  = 4, -- Divine Hymn
	[15407]  = 4, -- Mind Flay
	[48045] = 5, -- Mind Sear
	-- Mage
	[5143]   = 5,  -- Arcane Missiles
	[12051]  = 3,  -- Evocation
	[205021] = 10, -- Ray of Frost
	--Druid
	[740]    = 4, -- Tranquility
}

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
	if strlower(E.myclass) ~= "priest" then return end

	local penanceTicks = IsPlayerSpell(193134) and 4 or 3
	E.global.unitframe.ChannelTicks[47540] = penanceTicks --Penance
end)

G.unitframe.ChannelTicksSize = {
	-- Warlock
	[198590] = 1, -- Drain Soul
}

-- Spells Effected By Haste
G.unitframe.HastedChannelTicks = {
	[205021] = true, -- Ray of Frost
}

-- This should probably be the same as the whitelist filter + any personal class ones that may be important to watch
G.unitframe.AuraBarColors = {
	[2825]  = {r = 0.98, g = 0.57, b = 0.10}, -- Bloodlust
	[32182] = {r = 0.98, g = 0.57, b = 0.10}, -- Heroism
	[80353] = {r = 0.98, g = 0.57, b = 0.10}, -- Time Warp
	[90355] = {r = 0.98, g = 0.57, b = 0.10}, -- Ancient Hysteria
}

G.unitframe.DebuffHighlightColors = {
	[25771] = {enable = false, style = "FILL", color = {r = 0.85, g = 0, b = 0, a = 0.85}},
}

G.unitframe.specialFilters = {
	-- Whitelists
	Boss = true,
	Personal = true,
	nonPersonal = true,
	CastByUnit = true,
	notCastByUnit = true,
	Dispellable = true,
	notDispellable = true,
	CastByNPC = true,
	CastByPlayers = true,

	-- Blacklists
	blockNonPersonal = true,
	blockCastByPlayers = true,
	blockNoDuration = true,
	blockDispellable = true,
	blockNotDispellable = true,
};
