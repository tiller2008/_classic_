local E, L, V, P, G = unpack(select(2, ...)); --Engine

G.AnnounceSpells = {
	34477,	-- 误导
	19801,	-- 宁神射击
	57934,	-- 嫁祸诀窍
	633,	-- 圣疗术
	20484,	-- 复生
	61999,	-- 复活盟友
	20707,	-- 灵魂石
--	2908,	-- 安抚
}

G['interruptSpell'] = {
	-- 德鲁伊
	["DRUID"] = {
		[106839] = true, -- 迎头痛击，野性、守护专精（熊, 猎豹）
		[78675] = true, -- 日光术，平衡专精
		[770] = false, -- 精灵之火（插雕文）
		[106707] = false, -- 精灵虫群（插雕文）
	},
	-- 猎人
	["HUNTER"] = {
		[50318] = true, -- 宁静之尘，宠物蛾子
		[50479] = true, -- 虚空震击，宠物虚空鳐
		[26090] = true, -- 拳击，宠物猩猩
		[34490] = true, -- 沉默射击，天赋
		[147362] = true, -- 反制射击
	},
	-- 法师
	["MAGE"] = {
		[2139] = true, -- 法术反制
	},	
	-- 术士
	["WARLOCK"] = {
		[103135] = true, -- 法术封锁，地狱猎犬
		[119911] = true, -- 眼棱爆炸，眼魔
	},
	-- 萨满
	["SHAMAN"] = {
		[57994] = true, -- 风剪（含雕文）
	},
	-- 圣骑士
	["PALADIN"] = {
		[96231] = true, -- 责难（含雕文）
		[31935] = true, -- 复仇者之盾，防护专精（含雕文）
	},
	-- 牧师
	["PRIEST"] = {
		[15487] = true, -- 沉默，暗影专精
	},
	-- 战士
	["WARRIOR"] = {
		[102060] = true, -- 瓦解怒吼，天赋
		[6552] = true, -- 拳击
	},
	-- 盗贼
	["ROGUE"] = {
		[26679] = false, -- 致命投掷，天赋，须5个连击点数，这个可以不加，无CD，真用它打断的DZ肯定会留星的。
		[1766] = true, -- 脚踢
	},
	-- 死亡骑士
	["DEATHKNIGHT"] = {
		[47528] = true, -- 心灵冰冻
		[47476] = true, -- 绞袭
		[108194] = true, -- 窒息，天赋，代替绞袭
	},
	-- 武僧
	["MONK"] = {
		[116705] = true, -- 切喉手
	},
}

G['announcements'] = {
	['AnnounceToys'] = {
		[61031] = true,		-- Toy Train Set
		[49844] = true,		-- Direbrew's Remote
	},
	['AnnounceBots'] = {
		[22700] = true,		-- Field Repair Bot 74A
		[44389] = true,		-- Field Repair Bot 110G
		[54711] = true,		-- Scrapbot
		[67826] = true,		-- Jeeves
		[126459] = true,	-- Blingtron 4000
	},
	['AnnouncePortals'] = {
		-- Alliance
		[10059] = true,		-- Stormwind
		[11416] = true,		-- Ironforge
		[11419] = true,		-- Darnassus
		[32266] = true,		-- Exodar
		[49360] = true,		-- Theramore
		[33691] = true,		-- Shattrath
		[88345] = true,		-- Tol Barad
		[132620] = true,	-- Vale of Eternal Blossoms
		-- Horde
		[11417] = true,		-- Orgrimmar
		[11420] = true,		-- Thunder Bluff
		[11418] = true,		-- Undercity
		[32267] = true,		-- Silvermoon
		[49361] = true,		-- Stonard
		[35717] = true,		-- Shattrath
		[88346] = true,		-- Tol Barad
		[132626] = true,	-- Vale of Eternal Blossoms
		-- Alliance/Horde
		[53142] = true,		-- Dalaran
	},
}