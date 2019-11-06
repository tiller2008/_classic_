local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

P.general.objectiveFrameHeight = 620
P.general.font = "EUI"
P.general.valuecolor = {r = 23/255,g = 132/255,b = 209/255}
P.general.minimap.locationFont = 'EUI'

P.databars.experience.font = 'EUI'
P.databars.reputation.font = 'EUI'

P.bags.xOffset = 0
P.bags.yOffset = 0
P.bags.xOffsetBank = 0
P.bags.yOffsetBank = 0
P.bags.itemLevelFont = 'EUI'
P.bags.itemLevelFontOutline = 'OUTLINE'
P.bags.countFont = 'EUI'
P.bags.countFontOutline = 'OUTLINE'

P.auras.font = 'EUI'
P.auras.fontSize = 10
P.auras.fontOutline = 'OUTLINE'
P.chat.font = 'EUI'
P.chat.chatHistory = false
P.chat.numScrollMessages = 1
P.chat.tabFont = 'EUI'
P.chat.combatLeft = false
P.chat.combatRight = false

P.datatexts.font = 'EUI'
P.tooltip.font = "EUI"
P.tooltip.healthBar.font = 'EUI'
P.tooltip.azerite = true
P.tooltip.inspectInfo = true

P.unitframe.toggleForVehicle = true
P.unitframe.font = 'EUI'
P.unitframe.fontOutline = 'OUTLINE'
P.unitframe.colors.borderColor = {r = 0.31, g = 0.31, b = 0.31}
P.unitframe.colors.targetGlowColor = { r = 1,g = 1,b = .5 }
P.unitframe.units.player.portrait.detachedWidth = 48
P.unitframe.units.player.portrait.detachedHeight = 48
P.unitframe.units.player.portrait.parent = "FRAME"
P.unitframe.units.player.portrait.detachFromFrame = false
P.unitframe.units.target.portrait.detachedWidth = 48
P.unitframe.units.target.portrait.detachedHeight = 48
P.unitframe.units.target.portrait.parent = "FRAME"
P.unitframe.units.target.portrait.detachFromFrame = false
P.unitframe.units.target.DragonOverlayStyle = 'none'
P.unitframe.units.party.debuffs.priority = 'Blacklist,Boss,RaidDebuffs,CCDebuffs,Dispellable,Whitelist,ShowAll'
P.unitframe.units.party.rdebuffs.font = 'EUI'
P.unitframe.units.party.rdebuffs.fontOutline = 'OUTLINE'

P.unitframe.units.raid.rdebuffs.font = 'EUI'
P.unitframe.units.raid.rdebuffs.fontOutline = 'OUTLINE'
P.unitframe.units.raidpet.rdebuffs.font = 'EUI'
P.unitframe.units.raidpet.rdebuffs.fontOutline = 'OUTLINE'

P.actionbar.font = 'EUI'
P.actionbar.fontOutline = 'OUTLINE'
P.actionbar.addNewSpells = true

P.nameplates.motionType = 'OVERLAP'
P.nameplates.clampToScreen = true


P.Sequences = {
	enable = true,
--	MacroList = {}
}

P.Myslot = {
	sets = {},
}

local DefaultEnableWeaponSwingTimer = {
	['WARRIOR'] = true,
	['ROGUE'] = true,
	['HUNTER'] = true,
}

P.SingleAddons = {
	["HandyNotes_DungeonLocations"] = true,
	["HandyNotes_NPCs"] = true,

	["MikScrollingBattleText"] = true,
	["OfflineDataCenter"] = true,

	["Recount"] = true,
	["GSE"] = true,
	["MerInspect"] = true,
	["Mapster"] = true,
	["ClassicCodex"] = true,
	["WeaponSwingTimer"] = DefaultEnableWeaponSwingTimer[E.myclass],
	["AtlasLootClassic"] = true,
	["AuctionFaster"] = true,
	["ClassicThreatMeter"] = false,
	["Masque"] = true,
	["Ex_AutoEquip"] = true,
	["GatherMate2"] = true,
	["ButterQuestTracker"] = true,
	["SilverDragon"] = true,
	["FriendsMenuXP"] = true,
	["WebDKP"] = false,
	["ExRT"] = false,
}

P.cooldown.fontSize = 20

P.combattext = {
	enable = true,							-- Global enable combat text
	blizz_head_numbers = false,				-- Use blizzard damage/healing output(above mob/player head)
	damage_style = true,					-- Change default damage/healing font above mobs/player heads(you need to restart WoW to see changes)
	damage = true,							-- Show outgoing damage in it's own frame
	healing = true,							-- Show outgoing healing in it's own frame
	show_hots = true,						-- Show periodic healing effects in healing frame
	show_overhealing = true,				-- Show outgoing overhealing
	pet_damage = true,						-- Show your pet damage
	dot_damage = true,						-- Show damage from your dots
	damage_color = true,					-- Display damage numbers depending on school of magic
	crit_prefix = "*",						-- Symbol that will be added before crit
	crit_postfix = "*",						-- Symbol that will be added after crit
	icons = true,							-- Show outgoing damage icons
	icon_size = 16,							-- Icon size of spells in outgoing damage frame, also has effect on dmg font size
	treshold = 1,							-- Minimum damage to show in damage frame
	heal_treshold = 1,						-- Minimum healing to show in incoming/outgoing healing messages
	scrollable = false,						-- Allows you to scroll frame lines with mousewheel
	max_lines = 15,							-- Max lines to keep in scrollable mode(more lines = more memory)
	time_visible = 3,						-- Time(seconds) a single message will be visible
	dk_runes = true,						-- Show deathknight rune recharge
	killingblow = false,					-- Tells you about your killingblows
	merge_aoe_spam = true,					-- Merges multiple aoe damage spam into single message
	merge_melee = true,						-- Merges multiple auto attack damage spam
	dispel = true,							-- Tells you about your dispels(works only with ["damage = true)
	interrupt = true,						-- Tells you about your interrupts(works only with ["damage = true)
	direction = "bottom",					-- Scrolling Direction("top"(goes down) or "bottom"(goes up))
}

P.RLBox = {
	enable = false,
	TitleFontSize = 12,
	wpTime = 0,
	UIType = 'bar',
	party = false,
	
	DEFAULT = {
		enable = true,
		IconSize = 26,
		BarHeight = 8,
		BarWidth = 120,
		FontSize = 12,
		minperrow = 5,
		rownums = 6,
		sendStartMsg = 'RAID',
		sendEndMsg = 'RAID',
	},
		
	OTHER = {
		enable = true,
		IconSize = 26,
		BarHeight = 8,
		BarWidth = 120,
		FontSize = 12,
		minperrow = 8,
		rownums = 6,
		sendStartMsg = 'RAID',
		sendEndMsg = 'RAID',
	},
	
	MISC = {
		enable = false,
		IconSize = 26,
		BarHeight = 8,
		BarWidth = 120,
		FontSize = 12,
		minperrow = 10,
		rownums = 6,
		sendStartMsg = 'RAID',
		sendEndMsg = 'RAID',
	},
	
	minperrow = 5,
	
	USER_SPELLS = {}, --用户自定义监视技能
	postion = {},
}

P.ALM = {
	enable = false,
	learning = true,
	font = 'EUI',
	fontSize = 9,
	fontOutline = 'OUTLINE',
	tooltip = true,
	maxCacheNum = 30,
	playerBuff = {
		enable = true,
		iconSize = 36,
		x_direction = 'RIGHT',
		y_direction = 'UP',
		interval = 4,
		perRow = 8,
		maxNum = 20,
		pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 20},
		useList = {},
		whiteList = {},
		cacheList = {},
	},
	playerDebuff = {
		enable = true,
		iconSize = 36,
		x_direction = 'RIGHT',
		y_direction = 'UP',
		interval = 4,
		perRow = 8,
		maxNum = 20,
		pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 120},
		useList = {},
		whiteList = {},
		cacheList = {},
	},
	targetBuff = {
		enable = true,
		iconSize = 36,
		x_direction = 'LEFT',
		y_direction = 'UP',
		interval = 4,
		perRow = 8,
		maxNum = 20,
		pos = {"BOTTOMRIGHT", "ElvUF_Target", "TOPRIGHT", 0, 20},
		useList = {},
		whiteList = {},
		cacheList = {},
	},
	targetDebuff = {
		enable = true,
		iconSize = 36,
		x_direction = 'LEFT',
		y_direction = 'UP',
		interval = 4,
		perRow = 6,
		maxNum = 20,
		pos = {"BOTTOMRIGHT", "ElvUF_Target", "TOPRIGHT", 0, 120},
		useList = {},
		whiteList = {},
		cacheList = {},
	},
	spellCD = {
		enable = true,
		iconSize = 28,
		x_direction = 'RIGHT',
		y_direction = 'UP',
		interval = 4,
		perRow = 8,
		maxNum = 20,
		combat = false,
		alwaysShow = false,
		pos = {"BOTTOMLEFT", "ElvUF_Player", "TOPLEFT", 0, 220},
		useList = {},
	},
}

P.CooldownFlash = {
	enable = false,
	fadeInTime = 0.1,
	fadeOutTime = 0.2,
	maxAlpha = 0.8,
	animScale = 1.2,
	iconSize = 80,
	holdTime = 0.3,
	enablePet = false,
	ignoredSpells = "",
	petOverlay = {1,1,1},
	showSpellName = false,	
}

G.skins = {
	embedRight = '',
	embedcombat = false,
}
G.reminder = {}
G.extracd = {}

V.reminder = {
	enable = true,
	sound = "Warning",
}

P.general.bordercolor = { r = .31,g = .31,b = .31 }
P.general.backdropfadecolor = { r = .06,g = .06,b = .06, a = 0.9 }
P.general.stickyFrames = false
P.general.nudgeWindow = true
P.general.hideDisableFrame = true
P.general.disableOmnicc = true
P.general.questfontSize = 12
P.general.lootWidth = 328
P.general.lootHeight = 28
P.general.ShadowEnable = false
P.general.ShadowWidth = 1
P.general.ShadowAlpha = 0.9

P.unitframe.casttimeformat = 1

P.bags.alignToChat = false
P.bags.spacing = 4
P.bags.point = {}
P.bags.transparent = false
P.bags.itemLevelMark = 500
P.bags.itemLevelFormat = 'asterisk'

P.FindIt = {
	msg = "",
	FindType = "spell",
}

P.watch = {
	cooldown = {
		threshold = 4,
		override = true,
		reverse = false,
		hideBlizzard = false,
		expiringColor = { r = 1, g = 0, b = 0 },
		secondsColor = { r = 1, g = 1, b = 1 },
		minutesColor = { r = 1, g = 1, b = 1 },
		hoursColor = { r = 1, g = 1, b = 1 },
		daysColor = { r = 1, g = 1, b = 1 },

		checkSeconds = false,
		hhmmColor = { r = 1, g = 1, b = 1 },
		mmssColor = { r = 1, g = 1, b = 1 },
		hhmmThreshold = -1,
		mmssThreshold = -1,

		fonts = {
			enable = false,
			font = 'EUI',
			fontOutline = 'OUTLINE',
			fontSize = 10,
		},
	},
}

P.AuraWatch = {
	enable = false,
	checkSpellid = false,
	loadDefault = false,
	myclass = '',
	font = 'EUI',
	fontSize = 11,
	fontSize2 = 10,
	fontOutline = 'OUTLINE',
	delay = 0.5,
	Spellname = false,
	DB = {},
}

V.AuraWatch = {
	enable = false,
}

V.SoraClassTimer = {
	enable = false,
}

P.SoraClassTimer = {
	enable = false,
	font = 'EUI',
	fontSize = 11,
	fontOutline = 'OUTLINE',	
	timelimit = 60,
	PlayerMode = "Icon",
		PlayerIconSize = 48,
	TargetMode = "Icon",
		TargetIconSize = 42,
	BlackList = {

	},
	WhiteList = {

	},
}	

P.general.font = 'EUI'
P.general.watchFontSize = 14

P.auras.auraFont = 'EUI'
P.auras.auraFontOutline = 'OUTLINE'
P.auras.fontOutline = 'OUTLINE'
P.auras.fontSize = 12

P.tooltip.healthBar.font = 'EUI'
P.tooltip.RelicInspector = true

P.chat.tabFont = 'EUI'
P.chat.tabFontSize = 12
P.chat.chatItemLevel = true
P.datatexts.font = 'EUI'
P.datatexts.fontSize = 12
P.unitframe.font = 'EUI'
P.actionbar.font = 'EUI'

if GetLocale()=="zhCN" then
	V.general.dmgfont = "伤害数字"
	V.general.namefont = "EUI"
	V.general.chatBubbleFont = "EUI"
	P.unitframe.fontOutline = 'OUTLINE'
	P.actionbar.fontOutline = 'OUTLINE'
	P.unitframe.fontSize = 12
	P.nameplates.font = "EUI"
	P.nameplates.fontSize = 12
	P.nameplates.fontOutline = 'OUTLINE'
elseif GetLocale() == "zhTW" then
	P.unitframe.fontOutline = 'OUTLINE'
	P.actionbar.fontOutline = 'OUTLINE'
	P.unitframe.fontSize = 12
	V.general.dmgfont = "傷害數字"
	V.general.namefont = "EUI"
	V.general.chatBubbleFont = "EUI"
	P.nameplates.font = "EUI"
	P.nameplates.fontSize = 12
	P.nameplates.fontOutline = 'OUTLINE'
end	

P.nameplates.auraTimeOffsetX = 1
P.nameplates.auraTimeOffsetY = 1
P.nameplates.auraCountOffsetX = 0
P.nameplates.auraCountOffsetY = 0
P.nameplates.loadDistance = "4e1"

P.nameplates.targetGlow_y = 4;
P.nameplates.targetGlow_x = 4;
P.nameplates.targetGlow_y_size = 45;
P.nameplates.targetGlow_x_size = 45;
P.nameplates.units.TARGET.topArrowType = 'ArrowUp';
P.nameplates.units.TARGET.leftArrowType = 'ArrowUp';
P.nameplates.units.TARGET.leftArrowTypeSize = 36
P.nameplates.units.TARGET.topArrowTypeSize = 40
P.nameplates.units.TARGET.ArrowSpace = 1


P.nameplates.targetIndicator = {
	enable = false,
	style = 'arrow',
	color = {r= 1, g = 1, b = 1},
	width = 50,
	height = 50,
	yOffset = 0,
	xOffset = 0
}
P.nameplates.QuestIcon = {
	enable = true,
	xOffset = 2,
	yOffset = 0,
	size = 22,
}

P.chat.keywords = '%MYNAME%, EUI, 黑石, 悬槌堡'
P.chat.sendRW = false
P.chat.autoToggleBackdrop = false
P.actionbar.euiabstyle = "None"
P.actionbar.loss_of_control_time = true
P.actionbar.keyDown = false
P.actionbar.rightClickCast = false
P.actionbar.extraButtonScale = 1
P.actionbar.extraButtonClear = false
P.actionbar.bar1.paging.ROGUE = "[stance:1] 7; [stance:2] 7; [stance:3] 10;"
P.actionbar.bar1.backdrop = true
P.actionbar.bar1.buttonspacing = 4
P.actionbar.bar1.buttonsize = 30
P.actionbar.bar2.buttonsize = 30
P.actionbar.bar3.buttonsize = 30
P.actionbar.bar4.buttonsize = 30
P.actionbar.bar5.buttonsize = 30

P.actionbar.bar2.buttonspacing = 4
P.actionbar.bar3.buttonspacing = 4
P.actionbar.bar4.buttonspacing = 4
P.actionbar.bar3.backdrop = true
P.actionbar.bar5.backdrop = true
P.actionbar.bar5.buttonspacing = 4
P.actionbar.barPet.buttonspacing = 4

P.actionbar.stanceBar.buttonspacing = 4

for i = 6, 10 do
	P.actionbar['bar'..i] = {
		enabled = false,
		mouseover = false,
		buttons = 12,
		buttonsPerRow = 12,
		point = 'BOTTOMLEFT',
		backdrop = true,
		heightMult = 1,
		widthMult = 1,
		buttonsize = 30,
		backdropSpacing = 2,
		buttonspacing = 4,		
		alpha = 1,
		inheritGlobalFade = false,
		showGrid = true,
		flyoutDirection = 'AUTOMATIC',
		paging = {},
		visibility = 'show',
	}
end

P.datatexts.spec1 = '';
P.datatexts.spec2 = '';
P.datatexts.spec3 = '';
P.datatexts.spec4 = '';
P.datatexts.userColor = { r = 1, g = 1, b = 1 }
P.datatexts.customColor = 2
P.datatexts.panels.AB1Infobar = {
	left = '',
	middle = '',
	right = '',
}
P.datatexts.panels.AB5Infobar = ''
P.datatexts.panels.AB3Infobar = ''
P.datatexts.panels.TopDataTextsBar1 = 'E_Coord'
P.datatexts.panels.TopDataTextsBar2 = 'E_Range'
P.datatexts.panels.TopDataTextsBar4 = 'E_Zone'
P.datatexts.panels.TopDataTextsBar3 = {
	left = 'E_Menu',
	right = 'E_Shortopt',
	middle = 'E_Raidtool',
}

P.infobar = {
	width = 74,
	height = 22,
}


P.general.panelWidth = 360
P.general.transparent = false
P.general.transparentStyle = 1
P.general.classcolor = false
P.general.bottomPanel = false
P.general.uiscale = 0.71


P.skins = {
	fontSize = 12,
	barHeight = 10,
}

V.chat.embedright = "None"
V.chat.embedcombat = false
P.chat.panelWidth = 362
P.chat.panelHeight = 180
P.chat.panelWidthRight = 362
P.chat.panelHeightRight = 180
P.chat.separateSizes = true
P.chat.throttleInterval = 0
P.chat.autojoin = true

P.tooltip.range = true
P.tooltip.achievementpoint = true
P.tooltip.transparent = false
P.tooltip.hh = true
P.tooltip.mountinfo = true
P.tooltip.itemCount = 'BOTH'
P.tooltip.offsetX = 0
P.tooltip.offsetY = 0
P.tooltip.professionicons = true

P.unitframe.number = "K"
P.unitframe.colors.nameclasscolor = false
P.unitframe.targetGlow = true
P.unitframe.unitframeType = 1
P.unitframe.transparent = false
P.unitframe.powertrans = true

P.unitframe.units.player.classbar.text = true
P.unitframe.units.player.classbar.fill = 'spaced'
P.unitframe.units.player.classbar.dkRunesBorderColor = true
P.unitframe.units.player.classbar.dkText = true
P.unitframe.units.player.classbar.dkTextXoffset = 0
P.unitframe.units.player.classbar.dkTextYoffset = 14
P.unitframe.units.player.aurabar.auraBarWidth = 270
P.unitframe.units.player.aurabar.auraBarHeight = 20
P.unitframe.units.player.aurabar.lock = true
P.unitframe.units.player.aurabar.showValue = true
P.unitframe.units.player.aurabar.maxDuration = 300
P.unitframe.units.player.power.text_format = '[powercolor][power:current-percent]'
P.unitframe.units.player.power.width = 'fill'
P.unitframe.units.player.power.tick1 = 0.4
P.unitframe.units.player.power.tick2 = 0.9
P.unitframe.units.player.power.tick3 = 0.3
P.unitframe.units.player.power.minperc = 0
P.unitframe.units.player.power.colorPerc = false
P.unitframe.units.player.power.color0 = {r = 0.31, g = 0.45, b = 0.63}
P.unitframe.units.player.power.color1 = {r = 0.31, g = 0.45, b = 0.63}
P.unitframe.units.player.power.color2 = {r = 0.31, g = 0.45, b = 0.63}
P.unitframe.units.player.power.color3 = {r = 0.31, g = 0.45, b = 0.63}
P.unitframe.units.player.power.color4 = {r = 0.31, g = 0.45, b = 0.63}
P.unitframe.units.player.power.color5 = {r = 0.31, g = 0.45, b = 0.63}
P.unitframe.units.player.power.color6 = {r = 0.31, g = 0.45, b = 0.63}
P.unitframe.units.player.power.color7 = {r = 0.31, g = 0.45, b = 0.63}
P.unitframe.units.player.power.color8 = {r = 0.31, g = 0.45, b = 0.63}
P.unitframe.units.player.power.color9 = {r = 0.31, g = 0.45, b = 0.63}

P.unitframe.units.player.stagger.enable = false
P.unitframe.units.target.aurabar.auraBarWidth = 270
P.unitframe.units.target.aurabar.auraBarHeight = 20
P.unitframe.units.target.aurabar.lock = true
P.unitframe.units.target.aurabar.showValue = true
P.unitframe.units.target.aurabar.attachTo = 'DEBUFFS'
P.unitframe.units.target.power.width = 'fill'
P.unitframe.units.target.tapped = {
	position = 'TOPLEFT',
	text_format = '||cFFB04F4F[tapped]||r',
}
P.unitframe.units.player.tankshield = {
	enable = true,
--	position = 'RIGHT',
	xOffset = 0,
	yOffset = 0,
	sizeOverride = 0,
}
P.unitframe.units.target.range = {
	enable = true,
	position = 'BOTTOMLEFT',
	offsetX = 2,
	offsetY = 2,
	fontSize = 12,
}

P.unitframe.units.raid.rdebuffs.useFilter = "RaidDebuffs"


P.unitframe.units.player.Swing = {
	enable = false,
	width = 270,
	height = 12,
	text = true,
	color = { r = 1,g = 1,b = 1 },
}
P.unitframe.units.player.gcd = false
P.unitframe.units.player.portrait.enable = true
P.unitframe.units.player.portrait.overlay = false
P.unitframe.units.player.portrait.alpha = 0.35
P.unitframe.units.target.portrait.alpha = 0.35
P.unitframe.units.player.classbar.totemtime = true
P.unitframe.units.player.classbar.fill = 'spaced'
P.unitframe.units.player.threatStyle = 'HEALTHBORDER'
P.unitframe.units.player.combobar = {
	enable = false,
	fill = 'spaced',
	height = 10,
}

P.unitframe.units.targettarget.power.width = 'fill'
P.unitframe.units.targettarget.name.length = 'LONGLEVEL'
P.unitframe.colors.castColor = { r = .78,g = .67,b = .35 }
P.unitframe.units.target.portrait.enable = true
P.unitframe.units.target.portrait.overlay = false
P.unitframe.units.target.debuffs.enable = true
P.unitframe.units.target.threatStyle = 'HEALTHBORDER'

P.unitframe.units.party.threatStyle = 'HEALTHBORDER'

P.unitframe.units.party.verticalSpacing = 30

P.unitframe.units.raid.width = 70
P.unitframe.units.raid.threatStyle = 'HEALTHBORDER'
P.unitframe.units.raid.power.width = 'fill'
P.unitframe.units.raid.debuffs.enable = false
P.unitframe.units.raid.debuffs.initialAnchor = 'BOTTOMRIGHT'
P.unitframe.units.raid.debuffs.anchorPoint = 'BOTTOMRIGHT'
P.unitframe.units.raid.debuffs['growth-x'] = 'LEFT'
P.unitframe.units.raid.debuffs.useFilter = 'RaidDebuffs'
P.unitframe.units.raid.rdebuffs.enable = true
P.unitframe.units.raid.rdebuffs.xOffset = 0
P.unitframe.units.raid.rdebuffs.yOffset = 2
P.unitframe.units.raid.rdebuffs.useFilter = 'RaidDebuffs'

P.unitframe.units.raid.roleIcon.position = 'BOTTOMLEFT'
P.unitframe.units.raid.raidTurtleBuffs = true
P.unitframe.units.raid.charTurtleBuffs = true
P.unitframe.units.raid.mouseGlow = true

P.unitframe.units.raid.health.text_format = '[status]'
P.unitframe.units.raid.health.colorClass = false
P.unitframe.units.raid.petframe = false
P.unitframe.units.raid.numGroups = 8
P.unitframe.units.raid.growthDirection = 'RIGHT_UP'
P.unitframe.units.raid.visibility = '[@raid2,noexists] hide;show';
P.unitframe.units.raid.name.fontSize = 11
P.unitframe.units.raid.name.font = 'EUI'
P.unitframe.units.raid.name.fontOutline = 'OUTLINE'

P.unitframe.colors.nameclasscolor = true

P.unitframe.units.party.showRaid = false
P.unitframe.units.party.visibility = "[@raid2,exists][nogroup] hide;show";

local unitsGroup = {'player', 'target', 'targettarget', 'targettargettarget', 'pet', 'pettarget'}
for i = 1, #unitsGroup do
	if P.unitframe.units[unitsGroup[i]].health then
		P.unitframe.units[unitsGroup[i]].health.orientation = 'HORIZONTAL'
	end
	if P.unitframe.units[unitsGroup[i]].power then
		P.unitframe.units[unitsGroup[i]].power.orientation = 'HORIZONTAL'
	end
end


G.InfoFilter = {
	enable = true,
	level = 10,
	matchNum = 1,
	repeatTime = 30,
	rtNum = 3,
	Debug = false,
	filterFriend = true,
	nowhisperSticky = true,
	profanityFilter = true,
	filterClub = false,
	filterAceh = false,
	blackName = {},
	blackList = {
		['平台交易'] = true,
		['担保'] = true,
		['纯手工'] = true,
		['淘宝'] = true,
		['游戏币'] = true,
		['代打'] = true,
		['代练'] = true,
		['工作室'] = true,
		['战点'] = true,
		['手工金'] = true,
		['手工G'] = true,
		['皇冠店'] = true,
		['一赔'] = true,
		['点心'] = true,
		['冲钻'] = true,
		['店铺'] = true,
		['皇冠'] = true,
		['评级'] = true,
		['套餐'] = true,
		['手工带'] = true,
		['塞纳'] = true,
		['代刷'] = true,
		['带刷'] = true,
		['牛肉'] = true,
		['1-60'] = true,
		['1-90'] = true,
		['90-100'] = true,
		['元'] = true,
		['G'] = true,
		['消保'] = true,
		['好评'] = true,
		['clubTicket:'] = true,
	},	
}

P.clickset = {
	spec1 = {
		type1 = "NONE",
		shiftztype1 = "NONE",
		ctrlztype1 = "NONE",
		altztype1 = "NONE",
		altzctrlztype1 = "NONE",
		shiftzaltztype1 = "NONE",
		type2 	= "NONE",
		shiftztype2 = "NONE",
		ctrlztype2 = "NONE",
		altztype2 = "NONE",
		altzctrlztype2 = "NONE",
		shiftzaltztype2 = "NONE",
		type3 	= "NONE",
		shiftztype3 = "NONE",
		ctrlztype3 = "NONE",
		altztype3 = "NONE",
		altzctrlztype3 = "NONE",
		shiftzaltztype3 = "NONE",	
		shiftztype4 = "NONE",
		ctrlztype4 = "NONE",
		altztype4 = "NONE",
		altzctrlztype4 = "NONE",
		type4 = "NONE",
		shiftztype5 = "NONE",
		ctrlztype5 = "NONE",
		altztype5 = "NONE",
		altzctrlztype5 = "NONE",
		type5 = "NONE",
	},
	spec2 = {
		type1 = "NONE",
		shiftztype1 = "NONE",
		ctrlztype1 = "NONE",
		altztype1 = "NONE",
		altzctrlztype1 = "NONE",
		shiftzaltztype1 = "NONE",
		type2 	= "NONE",
		shiftztype2 = "NONE",
		ctrlztype2 = "NONE",
		altztype2 = "NONE",
		altzctrlztype2 = "NONE",
		shiftzaltztype2 = "NONE",
		type3 	= "NONE",
		shiftztype3 = "NONE",
		ctrlztype3 = "NONE",
		altztype3 = "NONE",
		altzctrlztype3 = "NONE",	
		shiftzaltztype3 = "NONE",
		shiftztype4 = "NONE",
		ctrlztype4 = "NONE",
		altztype4 = "NONE",
		altzctrlztype4 = "NONE",
		type4 = "NONE",
		shiftztype5 = "NONE",
		ctrlztype5 = "NONE",
		altztype5 = "NONE",
		altzctrlztype5 = "NONE",
		type5 = "NONE",
	},
	spec3 = {
		type1 = "NONE",
		shiftztype1 = "NONE",
		ctrlztype1 = "NONE",
		altztype1 = "NONE",
		altzctrlztype1 = "NONE",
		shiftzaltztype1 = "NONE",
		type2 	= "NONE",
		shiftztype2 = "NONE",
		ctrlztype2 = "NONE",
		altztype2 = "NONE",
		altzctrlztype2 = "NONE",
		shiftzaltztype2 = "NONE",
		type3 	= "NONE",
		shiftztype3 = "NONE",
		ctrlztype3 = "NONE",
		altztype3 = "NONE",
		altzctrlztype3 = "NONE",	
		shiftzaltztype3 = "NONE",
		shiftztype4 = "NONE",
		ctrlztype4 = "NONE",
		altztype4 = "NONE",
		altzctrlztype4 = "NONE",
		type4 = "NONE",
		shiftztype5 = "NONE",
		ctrlztype5 = "NONE",
		altztype5 = "NONE",
		altzctrlztype5 = "NONE",
		type5 = "NONE",
	},
	spec4 = {
		type1 = "NONE",
		shiftztype1 = "NONE",
		ctrlztype1 = "NONE",
		altztype1 = "NONE",
		altzctrlztype1 = "NONE",
		shiftzaltztype1 = "NONE",
		type2 	= "NONE",
		shiftztype2 = "NONE",
		ctrlztype2 = "NONE",
		altztype2 = "NONE",
		altzctrlztype2 = "NONE",
		shiftzaltztype2 = "NONE",
		type3 	= "NONE",
		shiftztype3 = "NONE",
		ctrlztype3 = "NONE",
		altztype3 = "NONE",
		altzctrlztype3 = "NONE",	
		shiftzaltztype3 = "NONE",
		shiftztype4 = "NONE",
		ctrlztype4 = "NONE",
		altztype4 = "NONE",
		altzctrlztype4 = "NONE",
		type4 = "NONE",
		shiftztype5 = "NONE",
		ctrlztype5 = "NONE",
		altztype5 = "NONE",
		altzctrlztype5 = "NONE",
		type5 = "NONE",
	},
	enable = true,
	clicksetlist = {},
	defaultlistloaded = false,
	specswap = false,
}

local function SpellName(id)
--	local spellname = GetSpellInfo(id)
	return tostring(id)
end

G.BossSwing = {
	speeds = {},
}

P.euiscript = {
	ZoneInfo = true,
	spellactivation = true,
	dismount = true,
	csc = true,
	EnableRaidItemLevel = true,
	ShowCharacterItemSheet = true,
	ShowItemStats = false,
	SendPartyItemLevelToParty = false,
	CrucibleWeight = true,
	autoCollapseObjective = false,
	tabold = true,
	blzClassBar = {
		enable = false,
		scale = 1,
	},
	DRTracker = false,
	DRTrackerSize = 29,
	DRTrackerCatList = {
		Roots = true,
		Stuns = true,
		Silences = true,
		Taunts = true,
		Knockbacks = true,
		Incapacitates = true,
		Disorients = true,
	},
	disable_talking = false,
	CharacterStats = true,
	CharacterStatsList = {
		HEALTH = true,
		POWER = true,
		ARMOR = true,
		STRENGTH = true,
		AGILITY = true,
		INTELLECT = true,
		STAMINA = true,
		ATTACK_DAMAGE = true,
		ATTACK_AP = true,
		ATTACK_ATTACKSPEED = true,
		SPELLPOWER = true,
		MANAREGEN = true,
		ENERGY_REGEN = true,
		RUNE_REGEN = true,
		FOCUS_REGEN = true,
		MOVESPEED = true,
		DURABILITY = true,
		REPAIRTOTAL = true,
		CRITCHANCE = true,
		HASTE = true,
		VERSATILITY = true,
		MASTERY = true,
		LIFESTEAL = true,
		AVOIDANCE = true,
		DODGE = true,
		PARRY = true,
		BLOCK = true,
	},
	talentSetManager = true,
	char_ilvl = true,
	durability = true,
	durability_fontsize = 12,
	slotlv_fontsize = 12,
	tztb = true,
	tztb_icon = 24,
	disableBLZCombatText = true,
	BossSwing = {
		enabled = false,
		hideooc = false,
		showonlyintankspec = false,
		frame = {
			lag = true,
			texture = "Glaze",
			width = 300,
			height = 32,
			length = 2500,
			scale = 1,
			alpha = 0.8,
		},
		targetbar = {
			texture = "Glaze",
			width = 300,
			height = 32,
			length = 2.5,
			scale = 1,
			alpha = 0.8,
		},
	},
	teleportie = {
		enable = true,
		texpath_body = [[Interface\AddOns\EuiScript\textures\Transcendence1.blp]],
		texpath_direction = [[Interface\AddOns\EuiScript\textures\Direction1.blp]],
		texpath_bg = [[Interface\AddOns\EuiScript\textures\Background1.blp]],
		texColor_far = {255/255, 15/255, 0/255, .5}, --red
		texColor_near = {83/255, 255/255, 197/255, 1}, --green
		textColor_far = {255/255, 15/255, 0/255}, --red
		textColor_near = {20/255, 255/255, 80/255}, --green	
		decimals = 1,
		insets = 5,
		frame_size = 48,
		framePos = {"CENTER", "UIParent", "CENTER", 0, -150},
		font_height = 12,
		Portal = {},
	},
	unitprice = true,
	pitch = false,
	poi = false,
	poiColor = { r = 0.5,g = 1,b = 1 },
	poiCombat = true,
	poiText = '╋',
	poiTextSize = 22,
	selllisttext = 34498,
	spellSay = true,
	breeze = true,
	gmm = true,
	BodyGuardAway = false,
	QSAlert = true,
	FriendGroups = {
		enable = false,
		collapsed = {},
		hide_offline = false,
		colour_classes = true,
		enable_oqueue = true,
	},
	bg = {
		enable = true,
		size = 40,
		fontsize = 16,
	},
	autoleavebnsec = -1,
	gemplus = true,
	threat = {
		enable = false,
		NameTextL = 4,
		ThreatLimited = 3,
		ThreatUnit = 'target',
		width = 170,
		height = 3,
		solo = false,
		font_size = 11,
	},
	shenxian = {
		enable = true,
		size = 60,
		selectmodel = 2,
		combat = false,
	},
	auto_collapse = false,
	objectiveTrackerFrame = true,
	questnoti = {
		enable = false,
		Instance = true,
		Raid = true,
		Party = true,
		Solo = true,
		every = 1,
	},
	fivecombo = true,
	bossnotes = true,
	castby = true,
	chatmod = true,
	drag = true,
	worldmap = {},
--	ilevel = true,
	sr = true,
	statreport = true,
--	talent = true,
	tradetabs = true,
	dispel = false,
	raidcheck = true,
	hovertip = true,
	idq = false,
	idq_toggle = true,
	QuestLevel = true,
	autoTrackQuest = true,
	autoChoices = false,
	rescd = {
		enable = false;
		width = 100,
		height = 24,
		fontsize = 14,
	},
	raidcd = true,
		raidcd_width = 176,
		raidcd_height = 20,
		raidcd_maxbars = 10,
		raidcd_direction = "down",
		raidcd_style = 'bar',
		raidcd_iconsize = 36,
		raidcd_perrow = 10,
		raidcd_icondirection = 'right',
		raidcd_iconfontsize = 10,
		raidcd_iconspace = 8,
		raidcccd = true,
	raid_spells = {
		[SpellName(20484)] = { cd = 1800, enable = true},	-- Rebirth
		[SpellName(27740)] = { cd = 3600, enable = true},	-- Reincarnation (3600sec base / -1200sec from talents / -600sec for Totem)
		-- Jumper Cables
		-- [SpellName(8342)] = { cd = 1800, enable = true},	-- Goblin Jumper Cables
		-- [SpellName(22999)] = { cd = 1800, enable = true},	-- Goblin Jumper Cables XL
		-- Healing
		[SpellName(740)] = { cd = 300, enable = true},	-- Tranquility
		[SpellName(724)] = { cd = 600, enable = true},	-- Lightwell
		-- Defense
		[SpellName(1022)] = { cd = 300, enable = true},	-- Blessing of Protection (300sec base / -120sec from talents)
		[SpellName(633)] = { cd = 3600, enable = true},	-- Lay on Hands (3600sec base / -1200sec from talents)
		[SpellName(871)] = { cd = 1800, enable = true},	-- Shield Wall
		[SpellName(12975)] = { cd = 600, enable = true},	-- Last Stand
		-- Taunts
		[SpellName(5209)] = { cd = 600, enable = true},	-- Challenging Roar
		[SpellName(1161)] = { cd = 600, enable = true},	-- Challenging Shout
		[SpellName(694)] = { cd = 120, enable = true},	-- Mocking Blow
		-- Mana Regeneration
		[SpellName(29166)] = { cd = 360, enable = true},	-- Innervate
		[SpellName(16190)] = { cd = 300, enable = true},	-- Mana Tide Totem
		-- Other
		[SpellName(6346)] = { cd = 30, enable = true},	-- Fear Ward
		[SpellName(10060)] = { cd = 180, enable = true},	-- Power Infusion

		-- [SpellName(20484)] = { cd = 600, enable = true},	-- 复生
		-- [SpellName(126393)] = { cd = 600, enable = true}, -- 永恒守护者 (魁麟?)
		-- [SpellName(61999)] = { cd = 600, enable = true},	-- 复活盟友
		-- [SpellName(6346)] = { cd = 180, enable = true},	-- 防护恐惧结界
		-- [SpellName(29166)] = { cd = 180, enable = true},	-- 激活
		-- [SpellName(32182)] = { cd = 300, enable = true},	-- 英勇
		-- [SpellName(2825)] = { cd = 300, enable = true},	-- 嗜血
		-- [SpellName(80353)] = { cd = 300, enable = true},	-- 时间扭曲
		-- [SpellName(90355)] = { cd = 300, enable = true},	-- 远古狂乱

		-- --单体减伤
		-- [SpellName(33206)] = { cd = 180, enable = true},--痛苦压制
		-- [SpellName(6940)] = { cd = 120, enable = true},--牺牲之手
		-- [SpellName(102342)] = { cd = 60, enable = true},--铁木树皮
		-- [SpellName(114030)] = { cd = 120, enable = true},--警戒
		-- [SpellName(47788)] = { cd = 180, enable = true},--守护之魂
	
		-- --抬血技能
		-- [SpellName(115310)] = { cd = 180, enable = true},--还魂术
		-- [SpellName(108280)] = { cd = 180, enable = true},--治疗之潮图腾
		-- [SpellName(64843)] = { cd = 180, enable = true},--神圣赞美诗
		-- [SpellName(740)] = { cd = 180, enable = true},--宁静
		-- [SpellName(15286)] = { cd = 180, enable = true},--吸血鬼的拥抱	

		-- --团队免伤技能	
		-- [SpellName(97462)] = { cd = 180, enable = true},  -- 集结呐喊
		-- [SpellName(31821)] = { cd = 180, enable = true},  -- 虔诚光环(NQ)
		-- [SpellName(62618)] = { cd = 180, enable = true},  -- 真言术: 障
		-- [SpellName(98008)] = { cd = 180, enable = true},  -- 灵魂链接图腾
		-- [SpellName(196718)] = { cd = 180, enable = true}, --幻影打击(DH)
		-- [SpellName(51052)] = { cd = 120, enable = true}, --反魔法领域
		
		-- --特殊类
	-- --	[SpellName(172106)] = { cd = 180, enable = true},  -- 灵狐守护
		-- [SpellName(106898)] = { cd = 120, enable = true},  -- 群奔怒吼
		-- [SpellName(192077)] = { cd = 120, enable = true}, --[192077] = {cd = 120, class = "SHAMAN", talent = 21963}, --Wind Rush Totem (10yd aoe, 15s, +60% movement speed for 5s), talent
	-- --	[SpellName(159916)] = { cd = 120, enable = true}, --魔法增效
		
		-- --橙戒
		-- [SpellName(187616)] = { cd = 120, enable = true}, --尼萨姆斯(智力输出)
		-- [SpellName(187617)] = { cd = 120, enable = true}, --萨克图斯(坦克)
		-- [SpellName(187618)] = { cd = 120, enable = true}, --伊瑟拉鲁斯(治疗)
		-- [SpellName(187619)] = { cd = 120, enable = true}, --索拉苏斯(力量输出)
		-- [SpellName(187620)] = { cd = 120, enable = true}, --玛鲁斯(敏捷输出)

		-- --控制技能CD
		-- [SpellName(46968)] = { cd = 40, enable = true, cc = true}, --震荡波
		-- [SpellName(115750)]= { cd = 90, enable = true, cc = true}, --盲目之光
		-- [SpellName(108199)]= { cd = 180, enable = true, cc = true}, --血魔之握
		-- [SpellName(102359)]= { cd = 30, enable = true, cc = true}, --群体缠绕
		-- [SpellName(179057)]= { cd = 60, enable = true, cc = true}, --混乱新星
		-- [SpellName(119381)]= { cd = 45, enable = true, cc = true}, --扫堂腿
		-- [SpellName(192058)]= { cd = 45, enable = true, cc = true}, --闪电奔涌图腾
		-- [SpellName(109248)]= { cd = 45, enable = true, cc = true}, --束缚射击
		-- [SpellName(122)]= { cd = 30, enable = true, cc = true}, --冰霜新星
		-- [SpellName(30283)]= { cd = 30, enable = true, cc = true}, --暗影之怒
		-- [SpellName(132469)]= { cd = 30, enable = true, cc = true}, --吹风
		-- [SpellName(78675)]= { cd = 60, enable = true, cc = true}, --日光术	
		-- [SpellName(196932)]= { cd = 30, enable = true, cc = true}, --巫毒图腾
		-- [SpellName(51485)]= { cd = 30, enable = true, cc = true}, --陷地图腾
						
		-- [SpellName(113724)]= { cd = 45, enable = true, cc = true}, --冰霜之环
		-- [SpellName(31661)]= { cd = 20, enable = true, cc = true}, --龙息术
	},
	classcd = true,
		classcd_width = 130,
		classcd_height = 40,
		classcd_maxbars = 5,
		classcd_direction = "right",
		classcd_style = "icon",
	wildmushroom = true,
		wildmushroom_width = 208,
		wildmushroom_height = 20,
		wildmushroom_direction = "down",
	priestpet = true,
		priestpet_width = 208,
		priestpet_height = 20,
		priestpet_lv = 0,
	mapfull = false,
	chatbar = true,
	chatbarName = false,
	mapmove = true,
	combatnoti = true,
		combatnoti_leaving = "LEAVING COMBAT",
		combatnoti_entering = "ENTERING COMBAT",
	wgtimenoti = 'NONE',
	lfgnoti = 'NONE',
	holidayMsg = true,
--	chatemote = true,
	autogreed = false,
--	buffreminder = true,
	autoinvenable = true,
	ainvkeyword = "eui",
	errorenable = true,
--	threat = true,
	dcp = false,
	autosell = true,
	autosellList = {},
	autoLFG = false,
	MozzFullWorldMap = {},
	autobutton = {
		enable = true,
		questNum = 6,
		itemList = {},
		slotNum = 5,
		AptifactItem = true,
		slotList = {},
		countFontSize = 18,
		bindFontSize = 10,
		whiteList = {
			[90006] = true, --影踪派任务道具
			[86534] = true,
			[86536] = true,
			[76097] = true, --神效治疗药水
			[76098] = true, --神效法力药水
			[5512] = true,  --治疗石
			[36799] = true, --法力宝石
			[81901] = true, --闪耀法力宝石
			[76089] = true, --兔妖之啮 
			[76090] = true, --群山药水 
			[76093] = true, --青龙药水 
			[76094] = true, --炼金师药水
			[76095] = true, --魔古之力药水 
			[86125] = true, --咔啡压榨机
			[86569] = true, --狂乱水晶
			[118922] = true, --奥拉留斯的低语水晶
			[147707] = true, --改装的邪能焦镜
			[142117] = true,
			[127843] = true,
			--公会及荣誉军旗
			[63359] = true,
			[64398] = true,
			[64399] = true,
			[18606] = true,
			[64400] = true,
			[64401] = true,
			[64402] = true,
			[18607] = true,

			--wod 药水
			[116266] = true,
			[116276] = true,		
			[116268] = true,
			[116271] = true,
			[118711] = true,
			[118704] = true,
			[109217] = true,
			[109218] = true,
			[109219] = true,
			[109220] = true,
			[109221] = true,
			[109222] = true,
			[109223] = true,
			[118269] = true, --要塞绿苹果
			[122453] = true,--炼金专用药水
			[122451] = true,
			[122454] = true,
			[122452] = true,
			[122455] = true,
			[122456] = true,	
			[116411] = true, --保护卷轴
			--Legion
			[118330] = true,-- Pile of Weapons
			[122100] = true,-- Soul Gem
			[127030] = true, -- Granny's Flare Grenades
			[127295] = true, -- Blazing Torch
			[128651] = true, -- Critter Hand Cannon
			[128772] = true, -- Branch of the Runewood
			[129161] = true, -- Stormforged Horn
			[129725] = true, -- Smoldering Torch
			[131931] = true, -- Khadgar's Wand
			[133756] = true, -- Fresh Mound of Flesh
			[133882] = true, -- Trap Rune
			[133897] = true, -- Telemancy Beacon
			[133925] = true, -- Fel Lash
			[133999] = true, -- Inert Crystal
			[136605] = true, -- Solendra's Compassion
			[137299] = true, -- Nightborne Spellblad
			[138146] = true, -- Rediant Ley Crystal
			[140916] = true, -- Satchel of Locklimb Powder
			[109076] = true, -- 地精滑翔器工具包
			[153023] = true, -- 光铸调和符文
		},
		blankList = {},
		blankitemID = '',
		itemID = '',
		questPerRow = 5,
		questSize = 40,
		slotPerRow = 5,
		slotSize = 40,
	},
	wsbutton = {
		enable = true,
		size = 40,
		fontsize = 20,
		count = 6,
		healthValue = 6000,
	},
	euiDistance30 = {
		enable = false,
		size = 60,
		fontsize = 24,
	},
	vbutton = {
		enable = true,
		size = 50,
		fontsize = 18,
		combat = false,
	},	
	fsbutton = {
		enable = true,
		size = 58,
		fontsize = 20,
		maxValue = 50000,
		overlay = true,
		sound = "Whisper Alert",
	},	
	cameraspeed = 15,
	camerafactor = 3.5,
	cameradistance = 20,
	SpellQueueWindow = 400,
	SpellQueueWindowToggle = false,
	auto_confirm_de = false,
	bloodshield = false,
	autobuy = true,
	autobuy_maxlevel = MAX_PLAYER_LEVEL;
	autobuylist = {
		['79249'] = 20, --清心书卷
	},
	bgInfo = true,
	TaintError = false,
	achievementpoint = true,
	myslot = '',
	raid_marking1 = 'alt',
	raid_marking2 = 'LeftButton',
	autochangeloot = false,
	InviteRank = {},
	embedfocuser1 = 'shift',
	embedfocuser2 = '1',
	buttonCollect = true,
	buttonCollectDC = 'DOWN',
	autoscreenshoot = true,
	logging_combat = false,
	SavedAddonProfiles = {},
	SavedAddonTalent = {},
	SavedAddonTalentReload = false,
	LCData = {
		enable = true,
		minRank = 2,
		disenchanter = '',
		allowPersonalVotes = true,
		broadcastChannel = 1,
	},	
	executebutton = {
		enable = true,
		size = 60,
		fontsize = 16,
		sound = "None",
		instance = false,
		spellList = {
			WARRIOR = {
				[1] = {
					enabled = true,
					spellid = 163201,
					perc = 20,
				},
				[2] = {
					enabled = true,
					spellid = 5308,
					perc = 20,
				},
				[3] = {
					enabled = false,
					spellid = 5308,
					perc = 20,
				},				
			},
			PRIEST = {
				[1] = {
					enabled = false,
					spellid = 32379,
					perc = 20,
				},
				[2] = {
					enabled = false,
					spellid = 32379,
					perc = 20,
				},				
				[3] = {
					enabled = false,
					spellid = 32379,
					perc = 20,
				},
			},
			WARLOCK = {
				[1] = {
					enabled = false,
					spellid = 32862,
					perc = 20,
				},
				[2] = {
					enabled = false,
					spellid = 6353,
					perc = 25,
				},
				[3] = {
					enabled = false,
					spellid = 17877,
					perc = 20,
				},
			},	
			PALADIN = {
				[2] = {
					enabled = false,
					spellid = 24275,
					perc = 20,
				},			
				[3] = {
					enabled = false,
					spellid = 24275,
					perc = 20,
				},
			},
			DRUID = {
				[2] = {
					enabled = false,
					spellid = 22568,
					perc = 25,
				},
			},
			HUNTER = {
				[1] = {
					enabled = false,
					spellid = 53351,
					perc = 20,
				},
				[2] = {
					enabled = false,
					spellid = 53351,
					perc = 35,
				},
				[3] = {
					enabled = false,
					spellid = 53351,
					perc = 20,
				},
			},
			ROGUE = {
				[1] = {
					enabled = false,
					spellid = 111240,
					perc = 35,
				},
			},
			MAGE = {
			},
			SHAMAN = {
			},
		},
	},
	afkspincamera = true,
	announcements = false,
}

if(GetLocale()=="zhCN") then
	P.euiscript.combatnoti_entering = "进入战斗状态"
	P.euiscript.combatnoti_leaving = "离开战斗状态"
elseif (GetLocale()=="zhTW") then
	P.euiscript.combatnoti_entering = "進入戰鬥狀態"
	P.euiscript.combatnoti_leaving = "離開戰鬥狀態"
else
	P.euiscript.combatnoti_entering = "ENTERING COMBAT"
	P.euiscript.combatnoti_leaving = "LEAVING COMBAT"
end

E.ClickSets_Sets = {
	PRIEST = { --牧师
			["shift-type1"]	= 186263,--暗影愈合
			["ctrl-type1"]	= 194509,--真言术：耀
			["alt-type1"]	= 200829,--恳求
			["alt-ctrl-type1"]	= 212036,--群体复活
			["type2"]		= 17,--真言术：盾
			["shift-type2"]	= 152118,--意志洞悉-天赋
			["ctrl-type2"]	= 527,--纯净术
			["alt-type2"]	= 552,--暗影盟约-天赋
			["alt-ctrl-type2"]	= 33206,--痛苦压制
			["type3"]		= 1706,--漂浮术
			["shift-type3"] = 73325,--信仰飞跃
			["alt-type3"] = 1706, --漂浮术
			["ctrl-type3"] = 194509,--真言术：耀
			["type4"] = 596, --治疗祷言
			["shift-type4"] = 47758, -- 苦修
			["ctrl-type4"] = 73325, -- 信仰飞跃	
			["type5"] = 48153, -- 守护之魂
			["shift-type5"] = 88625, -- 圣言术
			["ctrl-type5"] = 33206,--痛苦压制
	},
	
	DRUID = { --XD
			["shift-type1"]	= 774,--"回春術",
			["ctrl-type1"]	= 2782,--"净化腐蚀",
			["alt-type1"]	= 8936,--"癒合",
			["alt-ctrl-type1"]	= 50769,--"復活",
			["type2"]		= 48438,--"野性成长",
			["shift-type2"]	= 18562,--"迅捷治愈",
			["ctrl-type2"]	= 88423, -- 自然治愈
			["alt-type2"]	= 102342,--"铁木树皮",
			["alt-ctrl-type2"] = 102351, -- 塞纳里奥结界
			["type3"]		= 33763,--"生命之花",
			["shift-type3"] = 5185,--治疗之触
			["ctrl-type3"] = 20484,--复生
			["alt-type3"] = 29166, --激活
	},
	SHAMAN = { --SM
			["alt-type1"]	= 8004,		--"治疗之拥",
			["shift-type1"]	= 73685,		--"生命释放",
			["ctrl-type1"]	= 1064,		--"治疗链",
			["alt-ctrl-type1"]	= 2008,	--"先祖之魂",
			["type2"]		= 61295,	--"激流",
			["alt-type2"]	= 331,		--"治疗波",
			["shift-type2"]	= 77472,	--"强效治疗波",
			["ctrl-type2"]	= 51886,	--"净化灵魂",
			["type3"]		= 1064,		--"治疗链",
			["shift-type3"] = 546, --水上漂
			["alt-type3"] = 131, --水下游
	},

	PALADIN = { --QS
			["shift-type1"]	= 635,--"聖光術",
			["alt-type1"]	= 19750,--"聖光閃現",
			["ctrl-type1"]	= 53563,--"圣光信标",
			["alt-ctrl-type1"]	= 7328,--"救贖",
		["type2"]		= 20473,--"神聖震擊",
			["shift-type2"]	= 82326,--"Divine Light",
			["ctrl-type2"]	= 4987,--"淨化術",
			["alt-type2"]	= 85673,--"Word of Glory",
			["alt-ctrl-type2"]	= 633,--"聖療術",
		["type3"]		= 31789,--正義防護
			["alt-type3"]	= 200025,--王者
			["shift-type3"]	= 223306,--庇護
			["ctrl-type3"]	= 183998,--力量
			["alt-ctrl-type3"] = 31789, -- 正义防御
		["type4"] = 1022, --保护之手
			["alt-type4"] = 1044, -- 自由之手
			["shift-type4"] = 1038, -- 拯救之手
			["ctrl-type4"] = 6940, -- 牺牲之手
	},

	WARRIOR = { --ZS
			["ctrl-type1"]	= 198304,--"戒備守護",
			["type2"]		= 3411,--"阻擾",
	},

	MAGE = { --FS
			["alt-type1"]	= 157980,--超级新星
			["ctrl-type1"]	= 54646,--"专注",
			["shift-type2"]	= 130,--"缓落",
	},

	WARLOCK = { --SS
			["alt-type1"]	= 20707,--灵魂石
			["type2"]		= 5697,--"魔息",
	},

	HUNTER = { --LR
			["type2"]		= 34477,--"誤導",
			["shift-type2"] = 136, --治疗宠物
	},
	
	ROGUE = { --DZ
			["type2"]		= 57934,--嫁祸诀窍
	},
}

E.ClickSets_Sets3 = {
	PRIEST = { --牧师
			["ctrl-type1"]	= 127626,--"噬灵疫病",
			["alt-type1"]	= 32379,--"灭",
			["type2"]		= 589,--"痛",
	},
	
	DRUID = { --XD
			["shift-type1"]	= 102354,--"虫群",
			["ctrl-type1"]	= 33786,--"旋风",
			["alt-type1"]	= 164812,--"月火",
			["alt-ctrl-type1"]	= 164815,--"阳炎",
			["type2"]		= 106839,--"迎头痛击",
	},
	SHAMAN = { --SM
			["alt-type1"]	= 8050,		--"烈焰震击",
			["shift-type1"]	= 8056,		--"冰霜震击",
			["ctrl-type1"]	= 51514,	--"妖术",
			["type2"]		= 370,	--"净化",
	},
	PALADIN = { --QS
			["shift-type1"]	= 20271,--"审判",
			["alt-type1"]	= 879,--"驱邪术",
			["ctrl-type1"]	= 105593,--"制裁之拳",
			["type2"]		= 853,--"制裁之锤",
			["shift-type2"]	= 20066,--"忏悔",
	},
	WARRIOR = { --ZS
			["ctrl-type1"]	= 100,--"冲锋",
			["alt-type1"]	= 6552,--'拳击'
			["type2"]		= 94409,--"撕裂",
	},
	MAGE = { --FS
			["alt-type1"]	= 118,--"变形术",
			["ctrl-type1"]	= 30449,--"法术吸取",
			["type2"]		= 2139,--"法术反制",
			["shift-type2"]	= 31589,--"减速",
	},
	WARLOCK = { --SS
			["alt-type1"]	= 172,--"腐蚀术",
			["ctrl-type1"]	= 1313737,--"痛楚",
			["shift-type1"]	= 131736,--"痛苦无常",
			["type2"]		= 5782,--"恐惧",
			["shift-type2"]	= 348,--"献祭",
	},
	HUNTER = { --LR
			["type2"]		= 19801,--"宁神射击",
			["shift-type2"] = 147362, --反制射击
	},
	ROGUE = { --DZ
			["alt-type1"]	= 1766, --'脚踢'
			["ctrl-type1"]	= 2097, --致盲
			["type2"]		= 6770,--"闷棍",
	},	
}

local class = select(2, UnitClass("player"))
if class == 'PRIEST' then
	P.unitframe.units.player.tankshield.enable = false
end

for k, v in pairs(E.ClickSets_Sets[class]) do
	if GetSpellInfo(v) then P.clickset.spec1[string.gsub(k,"-","z")] = GetSpellInfo(v) end
	if GetSpellInfo(v) then P.clickset.spec2[string.gsub(k,"-","z")] = GetSpellInfo(v) end
	if GetSpellInfo(v) then P.clickset.spec3[string.gsub(k,"-","z")] = GetSpellInfo(v) end
	if GetSpellInfo(v) then P.clickset.spec4[string.gsub(k,"-","z")] = GetSpellInfo(v) end	
end
for k, v in pairs(E.ClickSets_Sets3[class]) do
	if GetSpellInfo(v) then P.clickset.spec1[string.gsub(k,"-","z")] = GetSpellInfo(v) end
	if GetSpellInfo(v) then P.clickset.spec2[string.gsub(k,"-","z")] = GetSpellInfo(v) end
	if GetSpellInfo(v) then P.clickset.spec3[string.gsub(k,"-","z")] = GetSpellInfo(v) end
	if GetSpellInfo(v) then P.clickset.spec4[string.gsub(k,"-","z")] = GetSpellInfo(v) end
end


E.build = GetAddOnMetadata("EuiScript", "Version")

if GetLocale() == 'zhCN' then
	E.MoveTooltip = {
		AlertFrameMover = "拾取 / 成就框",
		AltPowerBarMover = "特殊能量条",
		AurasMover = "BUFF/DEBUFF 窗口",
		AutoButtonAnchor2Mover = {"设置在增强功能的自动装备饰品按键", "显示玩家可使用的饰品,工程手套等"},
		AutoButtonAnchorMover = {"设置在增强功能的自动任务物品按键", "显示玩家做任务时一些可使用的道具", "在农场时自动显示农具和种子", "可显示各种药水,治疗石"},
		BNETMover = {"战网提示窗口", "可显示实名好友上下线提示"},
		BossButton = "显示BOSS战中的一些特殊技能",
		ClassCDAnchorMover = "设置在增强功能的内置CD冷却监视",
		CooldownFlashMover = "设置在技能监视组的中部冷却闪光",
		ElvAB_1 = {"设置在动作条设置页中", "可调大小,尺寸,每行显示个数等"},
		ElvAB_2 = {"设置在动作条设置页中", "可调大小,尺寸,每行显示个数等"},
		ElvAB_3 = {"设置在动作条设置页中", "可调大小,尺寸,每行显示个数等"},
		ElvAB_4 = {"设置在动作条设置页中", "可调大小,尺寸,每行显示个数等"},
		ElvAB_5 = {"设置在动作条设置页中", "可调大小,尺寸,每行显示个数等"},
		ElvAB_6 = {"设置在动作条设置页中", "可调大小,尺寸,每行显示个数等", "默认未启用"},
		ElvAB_7 = {"设置在动作条设置页中", "可调大小,尺寸,每行显示个数等", "默认未启用"},
		ElvAB_8 = {"设置在动作条设置页中", "可调大小,尺寸,每行显示个数等", "默认未启用"},
		ElvAB_9 = {"设置在动作条设置页中", "可调大小,尺寸,每行显示个数等", "默认未启用"},
		ElvUF_PlayerMover = "设置在单位框体的玩家框体页",
		ElvUF_PlayerAuraMover = {"设置在单位框体的玩家框体页右侧下拉里的光环条", "默认锁定不可移动,需在其设置中解锁后才能移动"},
		ElvUF_PlayerCastbarMover = {"设置在单位框体的玩家框体页右侧下拉里的施法条", "可以移动, 调节大小"},
		ElvUF_TargetCastbarMover = {"设置在单位框体的目标框体页右侧下拉里的施法条", "可以移动, 调节大小"},
		ElvUF_FocusCastbarMover = {"设置在单位框体的目标框体页右侧下拉里的施法条", "可以移动, 调节大小"},
		ElvUF_TargetMover = "设置在单位框体的目标框体页",
		ElvUF_TargetAuraMover = {"设置在单位框体的目标框体页右侧下拉里的光环条", "默认锁定不可移动,需在其设置中解锁后才能移动"},
		ElvUF_TargetTargetMover = "设置在单位框体的目标的目标框体页",
		ElvUF_FocusMover = "设置在单位框体的焦点框体页",
		ElvUF_PartyMover = {"设置在单位框体的队伍框体页", "可调大小,尺寸,是否显示目标和宠物等"},
		ElvUF_RaidMover = {"设置在单位框体的团队框架页", "用来显示10人团队的框架"},
	--	ElvUF_Raid25Mover = {"设置在单位框体的25人团队框架页", "用来显示25人团队的框架"},
		ElvUF_Raid40Mover = {"设置在单位框体的40人团队框架页", "用来显示40人团队的框架"},
		BossHeaderMover = {"设置在单位框体的BOSS框体页", "可调大小,尺寸"},
		ArenaHeaderMover = {"设置在单位框体的竞技场框体页", "可调大小,尺寸"},
		EuiExecuteMover = {"设置在增强功能里", "默认当各职业斩杀技能可用时显示图标提示", "可调大小,可设置提示音效"},
		EuiInfoBar1Mover = {"顶部信息条,在信息文字选项中调整显示内容", "设成无后会自动隐藏.显示区域的名称的这块不建议隐藏."},
		EuiInfoBar2Mover = {"顶部信息条,在信息文字选项中调整显示内容", "设成无后会自动隐藏.显示区域的名称的这块不建议隐藏."},
		EuiInfoBar3Mover = {"顶部信息条,在信息文字选项中调整显示内容", "设成无后会自动隐藏.显示区域的名称的这块不建议隐藏."},
		EuiInfoBar4Mover = {"顶部信息条,在信息文字选项中调整显示内容", "设成无后会自动隐藏.显示区域的名称的这块不建议隐藏."},
		EUIMinimapButtonMover = "方形小地图图标, 在增强功能里关闭,用来收集小地图图标",
		EuiMonkHealMover = "设置在增强功能里",
		EuiMageFireMover = "设置在增强功能里",
		ExperienceBarMover = "设置在一般设置中",
		GMMover = "GM 对话框",
		LeftChatPanelMover = {"设置在聊天框选项页", "右上角有个小按钮,左击是复制聊天框内容,右击是系统自带表情语言等菜单", "顶部的频道切换条可在增强功能中关闭", "右上角的S用来发送用户数据,E是表情,L是用来快速解锁移动框体", "如左键点击了左下角的<使其隐藏,再次点击相同位置可显示"},
		LootFrameMover = "设置在一般设置中,尽量不要关闭",
		LossControlMover = "迷失控制",
		MicrobarMover = "设置在动作条的微型系统菜单页中,默认关闭",
		PetAB = {"设置在动作条的宠物动作条页中", "调节每行按键数可改变横竖外观"},
		PRIESTAnchorMover = "显示暗影牧师的暗影魔计时",
		RaidCDAnchorMover = {"设置在增强功能的团队技能冷却监视页中", "默认计时条样式,可改图标样式", "可增减监控的技能"},
		ReputationBarMover = "设置在一般设置中",
		RightChatPanelMover = {"设置在聊天框页中", "可改大小尺寸", "可绑定Skada等插件到聊天框中,绑定后右击右下角的>切换显示", "如左键点击了右下角的>使其隐藏,再次点击相同位置可显示"},
		ShiftAB = {"设置在动作条中的姿态条页", "可选是否变暗的样式"},
		TempEnchantMover = "武器(毒药/强化等)",
		TooltipMover = {"设置在鼠标提示页中", "可改变鼠标提示是否固定右下,还是智能跟随", "光环跟随时,可调偏移值, 固定右下位置请解锁移动"},
		TotemBarMover = {"图腾栏,设置在一般设置中", "不建议关闭,像武僧的雕像,DK的食尸鬼,SS的传送门都通过此框体显示"},
		VehicleSeatMover = "载具座位框",
		WatchFrameMover = "任务追踪框",
		playerBuffAnchorMover = {"EuiALM模块的玩家BUFF显示模块", "设置在ALM技能监视中"},
		playerDebuffAnchorMover = {"EuiALM模块的玩家DEBUFF显示模块", "设置在ALM技能监视中"},
		targetBuffAnchorMover = {"EuiALM模块的目标BUFF显示模块", "设置在ALM技能监视中"},
		targetDebuffAnchorMover = {"EuiALM模块的目标DEBUFF显示模块", "设置在ALM技能监视中"},
		spellCDAnchorMover = {"EuiALM模块的玩家技能CD显示模块", "设置在ALM技能监视中"},
		ShenxianFrameMover = {"奥法辅助输出插件", "设置在增强功能里的奥术冲击里"},
		EuiVegeanceIconMover = {"显示坦克职业坚韧的持续时间和增加的治疗数值", "设置在增强功能里的坚韧里"},
		EuiThreatFrameMover = {"一个独立的漂亮的仇恨条模块,可以清楚的知道你和MT之间的仇恨值","设置在增强功能的漂亮的仇恨条里"},
		EuiBanditsGuileIconMover = {"战斗DZ专用的洞悉控灯模块", "在增强功能中开关"},
		EuiBossSwingTimerBarMover = {"显示目标或焦点平砍时间的计时条", "在增强功能中开关"},
	}
elseif GetLocale() == 'zhTW' then
	E.MoveTooltip = {
		AlertFrameMover = "拾取 / 成就框",
		AltPowerBarMover = "特殊能量條",
		AurasMover = "BUFF/DEBUFF 窗口",
		AutoButtonAnchor2Mover = {"設置在增強功能的自動裝備飾品按鍵", "顯示玩家可使用的飾品,工程手套等"},
		AutoButtonAnchorMover = {"設置在增強功能的自動任務物品按鍵", "顯示玩家做任務時一些可使用的道具", "在農場時自動顯示農具和種子", "可顯示各種藥水,治療石"},
		BNETMover = {"戰網提示窗口", "可顯示實名好友上下線提示"},
		BossButton = "顯示BOSS戰中的一些特殊技能",
		ClassCDAnchorMover = "設置在增強功能的內置CD冷卻監視",
		CooldownFlashMover = "設置在技能監視組的中部冷卻閃光",
		ElvAB_1 = {"設置在動作條設置頁中", "可調大小,尺寸,每行顯示個數等"},
		ElvAB_2 = {"設置在動作條設置頁中", "可調大小,尺寸,每行顯示個數等"},
		ElvAB_3 = {"設置在動作條設置頁中", "可調大小,尺寸,每行顯示個數等"},
		ElvAB_4 = {"設置在動作條設置頁中", "可調大小,尺寸,每行顯示個數等"},
		ElvAB_5 = {"設置在動作條設置頁中", "可調大小,尺寸,每行顯示個數等"},
		ElvAB_6 = {"設置在動作條設置頁中", "可調大小,尺寸,每行顯示個數等", "默認未啟用"},
		ElvAB_7 = {"設置在動作條設置頁中", "可調大小,尺寸,每行顯示個數等", "默認未啟用"},
		ElvAB_8 = {"設置在動作條設置頁中", "可調大小,尺寸,每行顯示個數等", "默認未啟用"},
		ElvAB_9 = {"設置在動作條設置頁中", "可調大小,尺寸,每行顯示個數等", "默認未啟用"},
		ElvUF_PlayerMover = "設置在單位框體的玩家框體頁",
		ElvUF_PlayerAuraMover = {"設置在單位框體的玩家框體頁右側下拉里的光環條", "默認鎖定不可移動,需在其設置中解鎖後才能移動"},
		ElvUF_PlayerCastbarMover = {"設置在單位框體的玩家框體頁右側下拉里的施法條", "可以移動, 調節大小"},
		ElvUF_TargetCastbarMover = {"設置在單位框體的目標框體頁右側下拉里的施法條", "可以移動, 調節大小"},
		ElvUF_FocusCastbarMover = {"設置在單位框體的目標框體頁右側下拉里的施法條", "可以移動, 調節大小"},
		ElvUF_TargetMover = "設置在單位框體的目標框體頁",
		ElvUF_TargetAuraMover = {"設置在單位框體的目標框體頁右側下拉里的光環條", "默認鎖定不可移動,需在其設置中解鎖後才能移動"},
		ElvUF_TargetTargetMover = "設置在單位框體的目標的目標框體頁",
		ElvUF_FocusMover = "設置在單位框體的焦點框體頁",
		ElvUF_PartyMover = {"設置在單位框體的隊伍框體頁", "可調大小,尺寸,是否顯示目標和寵物等"},
		ElvUF_RaidMover = {"設置在單位框體的團隊框架頁", "用來顯示10人團隊的框架"},
	--	ElvUF_Raid25Mover = {"設置在單位框體的25人團隊框架頁", "用來顯示25人團隊的框架"},
		ElvUF_Raid40Mover = {"設置在單位框體的40人團隊框架頁", "用來顯示40人團隊的框架"},
		BossHeaderMover = {"設置在單位框體的BOSS框體頁", "可調大小,尺寸"},
		ArenaHeaderMover = {"設置在單位框體的競技場框體頁", "可調大小,尺寸"},
		EuiExecuteMover = {"設置在增強功能裡", "默認當各職業斬殺技能可用時顯示圖標提示", "可調大小,可設置提示音效"},
		EuiInfoBar1Mover = {"頂部信息條,在信息文字選項中調整顯示內容", "設成無後會自動隱藏.顯示區域的名稱的這塊不建議隱藏."},
		EuiInfoBar2Mover = {"頂部信息條,在信息文字選項中調整顯示內容", "設成無後會自動隱藏.顯示區域的名稱的這塊不建議隱藏."},
		EuiInfoBar3Mover = {"頂部信息條,在信息文字選項中調整顯示內容", "設成無後會自動隱藏.顯示區域的名稱的這塊不建議隱藏."},
		EuiInfoBar4Mover = {"頂部信息條,在信息文字選項中調整顯示內容", "設成無後會自動隱藏.顯示區域的名稱的這塊不建議隱藏."},
		EUIMinimapButtonMover = "方形小地圖圖標, 在增強功能里關閉,用來收集小地圖圖標",
		EuiMonkHealMover = "設置在增強功能裡",
		EuiMageFireMover = "設置在增強功能裡",
		ExperienceBarMover = "設置在一般設置中",
		GMMover = "GM 對話框",
		LeftChatPanelMover = {"設置在聊天框選項頁", "右上角有個小按鈕,左擊是複制聊天框內容,右擊是系統自帶錶情語言等菜單", "頂部的頻道切換條可在增強功能中關閉", "右上角的S用來發送用戶數據,E是表情,L是用來快速解鎖移動框體", "如左鍵點擊了左下角的<使其隱藏,再次點擊相同位置可顯示"},
		LootFrameMover = "設置在一般設置中,盡量不要關閉",
		LossControlMover = "迷失控制",
		MicrobarMover = "設置在動作條的微型系統菜單頁中,默認關閉",
		PetAB = {"設置在動作條的寵物動作條頁中", "調節每行按鍵數可改變橫豎外觀"},
		PRIESTAnchorMover = "顯示暗影牧師的暗影魔計時",
		RaidCDAnchorMover = {"設置在增強功能的團隊技能冷卻監視頁中", "默認計時條樣式,可改圖標樣式", "可增減監控的技能"},
		ReputationBarMover = "設置在一般設置中",
		RightChatPanelMover = {"設置在聊天框頁中", "可改大小尺寸", "可綁定Skada等插件到聊天框中,綁定後右擊右下角的>切換顯示", "如左鍵點擊了右下角的>使其隱藏,再次點擊相同位置可顯示"},
		ShiftAB = {"設置在動作條中的姿態條頁", "可選是否變暗的樣式"},
		TempEnchantMover = "武器(毒藥/強化等)",
		TooltipMover = {"設置在鼠標提示頁中", "可改變鼠標提示是否固定右下,還是智能跟隨", "光環跟隨時,可調偏移值, 固定右下位置請解鎖移動" },
		TotemBarMover = {"圖騰欄,設置在一般設置中", "不建議關閉,像武僧的雕像,DK的食屍鬼,SS的傳送門都通過此框體顯示"},
		VehicleSeatMover = "載具座位框",
		WatchFrameMover = "任務追踪框",
		playerBuffAnchorMover = {"EuiALM模塊的玩家BUFF顯示模塊", "設置在ALM技能監視中"},
		playerDebuffAnchorMover = {"EuiALM模塊的玩家DEBUFF顯示模塊", "設置在ALM技能監視中"},
		targetBuffAnchorMover = {"EuiALM模塊的目標BUFF顯示模塊", "設置在ALM技能監視中"},
		targetDebuffAnchorMover = {"EuiALM模塊的目標DEBUFF顯示模塊", "設置在ALM技能監視中"},
		spellCDAnchorMover = {"EuiALM模塊的玩家技能CD顯示模塊", "設置在ALM技能監視中"},
		ShenxianFrameMover ={"奧法輔助輸出插件", "設置在增強功能裡的奧術衝擊裡"},
		EuiVegeanceIconMover = {"顯示坦克職業堅韌持續時間和增加的治療數值", "設置在增強功能裏的堅韌頁裏"},
		EuiThreatFrameMover = {"一個獨立的漂亮的仇恨條模塊,可以清楚的知道你和MT之間的仇恨值","設置在增強功能的漂亮的仇恨條裡"},
		EuiBanditsGuileIconMover = {"戰鬥DZ專用的洞悉控燈模塊", "在增強功能中開關"},
		EuiBossSwingTimerBarMover = {"顯示目標或焦點平砍時間的計時條", "在增強功能中開關"},
	}
else
	E.MoveTooltip = {}
end