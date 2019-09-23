-- Engines
local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local Module = E:GetModule("SoraClassTimer")

E.Options.args.Watch.args.SoraClassTimer =  {
	type = "group", order = 3,
	name = '03.'..E.ValColor..L["SoraClassTimer"].."|r",
	args = {
		intro = {
			type = "description", order = 0,
			name = L["Sora's ClassTimer desc"],
			width = "full",
		},
		enable = {
			type = "toggle", order = 1,
			name = L["Enable"],
			get = function() return E.private.SoraClassTimer.enable end,
			set = function(_, value)
				E.private.SoraClassTimer.enable = value;	
				E:StaticPopup_Show("CONFIG_RL") 
			end
		},
		default = {
			type = "execute", order = 2,
			name = L["Defaults"],
			disabled = function() return not E.private.SoraClassTimer.enable end,
			func = function() E.db.SoraClassTimer = P["SoraClassTimer"]; StaticPopup_Show("CONFIG_RL") end,
		},
		timelimit = {
			type = "range", order = 3,
			name = L['Duration Limit'],
			desc = L['The aura must be below this duration for the buff to show, set to 0 to disable. Note: This is in seconds.'],
			get = function(info) return E.db.SoraClassTimer.timelimit end,
			set = function(info, value) E.db.SoraClassTimer.timelimit = value; end,
			min = 0, max = 300, step = 1,
		},
		fontGroup = {
			order = 4,
			type = 'group',
			guiInline = true,
			name = L['Fonts'],
			get = function(info) return E.db.SoraClassTimer[ info[#info] ] end,
			set = function(info, value) E.db.SoraClassTimer[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,			
			args = {
				font = {
					type = "select", dialogControl = 'LSM30_Font',
					order = 4,
					name = L["Font"],
					values = AceGUIWidgetLSMlists.font,
				},
				fontSize = {
					order = 5,
					name = L["Font Size"],
					type = "range",
					min = 4, max = 22, step = 1,
				},	
				fontOutline = {
					order = 6,
					name = L["Font Outline"],
					desc = L["Set the font outline."],
					type = "select",
					values = {
						['NONE'] = L['None'],
						['OUTLINE'] = 'OUTLINE',
						['MONOCHROME'] = 'MONOCHROME',
						['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
						['THICKOUTLINE'] = 'THICKOUTLINE',
					},
				},	
			},
		},		
		Gruop_1 = {
			type = "group", order = 10, 
			name = " ", guiInline = true, 
			disabled = function() return not E.private.SoraClassTimer.enable end,
			args = {
				PlayerMode = {
					type = "select", order = 1,
					name = L["Player Aura Timer"], desc = L["Choise Timer Mode"],
					values = {["Bar"] = L["Bar Mode"], ["Icon"] = L["Icon Mode"], ["None"] = L["None"]},
					get = function() return E.db.SoraClassTimer["PlayerMode"] end,
					set = function(_, value)
						E.db.SoraClassTimer["PlayerMode"] = value
						Module:ClearAura("player")
					end,
				},
				PlayerIconSize = {
					type = "range", order = 2,
					name = L["Player Aura Timer Icon Size"],
					min = 10, max = 100, step = 1,
					width = "double",
					get = function() return E.db.SoraClassTimer["PlayerIconSize"] end,
					set = function(_, value)
						E.db.SoraClassTimer["PlayerIconSize"] = value
						Module:ClearAura("player")
					end,
				},
				TargetMode = {
					type = "select", order = 3,
					name = L["Target Aura Timer"], desc = L["Choise Timer Mode"],
					values = {["Bar"] = L["Bar Mode"], ["Icon"] = L["Icon Mode"], ["None"] = L["None"]},
					get = function() return E.db.SoraClassTimer["TargetMode"] end,
					set = function(_, value)
						E.db.SoraClassTimer["TargetMode"] = value
						Module:ClearAura("target")
					end,
				}, 
				TargetIconSize = {
					type = "range", order = 4,
					name = L["Target Aura Timer Icon Size"],
					min = 10, max = 100, step = 1,
					width = "double",
					get = function() return E.db.SoraClassTimer["TargetIconSize"] end,
					set = function(_, value)
						E.db.SoraClassTimer["TargetIconSize"] = value
						Module:ClearAura("target")
					end,
				},
			},
		}, 
		Gruop_2 = {
			type = "group", order = 11, 
			name = L["Blacklist"], guiInline = true, 
			desc = L["Always will not be displayed"],
			disabled = function() return (E.db.SoraClassTimer["PlayerMode"] == "None" and E.db.SoraClassTimer["TargetMode"] == "None") end,
			args = Module.BlackListTable,
		}, 
		Gruop_3 = {
			type = "group", order = 12, 
			name = L["Whitelist"], guiInline = true, 
			desc = L["Without a time limit of 60 seconds, and will always be displayed"],
			disabled = function() return (E.db.SoraClassTimer["PlayerMode"] == "None" and E.db.SoraClassTimer["TargetMode"] == "None") end,
			args = Module.WhiteListTable,
		}, 
	},
}

