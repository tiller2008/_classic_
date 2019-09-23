local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local Module = E:GetModule("AuraWatch")

if not Module then return; end

-- copy from ShestakUI's filger at 2018-10-07 by eui.cc

Module.Default = {
	["DRUID"] = {
		{
			Name = "玩家增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 12}, 
			List = {
				-- Incarnation: Chosen of Elune
				{AuraID = 102560, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Incarnation: King of the Jungle
				{AuraID = 102543, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Incarnation: Son of Ursoc
				{AuraID = 102558, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Incarnation: Tree of Life
				{AuraID = 117679, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Survival Instincts
				{AuraID = 61336, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Barkskin
				{AuraID = 22812, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Savage Roar
				{AuraID = 52610, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Berserk
				{AuraID = 106951, UnitID = "player", Caster = "player", filter = "BUFF", absID = true},
				-- Tiger's Fury
				{AuraID = 5217, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Celestial Alignment
				{AuraID = 194223, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Nature's Vigil
				{AuraID = 124974, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Rage of the Sleeper
				{AuraID = 200851, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Ironfur
				{AuraID = 192081, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Pulverize
				{AuraID = 158792, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Lunar Empowerment
				{AuraID = 164547, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Solar Empowerment
				{AuraID = 164545, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Nature's Grasp
				{AuraID = 170856, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Dash
				{AuraID = 1850, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Cenarion Ward
				{AuraID = 102351, UnitID = "player", Caster = "player", filter = "BUFF"},
			}
		},
		{
			Name = "玩家重要增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 55},
			List = {
				-- Buffs
				-- Warrior of Elune
				{AuraID = 202425, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Starlord
				{AuraID = 279709, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Bloodtalons
				{AuraID = 145152, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Clearcasting
				{AuraID = 16870, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Soul of the Forest
				{AuraID = 114108, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Predatory Swiftness
				{AuraID = 69369, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Guardian of Elune
				{AuraID = 213680, UnitID = "player", Caster = "player", filter = "BUFF"},

				-- Item Sets
				
				-- Trinkets
				
				-- Enchants
			}
		},
		{
			Name = "目标减益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 12}, 
			List = {
				-- Moonfire
				{AuraID = 164812, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Sunfire
				{AuraID = 164815, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Stellar Flare
				{AuraID = 202347, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Ashmane's Frenzy
				{AuraID = 210722, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Rake
				{AuraID = 155722, UnitID = "target", Caster = "player", filter = "DEBUFF", absID = true},
				-- Rip
				{AuraID = 1079, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Thrash
				{AuraID = 77758, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Immobilized
				{AuraID = 45334, UnitID = "target", Caster = "player", filter = "DEBUFF"},

				-- Trinket Effects
			}
		},
		{
			Name = "目标增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 48,
			Pos = {"BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 68}, 
			List = {
				-- Lifebloom
				{AuraID = 33763, UnitID = "target", Caster = "player", filter = "BUFF"},
				-- Rejuvenation
				{AuraID = 774, UnitID = "target", Caster = "player", filter = "BUFF"},
				-- Rejuvenation (Germination)
				{AuraID = 155777, UnitID = "target", Caster = "player", filter = "BUFF"},
				-- Regrowth
				{AuraID = 8936, UnitID = "target", Caster = "player", filter = "BUFF"},
				-- Wild Growth
				{AuraID = 48438, UnitID = "target", Caster = "player", filter = "BUFF"},
				-- Cenarion Ward
				{AuraID = 102351, UnitID = "target", Caster = "player", filter = "BUFF"},
			}
		},
		{
			Name = "冷却监视",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 48,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 99},
			List = {
				-- Self
				-- Nature's Cure
				{AuraID = 88423, filter = "CD"},
				-- Remove Corruption
				{AuraID = 2782, filter = "CD"},
				-- Skull Bash
				{AuraID = 106839, filter = "CD"},
				-- Mangle
				{AuraID = 33917, filter = "CD"},
				-- Wild Growth
				{AuraID = 48438, filter = "CD"},
				-- Swiftmend
				{AuraID = 18562, filter = "CD"},
				-- Growl
				{AuraID = 6795, filter = "CD"},
				-- Maim
				{AuraID = 22570, filter = "CD"},
				-- Starsurge
				{AuraID = 78674, filter = "CD"},
				-- Wild Charge
				{AuraID = 102401, filter = "CD"},
				-- Force of Nature
				{AuraID = 205636, filter = "CD"},
				-- Tiger's Fury
				{AuraID = 5217, filter = "CD"},
				-- Incapacitating Roar
				{AuraID = 99, filter = "CD"},
				-- Bristling Fur
				{AuraID = 155835, filter = "CD"},
				-- Mass Entanglement
				{AuraID = 102359, filter = "CD"},
				-- Typhoon
				{AuraID = 132469, filter = "CD"},
				-- Mighty Bash
				{AuraID = 5211, filter = "CD"},
				-- Solar Beam
				{AuraID = 78675, filter = "CD"},
				-- Barkskin
				{AuraID = 22812, filter = "CD"},
				-- Ironbark
				{AuraID = 102342, filter = "CD"},
				-- Ursol's Vortex
				{AuraID = 102793, filter = "CD"},
				-- Nature's Vigil
				{AuraID = 124974, filter = "CD"},
				-- Berserk
				{AuraID = 106951, filter = "CD", absID = true},
				-- Ashmane's Frenzy
				{AuraID = 210722, filter = "CD"},
				-- Incarnation: Chosen of Elune
				{AuraID = 102560, filter = "CD"},
				-- Incarnation: King of the Jungle
				{AuraID = 102543, filter = "CD"},
				-- Incarnation: Son of Ursoc
				{AuraID = 102558, filter = "CD"},
				-- Incarnation: Tree of Life
				{AuraID = 33891, filter = "CD"},

				-- PvP
				-- Honorable Medallion
				{AuraID = 195710, filter = "CD"},

				-- Racial
				-- Berserking (Troll)
				{AuraID = 26297, filter = "CD", absID = true},
				-- Darkflight (Worgen)
				{AuraID = 68992, filter = "CD"},
				-- Shadowmeld (Night Elf)
				{AuraID = 58984, filter = "CD"},
				-- War Stomp (Tauren)
				{AuraID = 20549, filter = "CD"},
			}
		},
	},
	["HUNTER"] = {
		{
			Name = "玩家增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 12}, 
			List = {
				-- Coordinated Assault
				{AuraID = 266779, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Aspect of the Turtle
				{AuraID = 186265, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Bestial Wrath
				{AuraID = 19574, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Trueshot
				{AuraID = 193526, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Aspect of the Wild
				{AuraID = 193530, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Aspect of the Eagle
				{AuraID = 186289, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Aspect of the Cheetah
				{AuraID = 186257, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Dire Beast
				{AuraID = 120694, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Camouflage
				{AuraID = 199483, UnitID = "player", Caster = "player", filter = "BUFF", absID = true},
				-- Spirit Mend
				{AuraID = 90361, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Posthaste
				{AuraID = 118922, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Volley
				{AuraID = 194386, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Misdirection
				{AuraID = 35079, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Survivalist
				{AuraID = 164857, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Trick Shot
				{AuraID = 227272, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Bombardment
				{AuraID = 82921, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Spitting Cobra
				{AuraID = 194407, UnitID = "player", Caster = "player", filter = "BUFF"},
			}
		},
		{
			Name = "玩家重要增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 55},
			List = {
				-- Buffs
				-- Viper's Venom
				{AuraID = 268552, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Trick Shots
				{AuraID = 257622, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Lethal Shots
				{AuraID = 260395, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Precise Shots
				{AuraID = 260242, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Frenzy
				{AuraID = 272790, UnitID = "pet", Caster = "player", filter = "BUFF"},
				-- Steady Focus
				{AuraID = 193533, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Lock and Load
				{AuraID = 194594, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Mok'Nathal Tactics
				{AuraID = 201081, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Mongoose Fury
				{AuraID = 190931, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Beast Cleave
				{AuraID = 118455, UnitID = "pet", Caster = "player", filter = "BUFF"},
				-- Marking Targets
				--BETA {AuraID = 223138, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Frenzy
				{AuraID = 19615, UnitID = "player", Caster = "player", filter = "BUFF", absID = true},
				-- Mend Pet
				{AuraID = 136, UnitID = "pet", Caster = "player", filter = "BUFF"},

				-- Trinkets
				
				-- Enchants
			}
		},
		{
			Name = "目标减益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 12}, 
			List = {
				-- Black Arrow
				{AuraID = 194599, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Serpent Sting
				{AuraID = 87935, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Lacerate
				{AuraID = 185855, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- A Murder of Crows
				{AuraID = 131894, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Hunter's Mark
				{AuraID = 257284, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Vulnerable
				--BETA {AuraID = 187131, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Hunter's Mark
				--BETA {AuraID = 185365, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Narrow Escape
				{AuraID = 136634, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Entrapment
				{AuraID = 135373, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Caltrops
				{AuraID = 194279, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Warp Time (Warp Stalker)
				{AuraID = 35346, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Ankle Crack (Crocolisk)
				{AuraID = 50433, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Frost Breath (Chimaera)
				{AuraID = 54644, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Concussive Shot
				{AuraID = 5116, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Tar Trap
				{AuraID = 135299, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Poisoned Ammo
				{AuraID = 162543, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Frozen Ammo
				{AuraID = 162546, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- True Aim
				{AuraID = 199803, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Explosive Trap
				{AuraID = 13812, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Steel Trap
				{AuraID = 162487, UnitID = "target", Caster = "player", filter = "DEBUFF", absID = true},
			}
		},
		{
			Name = "冷却监视",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 48,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 99},
			List = {
				-- Self
				-- Concussive Shot
				{AuraID = 5116, filter = "CD"},
				-- Counter Shot
				{AuraID = 147362, filter = "CD"},
				-- Kill Command
				{AuraID = 34026, filter = "CD"},
				-- Sidewinders
				{AuraID = 214579, filter = "CD"},
				-- Explosive Shot
				{AuraID = 212431, filter = "CD"},
				-- Chimera Shot
				{AuraID = 53209, filter = "CD"},
				-- Barrage
				{AuraID = 120360, filter = "CD"},
				-- Disengage
				{AuraID = 781, filter = "CD"},
				-- Dire Beast
				{AuraID = 120679, filter = "CD"},
				-- Fervor
				{AuraID = 82726, filter = "CD"},
				-- Misdirection
				{AuraID = 34477, filter = "CD"},
				-- Feign Death
				{AuraID = 5384, filter = "CD"},
				-- Explosive Trap
				{AuraID = 13813, filter = "CD"},
				-- Ice Trap
				{AuraID = 13809, filter = "CD"},
				-- Binding Shot
				{AuraID = 117526, filter = "CD"},
				-- Master's Call
				{AuraID = 53271, filter = "CD"},
				-- Wyvern Sting
				{AuraID = 19386, filter = "CD"},
				-- Intimidation
				{AuraID = 19577, filter = "CD"},
				-- Bestial Wrath
				{AuraID = 19574, filter = "CD"},
				-- A Murder of Crows
				{AuraID = 131894, filter = "CD"},
				-- Exhilaration
				{AuraID = 109304, filter = "CD"},
				-- Aspect of the Wild
				{AuraID = 193530, filter = "CD"},
				-- Aspect of the Turtle
				{AuraID = 186265, filter = "CD"},
				-- Aspect of the Cheetah
				{AuraID = 186257, filter = "CD"},
				-- Spirit Mend (Pet)
				{AuraID = 90361, filter = "CD"},

				-- PvP
				-- Honorable Medallion
				{AuraID = 195710, filter = "CD"},

				-- Racial
				-- Arcane Torrent (Blood Elf)
				{AuraID = 69179, filter = "CD"},
				-- Berserking (Troll)
				{AuraID = 26297, filter = "CD"},
				-- Blood Fury (Orc)
				{AuraID = 20572, filter = "CD"},
				-- Cannibalize (Forsaken)
				{AuraID = 20577, filter = "CD"},
				-- Darkflight (Worgen)
				{AuraID = 68992, filter = "CD"},
				-- Every Man for Himself (Human)
				{AuraID = 59752, filter = "CD"},
				-- Gift of the Naaru (Draenei)
				{AuraID = 28880, filter = "CD"},
				-- Quaking Palm (Pandaren)
				{AuraID = 107079, filter = "CD"},
				-- Rocket Jump (Goblin)
				{AuraID = 69070, filter = "CD"},
				-- Shadowmeld (Night Elf)
				{AuraID = 58984, filter = "CD"},
				-- Stoneform (Dwarf)
				{AuraID = 20594, filter = "CD"},
				-- War Stomp (Tauren)
				{AuraID = 20549, filter = "CD"},
				-- Will of the Forsaken (Forsaken)
				{AuraID = 7744, filter = "CD"},
			}
		},
	},
	["MAGE"] = {
		{
			Name = "玩家增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 12}, 
			List = {
				-- Ice Block
				{AuraID = 45438, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Invisibility
				{AuraID = 66, UnitID = "player", Caster = "player", filter = "BUFF", absID = true},
				-- Invisibility
				{AuraID = 32612, UnitID = "player", Caster = "player", filter = "BUFF", absID = true},
				-- Greater Invisibility
				{AuraID = 110960, UnitID = "player", Caster = "player", filter = "BUFF", absID = true},
				-- Icy Veins
				{AuraID = 12472, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Arcane Power
				{AuraID = 12042, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Combustion
				{AuraID = 190319, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Blazing Barrier
				{AuraID = 235313, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Prismatic Barrier
				{AuraID = 235450, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Ice Barrier
				{AuraID = 11426, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Heating Up
				{AuraID = 48107, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Ice Floes
				{AuraID = 108839, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Temporal Shield
				{AuraID = 198111, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Mirror Image
				{AuraID = 55342, filter = "ICD", trigger = "NONE", duration = 40},
				-- Icicles
				{AuraID = 205473, UnitID = "player", Caster = "player", filter = "BUFF"},
			}
		},
		{
			Name = "玩家重要增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 55},
			List = {
				-- Buffs
				-- Fingers of Frost
				{AuraID = 44544, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Brain Freeze
				{AuraID = 190446, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Glacial Spike!
				{AuraID = 199844, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Arcane Missiles!
				--BETA {AuraID = 79683, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Hot Streak!
				{AuraID = 48108, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Pyroclasm
				{AuraID = 269651, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Clearcasting
				{AuraID = 263725, UnitID = "player", Caster = "player", filter = "BUFF"},

				-- Trinkets
				
				-- Enchants
			}
		},
		{
			Name = "目标减益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 68}, 
			List = {
				-- Arcane Charge
				{AuraID = 36032, UnitID = "player", Caster = "player", filter = "DEBUFF"},
				-- Living Bomb
				{AuraID = 44457, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Nether Tempest
				{AuraID = 114923, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Freeze (Pet)
				{AuraID = 33395, UnitID = "target", Caster = "all", filter = "DEBUFF"},
				-- Frostbite
				{AuraID = 198121, UnitID = "target", Caster = "all", filter = "DEBUFF"},
				-- Frost Nova
				{AuraID = 122, UnitID = "target", Caster = "all", filter = "DEBUFF"},
				-- Cone of Cold
				{AuraID = 120, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Flurry
				{AuraID = 228354, UnitID = "target", Caster = "player", filter = "DEBUFF", absID = true},
				-- Ice Nova
				{AuraID = 157997, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Slow
				{AuraID = 31589, UnitID = "target", Caster = "player", filter = "DEBUFF"},

				-- Trinket Effects
			}
		},
		{
			Name = "冷却监视",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 48,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 99},
			List = {
				-- Self
				-- Remove Curse
				{AuraID = 475, filter = "CD"},
				-- Counterspell
				{AuraID = 2139, filter = "CD"},
				-- Living Bomb
				{AuraID = 44457, filter = "CD"},
				-- Blink
				{AuraID = 1953, filter = "CD"},
				-- Frost Nova
				{AuraID = 122, filter = "CD"},
				-- Ice Nova
				{AuraID = 157997, filter = "CD"},
				-- Ring of Frost
				{AuraID = 113724, filter = "CD"},
				-- Blazing Barrier
				{AuraID = 235313, filter = "CD"},
				-- Prismatic Barrier
				{AuraID = 235450, filter = "CD"},
				-- Ice Barrier
				{AuraID = 11426, filter = "CD"},
				-- Temporal Shield
				{AuraID = 198111, filter = "CD"},
				-- Fire Blast
				{AuraID = 108853, filter = "CD"},
				-- Cone of Cold
				{AuraID = 120, filter = "CD"},
				-- Comet Storm
				{AuraID = 153595, filter = "CD"},
				-- Ice Floes
				{AuraID = 108839, filter = "CD"},
				-- Ebonbolt
				{AuraID = 214634, filter = "CD"},
				-- Phoenix's Flames
				{AuraID = 194466, filter = "CD"},
				-- Mark of Aluneth
				{AuraID = 224968, filter = "CD"},
				-- Frozen Orb
				{AuraID = 84714, filter = "CD"},
				-- Meteor
				{AuraID = 153561, filter = "CD"},
				-- Dragon's Breath
				{AuraID = 31661, filter = "CD"},
				-- Arcane Power
				{AuraID = 12042, filter = "CD"},
				-- Rune of Power
				{AuraID = 116011, filter = "CD"},
				-- Presence of Mind
				{AuraID = 205025, filter = "CD"},
				-- Displacement
				{AuraID = 195676, filter = "CD"},
				-- Charged Up
				{AuraID = 205032, filter = "CD"},
				-- Supernova
				{AuraID = 157980, filter = "CD"},
				-- Evocation
				{AuraID = 12051, filter = "CD"},
				-- Icy Veins
				{AuraID = 12472, filter = "CD"},
				-- Mirror Image
				{AuraID = 55342, filter = "CD"},
				-- Combustion
				{AuraID = 190319, filter = "CD"},
				-- Cold Snap
				{AuraID = 235219, filter = "CD"},
				-- Ice Block
				{AuraID = 45438, filter = "CD"},
				-- Invisibility
				{AuraID = 66, filter = "CD"},

				-- PvP
				-- Honorable Medallion
				{AuraID = 195710, filter = "CD"},

				-- Racial
				-- Arcane Torrent (Blood Elf)
				{AuraID = 69179, filter = "CD"},
				-- Berserking (Troll)
				{AuraID = 26297, filter = "CD"},
				-- Blood Fury (Orc)
				{AuraID = 20572, filter = "CD"},
				-- Cannibalize (Forsaken)
				{AuraID = 20577, filter = "CD"},
				-- Darkflight (Worgen)
				{AuraID = 68992, filter = "CD"},
				-- Escape Artist (Gnome)
				{AuraID = 20589, filter = "CD"},
				-- Every Man for Himself (Human)
				{AuraID = 59752, filter = "CD"},
				-- Gift of the Naaru (Draenei)
				{AuraID = 28880, filter = "CD"},
				-- Quaking Palm (Pandaren)
				{AuraID = 107079, filter = "CD"},
				-- Rocket Jump (Goblin)
				{AuraID = 69070, filter = "CD"},
				-- Shadowmeld (Night Elf)
				{AuraID = 58984, filter = "CD"},
				-- Stoneform (Dwarf)
				{AuraID = 20594, filter = "CD"},
				-- Will of the Forsaken (Forsaken)
				{AuraID = 7744, filter = "CD"},
			}
		},
	},
	["PALADIN"] = {
		{
			Name = "玩家增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 12}, 
			List = {
				-- Inquisition
				{AuraID = 84963, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Shield of Vengeance
				{AuraID = 184662, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Eye for an Eye
				{AuraID = 205191, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Crusade
				{AuraID = 231895, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Divine Shield
				{AuraID = 642, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Guardian of Ancient Kings
				{AuraID = 86659, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Holy Avenger
				{AuraID = 105809, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Avenging Wrath
				{AuraID = 31884, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Seraphim
				{AuraID = 152262, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Ardent Defender
				{AuraID = 31850, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Divine Protection
				{AuraID = 498, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Rule of Law
				{AuraID = 214202, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Shield of the Righteous
				{AuraID = 132403, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Speed of Light
				{AuraID = 85499, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Eternal Flame
				--BETA {AuraID = 114163, UnitID = "player", Caster = "player", filter = "BUFF"},
			}
		},
		{
			Name = "玩家重要增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 55},
			List = {
				-- Buffs
				-- Righteous Verdict
				{AuraID = 267611, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Infusion of Light
				{AuraID = 54149, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Selfless Healer
				{AuraID = 114250, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Divine Purpose
				{AuraID = 223819, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Grand Crusader
				{AuraID = 85416, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Final Verdict
				{AuraID = 157048, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- The Fires of Justice
				{AuraID = 209785, UnitID = "player", Caster = "player", filter = "BUFF"},

				-- Trinkets
				
				-- Enchants
			}
		},
		{
			Name = "目标减益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 68}, 
			List = {
				-- Execution Sentence
				{AuraID = 267799, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Eye of Tyr
				{AuraID = 209202, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Forbearance
				{AuraID = 25771, UnitID = "player", Caster = "all", filter = "DEBUFF"},
				-- Judgment
				{AuraID = 197277, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Hand of Hindrance
				{AuraID = 183218, UnitID = "target", Caster = "player", filter = "DEBUFF"},

				-- Trinket Effects
			}
		},
		{
			Name = "冷却监视",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 48,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 99},
			List = {
				-- Self
				-- Eye of Tyr
				{AuraID = 209202, filter = "CD"},
				-- Cleanse
				{AuraID = 4987, filter = "CD"},
				-- Rebuke
				{AuraID = 96231, filter = "CD"},
				-- Repentance
				{AuraID = 20066, filter = "CD"},
				-- Hammer of Justice
				{AuraID = 853, filter = "CD"},
				-- Judgment
				{AuraID = 20271, filter = "CD"},
				-- Consecration
				{AuraID = 26573, filter = "CD"},
				-- Avenger's Shield
				{AuraID = 31935, filter = "CD"},
				-- Bestow Faith
				{AuraID = 223306, filter = "CD"},
				-- Light of Dawn
				{AuraID = 85222, filter = "CD"},
				-- Holy Prism
				{AuraID = 114165, filter = "CD"},
				-- Blessing of Freedom
				{AuraID = 1044, filter = "CD"},
				-- Seraphim
				{AuraID = 152262, filter = "CD"},
				-- Rule of Law
				{AuraID = 214202, filter = "CD"},
				-- Speed of Light
				{AuraID = 85499, filter = "CD"},
				-- Divine Protection
				{AuraID = 498, filter = "CD", absID = true},
				-- Execution Sentence
				--BETA {AuraID = 213757, filter = "CD"},
				-- Light's Hammer
				{AuraID = 114158, filter = "CD"},
				-- Blinding Light
				{AuraID = 115750, filter = "CD"},
				-- Holy Avenger
				{AuraID = 105809, filter = "CD"},
				-- Holy Wrath
				{AuraID = 210220, filter = "CD"},
				-- Aura Mastery
				{AuraID = 31821, filter = "CD"},
				-- Blessing of Sacrifice
				{AuraID = 6940, filter = "CD"},
				-- Avenging Wrath
				{AuraID = 31884, filter = "CD"},
				-- Ardent Defender
				{AuraID = 31850, filter = "CD", absID = true},
				-- Guardian of Ancient Kings
				{AuraID = 86659, filter = "CD"},
				-- Blessing of Protection
				{AuraID = 1022, filter = "CD"},

				-- PvP
				-- Honorable Medallion
				{AuraID = 195710, filter = "CD"},

				-- Racial
				-- Arcane Torrent (Blood Elf)
				{AuraID = 69179, filter = "CD"},
				-- Every Man for Himself (Human)
				{AuraID = 59752, filter = "CD"},
				-- Gift of the Naaru (Draenei)
				{AuraID = 28880, filter = "CD"},
				-- Stoneform (Dwarf)
				{AuraID = 20594, filter = "CD"},
				-- War Stomp (Tauren)
				{AuraID = 20549, filter = "CD"},
			}
		},
	},
	["PRIEST"] = {
		{
			Name = "玩家增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 12}, 
			List = {
				-- Rapture
				{AuraID = 47536, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Desperate Prayer
				{AuraID = 19236, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Voidform
				{AuraID = 194249, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Dispersion
				{AuraID = 47585, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Power Infusion
				{AuraID = 10060, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Apotheosis
				{AuraID = 200183, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Blessing of T'uure
				{AuraID = 196644, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Spirit of Redemption
				{AuraID = 20711, UnitID = "player", Caster = "all", filter = "BUFF"},
				-- Divinity
				{AuraID = 197030, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Power of the Naaru
				{AuraID = 196490, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Archangel
				{AuraID = 197862, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Vampiric Embrace
				{AuraID = 15286, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Focused Will
				{AuraID = 45242, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Spectral Guise
				{AuraID = 112833, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Fade
				{AuraID = 586, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Spirit Shell
				{AuraID = 109964, UnitID = "player", Caster = "player", filter = "BUFF", absID = true},
				-- Power Word: Shield
				{AuraID = 17, UnitID = "player", Caster = "all", filter = "BUFF"},
				-- Renew
				{AuraID = 139, UnitID = "player", Caster = "player", filter = "BUFF"},
			}

		},
		{
			Name = "玩家重要增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 55},
			List = {
				-- Buffs
				-- Power of the Dark Side
				{AuraID = 198069, UnitID = "player", Caster = "player", filter = "BUFF"},			
				-- Lingering Insanity
				{AuraID = 197937, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Shadowy Insight
				{AuraID = 124430, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Surge of Light
				{AuraID = 114255, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Surge of Darkness
				{AuraID = 87160, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Twist of Fate
				{AuraID = 123254, UnitID = "player", Caster = "player", filter = "BUFF"},

				-- Trinkets
				
				-- Enchants
			}
		},
		{
			Name = "目标减益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 68}, 
			List = {
				-- Schism
				{AuraID = 214621, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Renew
				{AuraID = 139, UnitID = "target", Caster = "player", filter = "BUFF"},
				-- Prayer of Mending
				{AuraID = 41635, UnitID = "target", Caster = "player", filter = "BUFF"},
				-- Guardian Spirit
				{AuraID = 47788, UnitID = "target", Caster = "player", filter = "BUFF"},
				-- Pain Suppression
				{AuraID = 33206, UnitID = "target", Caster = "player", filter = "BUFF"},
				-- Void Entropy
				--BETA {AuraID = 155361, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Vampiric Touch
				{AuraID = 34914, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Shadow Word: Pain
				{AuraID = 589, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Purge the Wicked
				{AuraID = 204197, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Light of T'uure
				{AuraID = 208065, UnitID = "target", Caster = "player", filter = "BUFF"},
				-- Trinket Effects
			}
		},
		{
			Name = "冷却监视",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 48,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 99},
			List = {
				-- Self
				-- Purify
				{AuraID = 527, filter = "CD"},
				-- Mass Dispel
				{AuraID = 32375, filter = "CD"},
				-- Penance
				{AuraID = 47540, filter = "CD"},
				-- Mind Blast
				{AuraID = 8092, filter = "CD"},
				-- Power Word: Shield
				{AuraID = 17, filter = "CD"},
				-- Holy Fire
				{AuraID = 14914, filter = "CD"},
				-- Shadow Word: Death
				{AuraID = 32379, filter = "CD"},
				-- Circle of Healing
				{AuraID = 204883, filter = "CD"},
				-- Angelic Feather
				{AuraID = 121536, filter = "CD"},
				-- Prayer of Mending
				{AuraID = 33076, filter = "CD"},
				-- Divine Star
				{AuraID = 110744, filter = "CD"},
				-- Archangel
				{AuraID = 197862, filter = "CD"},
				-- Holy Word: Sanctify
				{AuraID = 34861, filter = "CD"},
				-- Holy Word: Chastise
				{AuraID = 88625, filter = "CD"},
				-- Holy Word: Serenity
				{AuraID = 2050, filter = "CD"},
				-- Spectral Guise
				{AuraID = 112833, filter = "CD"},
				-- Fade
				{AuraID = 586, filter = "CD"},
				-- Halo
				{AuraID = 120517, filter = "CD"},
				-- Psychic Scream
				{AuraID = 8122, filter = "CD"},
				-- Psychic Horror
				{AuraID = 64044, filter = "CD"},
				-- Silence
				{AuraID = 15487, filter = "CD"},
				-- Leap of Faith
				{AuraID = 73325, filter = "CD"},
				-- Power Infusion
				{AuraID = 10060, filter = "CD"},
				-- Dispersion
				{AuraID = 47585, filter = "CD"},
				-- Desperate Prayer
				{AuraID = 19236, filter = "CD"},
				-- Shining Force
				{AuraID = 204263, filter = "CD"},
				-- Pain Suppression
				{AuraID = 33206, filter = "CD"},
				-- Guardian Spirit
				{AuraID = 47788, filter = "CD"},
				-- Power Word: Barrier
				{AuraID = 62618, filter = "CD"},
				-- Divine Hymn
				{AuraID = 64843, filter = "CD"},
				-- Symbol of Hope
				{AuraID = 64901, filter = "CD"},
				-- Apotheosis
				{AuraID = 200183, filter = "CD"},
				-- Shadowfiend
				{AuraID = 34433, filter = "CD"},
				-- Void Eruption
				{AuraID = 228260, filter = "CD"},
				-- Light of T'uure
				{AuraID = 208065, filter = "CD"},
				-- Light's Wrath
				{AuraID = 207946, filter = "CD"},

				-- PvP
				-- Honorable Medallion
				{AuraID = 195710, filter = "CD"},

				-- Racial
				-- Arcane Torrent (Blood Elf)
				{AuraID = 69179, filter = "CD"},
				-- Berserking (Troll)
				{AuraID = 26297, filter = "CD"},
				-- Cannibalize (Forsaken)
				{AuraID = 20577, filter = "CD"},
				-- Darkflight (Worgen)
				{AuraID = 68992, filter = "CD"},
				-- Escape Artist (Gnome)
				{AuraID = 20589, filter = "CD"},
				-- Every Man for Himself (Human)
				{AuraID = 59752, filter = "CD"},
				-- Gift of the Naaru (Draenei)
				{AuraID = 28880, filter = "CD"},
				-- Quaking Palm (Pandaren)
				{AuraID = 107079, filter = "CD"},
				-- Rocket Jump (Goblin)
				{AuraID = 69070, filter = "CD"},
				-- Shadowmeld (Night Elf)
				{AuraID = 58984, filter = "CD"},
				-- Stoneform (Dwarf)
				{AuraID = 20594, filter = "CD"},
				-- War Stomp (Tauren)
				{AuraID = 20549, filter = "CD"},
				-- Will of the Forsaken (Forsaken)
				{AuraID = 7744, filter = "CD"},
			}
		},
	},
	["ROGUE"] = {
		{
			Name = "玩家增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 12}, 
			List = {
				-- Slice and Dice
				{AuraID = 5171, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Adrenaline Rush
				{AuraID = 13750, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Evasion
				{AuraID = 5277, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Envenom
				{AuraID = 32645, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Shadow Dance
				{AuraID = 185313, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Symbols of Death
				{AuraID = 212283, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Shadow Blades
				{AuraID = 121471, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Curse of the Dreadblades
				{AuraID = 208245, UnitID = "player", Caster = "player", filter = "DEBUFF"},
				-- Alacrity
				{AuraID = 193539, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Master of Subtlety
				{AuraID = 31665, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Cloak of Shadows
				{AuraID = 31224, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Vanish
				{AuraID = 1856, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Combat Readiness
				{AuraID = 74001, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Combat Insight
				{AuraID = 74002, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Shadow Reflection
				{AuraID = 152151, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Cheating Death
				{AuraID = 45182, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Blade Flurry
				{AuraID = 13877, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Burst of Speed
				{AuraID = 108212, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Sprint
				{AuraID = 2983, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Feint
				{AuraID = 1966, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Subterfuge
				{AuraID = 115192, UnitID = "player", Caster = "player", filter = "BUFF"},
			}
		},
		{
			Name = "玩家重要增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 55},
			List = {
				-- Buffs
				-- Shuriken Combo
				{AuraID = 245640, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Jolly Roger
				{AuraID = 199603, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Grand Melee
				{AuraID = 193358, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- True Bearing
				{AuraID = 193359, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Buried Treasure
				{AuraID = 199600, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Broadsides
				{AuraID = 193356, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Shark Infested Waters
				{AuraID = 193357, UnitID = "player", Caster = "player", filter = "BUFF"},

				-- Item Sets
				
				-- Trinkets
				
				-- Enchants
			}
			
		},
		{
			Name = "目标减益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 68}, 
			List = {
				-- Rupture
				{AuraID = 1943, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Garrote
				{AuraID = 703, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Gouge
				{AuraID = 1776, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Hemorrhage
				{AuraID = 16511, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Find Weakness
				{AuraID = 91021, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Vendetta
				{AuraID = 79140, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Nightblade
				{AuraID = 195452, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Ghostly Strike
				{AuraID = 196937, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Deadly Poison
				{AuraID = 2818, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Crippling Poison
				{AuraID = 3409, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Wound Poison
				{AuraID = 8680, UnitID = "target", Caster = "player", filter = "DEBUFF"},
			}
		},
		{
			Name = "冷却监视",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 48,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 99},
			List = {
				-- Self
				-- Stealth
				{AuraID = 1784, filter = "CD"},
				-- Kick
				{AuraID = 1766, filter = "CD"},
				-- Gouge
				{AuraID = 1776, filter = "CD"},
				-- Kidney Shot
				{AuraID = 408, filter = "CD"},
				-- Death from Above
				{AuraID = 152150, filter = "CD"},
				-- Sprint
				{AuraID = 2983, filter = "CD"},
				-- Shadow Dance
				{AuraID = 185313, filter = "CD"},
				-- Marked for Death
				{AuraID = 137619, filter = "CD"},
				-- Killing Spree
				{AuraID = 51690, filter = "CD"},
				-- Vendetta
				{AuraID = 79140, filter = "CD"},
				-- Shadow Reflection
				{AuraID = 152151, filter = "CD"},
				-- Combat Readiness
				{AuraID = 74001, filter = "CD"},
				-- Vanish
				{AuraID = 1856, filter = "CD"},
				-- Adrenaline Rush
				{AuraID = 13750, filter = "CD"},
				-- Between the Eyes
				{AuraID = 199804, filter = "CD"},
				-- Riposte
				{AuraID = 199754, filter = "CD"},
				-- Cloak of Shadows
				{AuraID = 31224, filter = "CD"},
				-- Grappling Hook
				{AuraID = 195457, filter = "CD"},
				-- Crimson Vial
				{AuraID = 185311, filter = "CD"},
				-- Cannonball Barrage
				--BETA {AuraID = 185767, filter = "CD"},
				-- Garrote
				{AuraID = 703, filter = "CD"},
				-- Exsanguinate
				{AuraID = 200806, filter = "CD"},
				-- Shadowstep
				{AuraID = 36554, filter = "CD"},
				-- Evasion
				{AuraID = 5277, filter = "CD"},

				-- PvP
				-- Honorable Medallion
				{AuraID = 195710, filter = "CD"},

				-- Racial
				-- Arcane Torrent (Blood Elf)
				{AuraID = 69179, filter = "CD"},
				-- Berserking (Troll)
				{AuraID = 26297, filter = "CD"},
				-- Blood Fury (Orc)
				{AuraID = 20572, filter = "CD"},
				-- Cannibalize (Forsaken)
				{AuraID = 20577, filter = "CD"},
				-- Darkflight (Worgen)
				{AuraID = 68992, filter = "CD"},
				-- Escape Artist (Gnome)
				{AuraID = 20589, filter = "CD"},
				-- Every Man for Himself (Human)
				{AuraID = 59752, filter = "CD"},
				-- Quaking Palm (Pandaren)
				{AuraID = 107079, filter = "CD"},
				-- Rocket Jump (Goblin)
				{AuraID = 69070, filter = "CD"},
				-- Shadowmeld (Night Elf)
				{AuraID = 58984, filter = "CD"},
				-- Stoneform (Dwarf)
				{AuraID = 20594, filter = "CD"},
				-- Will of the Forsaken (Forsaken)
				{AuraID = 7744, filter = "CD"},
			}
		},
	},
	["SHAMAN"] = {
		{
			Name = "玩家增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 12}, 
			List = {
				-- Elemental Mastery
				{AuraID = 16166, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Ascendance
				{AuraID = 114049, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Spiritwalker's Grace
				{AuraID = 79206, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Unleash Life
				{AuraID = 73685, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Doom Winds
				{AuraID = 204945, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Landslide
				{AuraID = 202004, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Stone Bulwark
				{AuraID = 114893, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Ancestral Guidance
				{AuraID = 108281, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Astral Shift
				{AuraID = 108271, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Fury of Air
				{AuraID = 197211, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Windsong
				{AuraID = 201898, UnitID = "player", Caster = "player", filter = "BUFF"},
			}
		},
		{
			Name = "玩家重要增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 55},
			List = {
				-- Buffs
				-- Lava Surge
				{AuraID = 77762, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Elemental Blast
				{AuraID = 118522, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Tidal Waves
				{AuraID = 53390, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Stormlash
				{AuraID = 195222, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Stormbringer
				{AuraID = 201846, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Crash Lightning
				{AuraID = 187878, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Frostbrand
				{AuraID = 196834, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Flametongue
				{AuraID = 194084, UnitID = "player", Caster = "player", filter = "BUFF"},

				-- Item Sets
				
				-- Trinkets
				
				-- Enchants
			}
		},
		{
			Name = "目标减益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 68}, 
			List = {
				-- Stormstrike
				{AuraID = 17364, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Flame Shock
				{AuraID = 188389, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Frost Shock
				{AuraID = 196840, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Earthgrab
				{AuraID = 64695, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Earthen Spike
				{AuraID = 188089, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Trinket Effects
			}
		},
		{
			Name = "冷却监视",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 48,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 99},
			List = {
				-- Self
				-- Cleanse Spirit
				{AuraID = 51886, filter = "CD"},
				-- Wind Shear
				{AuraID = 57994, filter = "CD"},
				-- Hex
				{AuraID = 51514, filter = "CD"},
				-- Riptide
				{AuraID = 61295, filter = "CD"},
				-- Healing Rain
				{AuraID = 73920, filter = "CD"},
				-- Crash Lightning
				{AuraID = 187874, filter = "CD"},
				-- Stormstrike
				{AuraID = 17364, filter = "CD"},
				-- Lava Burst
				{AuraID = 51505, filter = "CD"},
				-- Elemental Blast
				{AuraID = 117014, filter = "CD"},
				-- Flametongue
				{AuraID = 193796, filter = "CD"},
				-- Feral Lunge
				{AuraID = 196884, filter = "CD"},
				-- Cloudburst Totem
				{AuraID = 157153, filter = "CD"},
				-- Earthbind Totem
				{AuraID = 2484, filter = "CD"},
				-- Thunderstorm
				{AuraID = 51490, filter = "CD"},
				-- Windsong
				{AuraID = 201898, filter = "CD"},
				-- Stone Bulwark Totem
				{AuraID = 108270, filter = "CD"},
				-- Capacitor Totem
				{AuraID = 192058, filter = "CD"},
				-- Doom Winds
				{AuraID = 204945, filter = "CD"},
				-- Astral Shift
				{AuraID = 108271, filter = "CD"},
				-- Ancestral Guidance
				{AuraID = 108281, filter = "CD"},
				-- Spiritwalker's Grace
				{AuraID = 79206, filter = "CD"},
				-- Feral Spirit
				{AuraID = 51533, filter = "CD"},
				-- Ascendance
				{AuraID = 114049, filter = "CD"},

				-- PvP
				-- Honorable Medallion
				{AuraID = 195710, filter = "CD"},

				-- Racial
				-- Berserking (Troll)
				{AuraID = 26297, filter = "CD"},
				-- Blood Fury (Orc)
				{AuraID = 20572, filter = "CD"},
				-- Gift of the Naaru (Draenei)
				{AuraID = 28880, filter = "CD"},
				-- Quaking Palm (Pandaren)
				{AuraID = 107079, filter = "CD"},
				-- Rocket Jump (Goblin)
				{AuraID = 69070, filter = "CD"},
				-- Stoneform (Dwarf)
				{AuraID = 20594, filter = "CD"},
				-- War Stomp (Tauren)
				{AuraID = 20549, filter = "CD"},

				-- Items
				-- Back
				{slotID = 15, filter = "CD"},
				-- Belt
				{slotID = 6, filter = "CD"},
				-- Gloves
				{slotID = 10, filter = "CD"},
				-- Neck
				{slotID = 2, filter = "CD"},
				-- Rings
				{slotID = 11, filter = "CD"},
				{slotID = 12, filter = "CD"},
				-- Trinkets
				{slotID = 13, filter = "CD"},
				{slotID = 14, filter = "CD"},
			}
		},
	},
	["WARLOCK"] = {
		{
			Name = "玩家增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 12}, 
			List = {
				-- Dark Soul: Misery
				{AuraID = 113860, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Dark Soul: Instability
				{AuraID = 113858, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Deadwind Harvester
				{AuraID = 216708, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Unending Resolve
				{AuraID = 104773, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Soul Harvest
				{AuraID = 196098, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Empowered Life Tap
				{AuraID = 235156, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Soul Swap
				{AuraID = 86211, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Dark Regeneration
				{AuraID = 108359, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Burning Rush
				{AuraID = 111400, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Sacrificial Pact
				{AuraID = 108416, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Healthstone
				{AuraID = 6262, UnitID = "player", Caster = "player", filter = "BUFF"},
			}
		},
		{
			Name = "玩家重要增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 55},
			List = {
				-- Buffs
				-- Backdraft
				{AuraID = 117828, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Grimore of Synergy
				{AuraID = 171982, UnitID = "player", Caster = "player", filter = "BUFF"},

				-- Trinkets
				
				-- Enchants
			}
		},
		{
			Name = "目标减益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 68}, 
			List = {
				-- Self
				-- Enslave Demon
				{AuraID = 1098, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Havoc
				{AuraID = 80240, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Doom
				{AuraID = 603, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Agony
				{AuraID = 980, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Corruption
				{AuraID = 146739, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Seed of Corruption
				{AuraID = 27243, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Immolate
				{AuraID = 348, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Unstable Affliction
				{AuraID = 233490, UnitID = "target", Caster = "player", filter = "DEBUFF", absID = true},
				-- Unstable Affliction 2nd
				{AuraID = 233496, UnitID = "target", Caster = "player", filter = "DEBUFF", absID = true},
				-- Unstable Affliction 3rd
				{AuraID = 233497, UnitID = "target", Caster = "player", filter = "DEBUFF", absID = true},
				-- Unstable Affliction 4th
				{AuraID = 233498, UnitID = "target", Caster = "player", filter = "DEBUFF", absID = true},
				-- Unstable Affliction 5th
				{AuraID = 233499, UnitID = "target", Caster = "player", filter = "DEBUFF", absID = true},
				-- Siphon Life
				{AuraID = 63106, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Soul Effigy
				{AuraID = 205178, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Phantom Singularity
				{AuraID = 205179, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Haunt
				{AuraID = 48181, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Shadowflame
				{AuraID = 205181, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Eradication
				{AuraID = 196414, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Trinket Effects
			}
		},
		{
			Name = "冷却监视",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 48,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 99},
			List = {
				-- Self
				-- Devour Magic (Felhunter)
				{AuraID = 19505, filter = "CD"},
				-- Spell Lock (Felhunter)
				{AuraID = 19647, filter = "CD"},
				-- Shadowfury
				{AuraID = 30283, filter = "CD"},
				-- Howl of Terror
				{AuraID = 5484, filter = "CD"},
				-- Mortal Coil
				{AuraID = 6789, filter = "CD"},
				-- Demonic Circle
				{AuraID = 48018, filter = "CD"},
				-- Felstorm
				{AuraID = 89751, filter = "CD"},
				-- Cataclysm
				{AuraID = 152108, filter = "CD"},
				-- Soul Harvest
				{AuraID = 196098, filter = "CD"},
				-- Grimoire of Service
				{AuraID = 108501, filter = "CD"},
				-- Shadowflame
				{AuraID = 205181, filter = "CD"},
				-- Summon Darkglare
				{AuraID = 205180, filter = "CD"},

				-- PvP
				-- Honorable Medallion
				{AuraID = 195710, filter = "CD"},

				-- Racial
				-- Arcane Torrent (Blood Elf)
				{AuraID = 69179, filter = "CD"},
				-- Berserking (Troll)
				{AuraID = 26297, filter = "CD"},
				-- Blood Fury (Orc)
				{AuraID = 20572, filter = "CD"},
				-- Cannibalize (Forsaken)
				{AuraID = 20577, filter = "CD"},
				-- Darkflight (Worgen)
				{AuraID = 68992, filter = "CD"},
				-- Escape Artist (Gnome)
				{AuraID = 20589, filter = "CD"},
				-- Every Man for Himself (Human)
				{AuraID = 59752, filter = "CD"},
				-- Rocket Jump (Goblin)
				{AuraID = 69070, filter = "CD"},
				-- Stoneform (Dwarf)
				{AuraID = 20594, filter = "CD"},
				-- Will of the Forsaken (Forsaken)
				{AuraID = 7744, filter = "CD"},
			}
		},
	},
	["WARRIOR"] = {
		{
			Name = "玩家增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 12}, 
			List = {
				-- In For The Kill
				{AuraID = 248622, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Deadly Calm
				{AuraID = 262228, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Sweeping Strikes
				{AuraID = 260708, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Ignore Pain
				{AuraID = 190456, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Shield Wall
				{AuraID = 871, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Last Stand
				{AuraID = 12975, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Enraged Regeneration
				{AuraID = 184364, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Shield Block
				{AuraID = 2565, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Spell Reflection
				{AuraID = 23920, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Ravager
				{AuraID = 152277, UnitID = "player", Caster = "player", filter = "BUFF", spec = 3},
				-- Die by the Sword
				{AuraID = 118038, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Berserker Rage
				{AuraID = 18499, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Avatar
				{AuraID = 107574, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Bloodbath
				{AuraID = 12292, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Recklesness
				{AuraID = 1719, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Victorious
				{AuraID = 32216, UnitID = "player", Caster = "player", filter = "BUFF"},
			}
		},
		{
			Name = "玩家重要增益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 55},
			List = {
				-- Overpower
				{AuraID = 7384, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Frothing Berserker
				{AuraID = 215572, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Furious Slash
				{AuraID = 202539, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Vengeance: Ignore Pain
				{AuraID = 202574, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Sudden Death
				{AuraID = 52437, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Raging Blow!
				{AuraID = 131116, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Ultimatum
				--BETA {AuraID = 122510, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Meat Cleaver
				{AuraID = 85739, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Unyielding Strikes
				--BETA {AuraID = 169686, UnitID = "player", Caster = "player", filter = "BUFF"},
				-- Enrage
				{AuraID = 184362, UnitID = "player", Caster = "player", filter = "BUFF"},

				-- Trinkets
				
				-- Enchants
			}
		},
		{
			Name = "目标减益",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 42,
			Pos = {"BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 68}, 
			List = {
				-- Siegebreaker
				{AuraID = 280773, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Rend
				{AuraID = 772, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Colossus Smash
				{AuraID = 167105, UnitID = "target", Caster = "player", filter = "DEBUFF"},
				-- Hamstring
				{AuraID = 1715, UnitID = "target", Caster = "all", filter = "DEBUFF"},
				-- Demoralizing Shout
				{AuraID = 1160, UnitID = "target", Caster = "all", filter = "DEBUFF"},

				-- Trinket Effects
			}
		},
		{
			Name = "冷却监视",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = 48,
			Pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 99},
			List = {
				-- Self
				-- Pummel
				{AuraID = 6552, filter = "CD"},
				-- Shield Slam
				{AuraID = 23922, filter = "CD"},
				-- Shockwave
				{AuraID = 46968, filter = "CD"},
				-- Storm Bolt
				{AuraID = 107570, filter = "CD"},
				-- Thunder Clap
				{AuraID = 6343, filter = "CD"},
				-- Taunt
				{AuraID = 355, filter = "CD"},
				-- Colossus Smash
				{AuraID = 167105, filter = "CD"},
				-- Charge
				{AuraID = 100, filter = "CD"},
				-- Spell Reflection
				{AuraID = 23920, filter = "CD"},
				-- Intervene
				--BETA {AuraID = 3411, filter = "CD"},
				-- Berserker Rage
				{AuraID = 18499, filter = "CD"},
				-- Heroic Leap
				{AuraID = 6544, filter = "CD"},
				-- Demoralizing Shout
				{AuraID = 1160, filter = "CD"},
				-- Enraged Regeneration
				{AuraID = 184364, filter = "CD"},
				-- Ravager
				{AuraID = 152277, filter = "CD"},
				-- Intimidating Shout
				{AuraID = 5246, filter = "CD"},
				-- Last Stand
				{AuraID = 12975, filter = "CD"},
				-- Rallying Cry
				{AuraID = 97462, filter = "CD"},
				-- Shield Wall
				{AuraID = 871, filter = "CD"},
				-- Odyn's Fury
				{AuraID = 205545, filter = "CD"},
				-- Battle Cry
				{AuraID = 1719, filter = "CD"},
				-- Avatar
				{AuraID = 107574, filter = "CD"},

				-- PvP
				-- Honorable Medallion
				{AuraID = 195710, filter = "CD"},

				-- Racial
				-- Arcane Torrent (Blood Elf)
				{AuraID = 69179, filter = "CD"},
				-- Berserking (Troll)
				{AuraID = 26297, filter = "CD"},
				-- Blood Fury (Orc)
				{AuraID = 20572, filter = "CD"},
				-- Cannibalize (Forsaken)
				{AuraID = 20577, filter = "CD"},
				-- Darkflight (Worgen)
				{AuraID = 68992, filter = "CD"},
				-- Escape Artist (Gnome)
				{AuraID = 20589, filter = "CD"},
				-- Every Man for Himself (Human)
				{AuraID = 59752, filter = "CD"},
				-- Gift of the Naaru (Draenei)
				{AuraID = 28880, filter = "CD"},
				-- Quaking Palm (Pandaren)
				{AuraID = 107079, filter = "CD"},
				-- Rocket Jump (Goblin)
				{AuraID = 69070, filter = "CD"},
				-- Shadowmeld (Night Elf)
				{AuraID = 58984, filter = "CD"},
				-- Stoneform (Dwarf)
				{AuraID = 20594, filter = "CD"},
				-- War Stomp (Tauren)
				{AuraID = 20549, filter = "CD"},
				-- Will of the Forsaken (Forsaken)
				{AuraID = 7744, filter = "CD"},
			}
		},
	}
}
