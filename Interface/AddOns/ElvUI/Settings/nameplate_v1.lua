local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

--NamePlate
P['nameplates_v1'] = {
	['statusbar'] = 'ElvUI Norm',
	['font'] = 'PT Sans Narrow',
	['fontSize'] = 11,
	['fontOutline'] = 'OUTLINE',
	['healthFont'] = 'PT Sans Narrow',
	['healthFontSize'] = 11,
	['healthFontOutline'] = 'OUTLINE',
	['durationPosition'] = 'CENTER',
	['stackFont'] = 'PT Sans Narrow',
	['stackFontSize'] = 9,
	['stackFontOutline'] = 'OUTLINE',
	['useTargetScale'] = true,
	['targetScale'] = 1.15,
	['nonTargetTransparency'] = 0.35,
	['motionType'] =  'STACKED',
	['displayStyle'] = 'ALL',
	['lowHealthThreshold'] = 0.4,
	['showFriendlyCombat'] = 'DISABLED',
	['showEnemyCombat'] = 'DISABLED',
	['hideBlizzardPlates'] = false,
	['showNPCTitles'] = true,
	['clampToScreen'] = false,
	['loadDistance'] = 40,
	['targetGlow'] = 'style2',
	['glowColor'] = { r = 77/255, g = 179/255, b = 255/255, a = 1 },
	['nameColoredGlow'] = false,
	['cutawayHealth'] = false,
	['cutawayHealthLength'] = 0.3,
	['cutawayHealthFadeOutTime'] = 0.6,
	['alwaysShowTargetHealth'] = true,
	['questIcon'] = true,
	['questIconSize'] = 16,
	['questIconText'] = true,
	['questIconPosition'] = 'LEFT', --by eui.cc
	['questIconXOffset'] = 4,--by eui.cc
	['questIconYOffset'] = 0,
	['cooldown'] = {
		['threshold'] = 4,
		['override'] = true,
		['reverse'] = false,
		['hideBlizzard'] = false,
		['expiringColor'] = { r = 1, g = 0, b = 0 },
		['secondsColor'] = { r = 1, g = 1, b = 1 },
		['minutesColor'] = { r = 1, g = 1, b = 1 },
		['hoursColor'] = { r = 1, g = 1, b = 1 },
		['daysColor'] = { r = 1, g = 1, b = 1 },

		['checkSeconds'] = false,
		['hhmmColor'] = { r = 1, g = 1, b = 1 },
		['mmssColor'] = { r = 1, g = 1, b = 1 },
		['hhmmThreshold'] = -1,
		['mmssThreshold'] = -1,

		['fonts'] = {
			['enable'] = false,
			['font'] = 'PT Sans Narrow',
			['fontOutline'] = 'OUTLINE',
			['fontSize'] = 10,
		},
	},
	['classbar'] = {
		['enable'] = true,
		['scale'] = 1,
		['attachTo'] = 'TARGET',
		['position'] = 'ABOVE'
	},
	['castColor'] = { r = 1,g = 208/255,b = 0 },
	['castNoInterruptColor'] = { r = 0.78, g = 0.25, b = 0.25 },
	['reactions'] = {
		['tapped'] = {r = 0.6, g = 0.6, b = 0.6},
		['good'] = {r = 75/255,  g = 175/255, b = 76/255},
		['neutral'] = { r = 218/255, g = 197/255, b = 92/255 },
		['bad'] = { r = 0.78, g = 0.25, b = 0.25 },
		['offline'] = {r = 0.3, g = 0.3, b = 0.3},
	},
	['healPrediction'] = {
		['personal'] = {r = 0, g = 1, b = 0.5, a = 0.25},
		['others'] = {r = 0, g = 1, b = 0, a = 0.25},
		['absorbs'] = {r = 1, g = 1, b = 0, a = 0.25},
		['healAbsorbs'] = {r = 1, g = 0, b = 0, a = 0.25},
		['overabsorbs'] = {r = 1, g = 1, b = 0, a = 0.25},
		['overhealabsorbs'] = {r = 1, g = 0, b = 0, a = 0.25},
	},
	['threat'] = {
		['goodColor'] = {r = 75/255,  g = 175/255, b = 76/255},
		['badColor'] = {r = 0.78, g = 0.25, b = 0.25},
		['goodTransition'] = { r = 218/255, g = 197/255, b = 92/255 },
		['badTransition'] ={ r = 235/255, g = 163/255, b = 40/255 },
		['beingTankedByTankColor'] = {r =.8, g = 0.1,b = 1},
		['beingTankedByTank'] = true,
		['goodScale'] = 0.8,
		['badScale'] = 1.2,
		['useThreatColor'] = true,
	},
	['filters'] = {
		['Boss'] = {
			['triggers'] = {
				['enable'] = false,
			},
		},
	},

	['clickableWidth'] = 150,
	['clickableHeight'] = 50,
	['clickThrough'] = {
		['personal'] = false,
		['friendly'] = false,
		['enemy'] = false,
	},

	['units'] = {
		['PLAYER'] = {
			['enable'] = false,
			['useStaticPosition'] = false,
			['clickthrough'] = false,
			['portrait'] = {
				['enable'] = false,
				['width'] = 30,
				['height'] = 24,
			},
			['visibility'] = {
				['showAlways'] = false,
				['showInCombat'] = true,
				['showWithTarget'] = false,
				['hideDelay'] = 3,
			},
			['healthbar'] = {
				['enable'] = true,
				['height'] = 10,
				['width'] = 150,
				['healPrediction'] = true,
				['glowStyle'] = 'TARGET_THREAT',
				['text'] = {
					['enable'] = false,
					['format'] = 'CURRENT',
				},
				['useClassColor'] = true,
			},
			['showName'] = false,
			['showLevel'] = false,
			['powerbar'] = {
				['enable'] = true,
				['hideWhenEmpty'] = false,
				['costPrediction'] = true,
				['height'] = 8,
				['text'] = {
					['enable'] = false,
					['format'] = 'CURRENT',
				},
			},
			['castbar'] = {
				['enable'] = true,
				['height'] = 8,
				['sourceInterrupt'] = false,
				['sourceInterruptClassColor'] = true,
				['displayTarget'] = false,
				['hideSpellName'] = false,
				['hideTime'] = false,
				['castTimeFormat'] = 'CURRENT',
				['channelTimeFormat'] = 'CURRENT',
				['timeToHold'] = 0,
				['iconPosition'] = 'RIGHT',
			},
			['buffs'] = {
				['enable'] = true,
				['numAuras'] = 4,
				['baseHeight'] = 18,
				["widthOverride"] = 0,
				['filters'] = {
					['minDuration'] = 0,
					['maxDuration'] = 300,
					['priority'] = 'Blacklist,blockNoDuration,Personal,TurtleBuffs,PlayerBuffs' --NamePlate Player Buffs
				},
			},
			['debuffs'] = {
				['enable'] = true,
				['numAuras'] = 4,
				['baseHeight'] = 18,
				["widthOverride"] = 0,
				['filters'] = {
					['minDuration'] = 0,
					['maxDuration'] = 0,
					['priority'] = 'Blacklist,blockNoDuration,Personal,Boss,CCDebuffs,RaidDebuffs,Dispellable' --NamePlate Player Debuffs
				},
			},
			['name'] = {
				['useClassColor'] = true,
			},
		},
		['HEALER'] = {
			['portrait'] = {
				['enable'] = false,
				['width'] = 30,
				['height'] = 24,
			},
			['healthbar'] = {
				['enable'] = true,
				['height'] = 10,
				['width'] = 150,
				['healPrediction'] = true,
				['glowStyle'] = 'TARGET_THREAT',
				['text'] = {
					['enable'] = false,
					['format'] = 'CURRENT',
				},
				['useClassColor'] = true,
			},
			['showName'] = true,
			['showLevel'] = false,
			['powerbar'] = {
				['enable'] = true,
				['hideWhenEmpty'] = false,
				['costPrediction'] = true,
				['height'] = 8,
				['text'] = {
					['enable'] = false,
					['format'] = 'CURRENT',
				},
			},
			['castbar'] = {
				['enable'] = true,
				['height'] = 8,
				['sourceInterrupt'] = false,
				['sourceInterruptClassColor'] = true,
				['displayTarget'] = false,
				['hideSpellName'] = false,
				['hideTime'] = false,
				['castTimeFormat'] = 'CURRENT',
				['channelTimeFormat'] = 'CURRENT',
				['timeToHold'] = 0,
				['iconPosition'] = 'RIGHT',
			},
			['buffs'] = {
				['enable'] = true,
				['numAuras'] = 4,
				['baseHeight'] = 18,
				["widthOverride"] = 0,
				['filters'] = {
					['minDuration'] = 0,
					['maxDuration'] = 0,
					['priority'] = 'Blacklist,blockNoDuration,Personal,TurtleBuffs' --NamePlate Healer Buffs
				},
			},
			['debuffs'] = {
				['enable'] = true,
				['numAuras'] = 4,
				['baseHeight'] = 18,
				["widthOverride"] = 0,
				['filters'] = {
					['minDuration'] = 0,
					['maxDuration'] = 0,
					['priority'] = 'Blacklist,Dispellable,blockNoDuration,Personal,Boss,CCDebuffs' --NamePlate Healer Debuffs
				},
			},
			['name'] = {
				['useClassColor'] = true,
			},
		},
		['FRIENDLY_PLAYER'] = {
			['portrait'] = {
				['enable'] = false,
				['width'] = 30,
				['height'] = 24,
			},
			['minions'] = false,
			['healthbar'] = {
				['enable'] = false,
				['height'] = 10,
				['width'] = 150,
				['healPrediction'] = true,
				['glowStyle'] = 'TARGET_THREAT',
				['text'] = {
					['enable'] = false,
					['format'] = 'CURRENT',
				},
				['useClassColor'] = true,
			},
			['showName'] = true,
			['showLevel'] = false,
			['powerbar'] = {
				['enable'] = false,
				['hideWhenEmpty'] = false,
				['costPrediction'] = true,
				['height'] = 8,
				['baseHeight'] = 18,
				['text'] = {
					['enable'] = false,
					['format'] = 'CURRENT',
				},
			},
			['castbar'] = {
				['enable'] = true,
				['height'] = 8,
				['sourceInterrupt'] = false,
				['sourceInterruptClassColor'] = true,
				['displayTarget'] = false,
				['hideSpellName'] = false,
				['hideTime'] = false,
				['castTimeFormat'] = 'CURRENT',
				['channelTimeFormat'] = 'CURRENT',
				['timeToHold'] = 0,
				['iconPosition'] = 'RIGHT',
			},
			['buffs'] = {
				['enable'] = true,
				['numAuras'] = 4,
				["baseHeight"] = 18,
				["widthOverride"] = 0,
				['filters'] = {
					['minDuration'] = 0,
					['maxDuration'] = 0,
					['priority'] = 'Blacklist,blockNoDuration,Personal,TurtleBuffs' --NamePlate FriendlyPlayer Buffs
				},
			},
			['debuffs'] = {
				['enable'] = true,
				['numAuras'] = 4,
				['baseHeight'] = 18,
				["widthOverride"] = 0,
				['filters'] = {
					['minDuration'] = 0,
					['maxDuration'] = 0,
					['priority'] = 'Blacklist,Dispellable,blockNoDuration,Personal,Boss,CCDebuffs' --NamePlate FriendlyPlayer Debuffs
				},
			},
			['name'] = {
				['useClassColor'] = true,
			},
		},
		['ENEMY_PLAYER'] = {
			['portrait'] = {
				['enable'] = false,
				['width'] = 30,
				['height'] = 24,
			},
			['minions'] = false,
			['markHealers'] = true,
			['healthbar'] = {
				['enable'] = true,
				['height'] = 10,
				['width'] = 150,
				['healPrediction'] = true,
				['glowStyle'] = 'TARGET_THREAT',
				['text'] = {
					['enable'] = false,
					['format'] = 'CURRENT',
				},
				['useClassColor'] = true,
			},
			['showName'] = true,
			['showLevel'] = true,
			['powerbar'] = {
				['enable'] = false,
				['hideWhenEmpty'] = false,
				['costPrediction'] = true,
				['height'] = 8,
				['text'] = {
					['enable'] = false,
					['format'] = 'CURRENT',
				},
			},
			['castbar'] = {
				['enable'] = true,
				['height'] = 8,
				['sourceInterrupt'] = false,
				['sourceInterruptClassColor'] = true,
				['displayTarget'] = false,
				['hideSpellName'] = false,
				['hideTime'] = false,
				['castTimeFormat'] = 'CURRENT',
				['channelTimeFormat'] = 'CURRENT',
				['timeToHold'] = 0,
				['iconPosition'] = 'RIGHT',
			},
			['buffs'] = {
				['enable'] = true,
				['numAuras'] = 4,
				['baseHeight'] = 18,
				["widthOverride"] = 0,
				['filters'] = {
					['minDuration'] = 0,
					['maxDuration'] = 300,
					['priority'] = 'Blacklist,Dispellable,PlayerBuffs,TurtleBuffs' --NamePlate EnemyPlayer Buffs
				},
			},
			['debuffs'] = {
				['enable'] = true,
				['numAuras'] = 4,
				['baseHeight'] = 18,
				["widthOverride"] = 0,
				['filters'] = {
					['minDuration'] = 0,
					['maxDuration'] = 0,
					['priority'] = 'Blacklist,blockNoDuration,Personal,Boss,CCDebuffs,RaidDebuffs' --NamePlate EnemyPlayer Debuffs
				},
			},
			['name'] = {
				['useClassColor'] = true,
			},
		},
		['FRIENDLY_NPC'] = {
			['portrait'] = {
				['enable'] = false,
				['width'] = 30,
				['height'] = 24,
			},
			['healthbar'] = {
				['enable'] = false,
				['height'] = 10,
				['width'] = 150,
				['healPrediction'] = true,
				['glowStyle'] = 'TARGET_THREAT',
				['text'] = {
					['enable'] = false,
					['format'] = 'CURRENT',
				},
			},
			['showName'] = true,
			['showLevel'] = true,
			['powerbar'] = {
				['enable'] = false,
				['hideWhenEmpty'] = false,
				['costPrediction'] = true,
				['height'] = 8,
				['text'] = {
					['enable'] = false,
					['format'] = 'CURRENT',
				},
			},
			['castbar'] = {
				['enable'] = false,
				['height'] = 8,
				['sourceInterrupt'] = false,
				['sourceInterruptClassColor'] = true,
				['displayTarget'] = false,
				['hideSpellName'] = false,
				['hideTime'] = false,
				['castTimeFormat'] = 'CURRENT',
				['channelTimeFormat'] = 'CURRENT',
				['timeToHold'] = 0,
				['iconPosition'] = 'RIGHT',
			},
			['buffs'] = {
				['enable'] = true,
				['numAuras'] = 4,
				['baseHeight'] = 18,
				["widthOverride"] = 0,
				['filters'] = {
					['minDuration'] = 0,
					['maxDuration'] = 0,
					['priority'] = 'Blacklist,blockNoDuration,Personal,TurtleBuffs' --NamePlate FriendlyNPC Buffs
				},
			},
			['debuffs'] = {
				['enable'] = true,
				['numAuras'] = 4,
				['baseHeight'] = 18,
				["widthOverride"] = 0,
				['filters'] = {
					['minDuration'] = 0,
					['maxDuration'] = 0,
					['priority'] = 'Blacklist,Boss,CCDebuffs,RaidDebuffs,Dispellable' --NamePlate FriendlyNPC Debuffs
				},
			},
			['eliteIcon'] = {
				['enable'] = false,
				['size'] = 20,
				['position'] = 'RIGHT',
				['xOffset'] = 15,
				['yOffset'] = 0,
			},
		},
		['ENEMY_NPC'] = {
			['portrait'] = {
				['enable'] = false,
				['width'] = 30,
				['height'] = 24,
			},
			['minors'] = true,
			['healthbar'] = {
				['enable'] = true,
				['height'] = 10,
				['width'] = 150,
				['healPrediction'] = true,
				['glowStyle'] = 'TARGET_THREAT',
				['text'] = {
					['enable'] = false,
					['format'] = 'CURRENT',
				},
			},
			['showName'] = true,
			['showLevel'] = true,
			['powerbar'] = {
				['enable'] = false,
				['hideWhenEmpty'] = false,
				['costPrediction'] = true,
				['height'] = 8,
				['text'] = {
					['enable'] = false,
					['format'] = 'CURRENT',
				},
			},
			['castbar'] = {
				['enable'] = true,
				['height'] = 8,
				['sourceInterrupt'] = false,
				['sourceInterruptClassColor'] = true,
				['displayTarget'] = false,
				['hideSpellName'] = false,
				['hideTime'] = false,
				['castTimeFormat'] = 'CURRENT',
				['channelTimeFormat'] = 'CURRENT',
				['timeToHold'] = 0,
				['iconPosition'] = 'RIGHT',
			},
			['buffs'] = {
				['enable'] = true,
				['numAuras'] = 4,
				['baseHeight'] = 18,
				["widthOverride"] = 0,
				['filters'] = {
					['minDuration'] = 0,
					['maxDuration'] = 0,
					['priority'] = 'Blacklist,RaidBuffsElvUI,blockNoDuration,PlayerBuffs,TurtleBuffs,CastByUnit' --NamePlate EnemyNPC Buffs
				},
			},
			['debuffs'] = {
				['enable'] = true,
				['numAuras'] = 4,
				['baseHeight'] = 18,
				["widthOverride"] = 0,
				['filters'] = {
					['minDuration'] = 0,
					['maxDuration'] = 0,
					['priority'] = 'Blacklist,Personal,CCDebuffs' --NamePlate EnemyNPC Debuffs
				},
			},
			['eliteIcon'] = {
				['enable'] = false,
				['size'] = 20,
				['position'] = 'RIGHT',
				['xOffset'] = 15,
				['yOffset'] = 0,
			},
			['detection'] = {
				['enable'] = true,
			},
		},
	},
};

P['nameplates_v1']["nameplateOverlapH"] = 0.3
P['nameplates_v1']["nameplateOverlapV"] = 0.7
P['nameplates_v1']["font"] = 'EUI'
P['nameplates_v1']["durationFont"] = 'EUI'
P['nameplates_v1']["stackFont"] = 'EUI'
P['nameplates_v1']["motionType"] = 'OVERLAP'
P['nameplates_v1']["clampToScreen"] = true
P['nameplates_v1']["units"]['PLAYER']['healthbar']['text']['enable'] = true
P['nameplates_v1']["units"]['PLAYER']['healthbar']['text']['format'] = 'CURRENT_MAX'
P['nameplates_v1']["units"]['PLAYER']['buffs']['numAuras'] = 6
P['nameplates_v1']["units"]['PLAYER']['buffs']['baseHeight'] = 26
P['nameplates_v1']["units"]['PLAYER']['debuffs']['numAuras'] = 6
P['nameplates_v1']["units"]['PLAYER']['debuffs']['baseHeight'] = 26
P['nameplates_v1']["units"]['HEALER']['healthbar']['text']['enable'] = true
P['nameplates_v1']["units"]['HEALER']['healthbar']['text']['format'] = 'CURRENT_MAX'
P['nameplates_v1']["units"]['HEALER']['buffs']['numAuras'] = 6
P['nameplates_v1']["units"]['HEALER']['buffs']['baseHeight'] = 26
P['nameplates_v1']["units"]['HEALER']['debuffs']['numAuras'] = 6
P['nameplates_v1']["units"]['HEALER']['debuffs']['baseHeight'] = 26
P['nameplates_v1']["units"]['FRIENDLY_PLAYER']['healthbar']['text']['enable'] = true
P['nameplates_v1']["units"]['FRIENDLY_PLAYER']['healthbar']['text']['format'] = 'CURRENT_MAX'
P['nameplates_v1']["units"]['FRIENDLY_PLAYER']['buffs']['numAuras'] = 6
P['nameplates_v1']["units"]['FRIENDLY_PLAYER']['buffs']['baseHeight'] = 26
P['nameplates_v1']["units"]['FRIENDLY_PLAYER']['debuffs']['numAuras'] = 6
P['nameplates_v1']["units"]['FRIENDLY_PLAYER']['debuffs']['baseHeight'] = 26
P['nameplates_v1']["units"]['ENEMY_PLAYER']['healthbar']['text']['enable'] = true
P['nameplates_v1']["units"]['ENEMY_PLAYER']['healthbar']['text']['format'] = 'CURRENT_MAX'
P['nameplates_v1']["units"]['ENEMY_PLAYER']['buffs']['numAuras'] = 6
P['nameplates_v1']["units"]['ENEMY_PLAYER']['buffs']['baseHeight'] = 26
P['nameplates_v1']["units"]['ENEMY_PLAYER']['debuffs']['numAuras'] = 6
P['nameplates_v1']["units"]['ENEMY_PLAYER']['debuffs']['baseHeight'] = 26
P['nameplates_v1']["units"]['FRIENDLY_NPC']['healthbar']['text']['enable'] = true
P['nameplates_v1']["units"]['FRIENDLY_NPC']['healthbar']['text']['format'] = 'CURRENT_MAX'
P['nameplates_v1']["units"]['FRIENDLY_NPC']['buffs']['numAuras'] = 6
P['nameplates_v1']["units"]['FRIENDLY_NPC']['buffs']['baseHeight'] = 26
P['nameplates_v1']["units"]['FRIENDLY_NPC']['debuffs']['numAuras'] = 6
P['nameplates_v1']["units"]['FRIENDLY_NPC']['debuffs']['baseHeight'] = 26
P['nameplates_v1']["units"]['ENEMY_NPC']['healthbar']['text']['enable'] = true
P['nameplates_v1']["units"]['ENEMY_NPC']['healthbar']['text']['format'] = 'CURRENT_MAX'
P['nameplates_v1']["units"]['ENEMY_NPC']['buffs']['numAuras'] = 6
P['nameplates_v1']["units"]['ENEMY_NPC']['buffs']['baseHeight'] = 26
P['nameplates_v1']["units"]['ENEMY_NPC']['debuffs']['numAuras'] = 6
P['nameplates_v1']["units"]['ENEMY_NPC']['debuffs']['baseHeight'] = 26

P['nameplates_v1'].font = "EUI"
P['nameplates_v1'].fontSize = 12
P['nameplates_v1'].fontOutline = 'OUTLINE'
	

P['nameplates_v1'].auraTimeOffsetX = 1
P['nameplates_v1'].auraTimeOffsetY = 1
P['nameplates_v1'].auraCountOffsetX = 0
P['nameplates_v1'].auraCountOffsetY = 0

P['nameplates_v1']['targetGlow_y'] = 4;
P['nameplates_v1']['targetGlow_x'] = 4;
P['nameplates_v1']['targetGlow_y_size'] = 45;
P['nameplates_v1']['targetGlow_x_size'] = 45;
P['nameplates_v1']['topArrowType'] = 'nameplateTargetIndicator';
P['nameplates_v1']['leftArrowType'] = '';

P['nameplates_v1']['targetIndicator'] = {
	['enable'] = false,
	['style'] = 'arrow',
	['color'] = {r= 1, g = 1, b = 1},
	['width'] = 50,
	['height'] = 50,
	['yOffset'] = 0,
	['xOffset'] = 0
}
P['nameplates_v1'].QuestIcon = {
	['enable'] = true,
	['xOffset'] = 2,
	['yOffset'] = 0,
	['size'] = 22,
}

G["profileCopy"]["nameplates_v1"] = {
	["general"] = true,
	["cooldown"] = true,
	["classbar"] = true,
	["reactions"] = true,
	["healPrediction"] = true,
	["threat"] = true,
	["units"] = {
		["PLAYER"] = true,
		["HEALER"] = true,
		["FRIENDLY_PLAYER"] = true,
		["ENEMY_PLAYER"] = true,
		["FRIENDLY_NPC"] = true,
		["ENEMY_NPC"] = true,
	},
}

V['nameplates_v1'] = {
	['enable'] = false,
}