local E, _, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local C, L = unpack(select(2, ...))
local Module = E:GetModule("AuraWatch")

-- BuildGUI
local GruopValue, AuraList, GroupSelectValue, AuraSelectValue = {}, {}, 1, 1
local function UpdateAuraList()
	AuraList = {
		AuraSelect = {
			type = "select", order = 1, 
			name = L["Choise Aura group"],
			values = function()
				local Table = {}
				for key, value in pairs(E.db.AuraWatch.DB[GroupSelectValue]["List"]) do
					if value["AuraID"] then
						if GetSpellInfo(value["AuraID"]) then
							Table[key] = GetSpellInfo(value["AuraID"])
						else
							E.db.AuraWatch.DB[GroupSelectValue]["List"][key] = nil
						end
					end
					if value["SpellID"] then Table[key] = GetSpellInfo(value["SpellID"]) or value["SpellID"] end
					if value["ItemID"] then Table[key] = GetItemInfo(value["ItemID"]) or value["AuraID"] end
				end
				return Table
			end, 
			get = function() return AuraSelectValue end, 
			set = function(_, value)
				AuraSelectValue = value
				UpdateAuraList()
			end, 
		}, 
		AddNewAura = {
			type = "execute", order = 2, 
			name = L["Add New Aurar"],
			func = function()
				tinsert(E.db.AuraWatch.DB[GroupSelectValue]["List"], {AuraID = 118, UnitID = "player", filter = "DEBUFF"})
				AuraSelectValue = #E.db.AuraWatch.DB[GroupSelectValue]["List"]
				UpdateAuraList()
				Module:DeleteAllFrame(); Module:BuildAura(); Module:UpdatePos();
			end, 
		}, 
		DeleteAura = {
			type = "execute", order = 3, 
			name = L["Delete Aura"], 
			func = function()
				if #E.db.AuraWatch.DB[GroupSelectValue]["List"] == 1 then return; end
				tremove(E.db.AuraWatch.DB[GroupSelectValue]["List"], AuraSelectValue)
				AuraSelectValue = AuraSelectValue-1 > 0 and AuraSelectValue-1 or 1
				UpdateAuraList()
				Module:DeleteAllFrame(); Module:BuildAura(); Module:UpdatePos();
			end, 
		}, 
		AuraID = {
			type = "input", order = 4, 
			name = L["AuraID："], desc = L["Input BUFF/DEBUFF's AuraID, SpellID or ItemID"], 
			get = function()
				local Aura = E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]
				if not Aura then return '' end
				if Aura["AuraID"] then return tostring(Aura["AuraID"]) end
				if Aura["SpellID"] then return tostring(Aura["SpellID"]) end
				if Aura["ItemID"] then return tostring(Aura["ItemID"]) end			
			end, 
			set = function(_, value)
				local Aura = E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]
				if Aura["AuraID"] and GetSpellInfo(value) then Aura["AuraID"] = tonumber(value) return end
				if Aura["SpellID"] and GetSpellInfo(value) then Aura["SpellID"] = tonumber(value) return end
				if Aura["ItemID"] and GetItemInfo(value) then Aura["ItemID"] = tonumber(value) return end
			end,
		}, 
		Mode = {
			type = "select", order = 5, 
			name = L["Monitor Type: "], 
			values = {["AuraID"] = L["Aura"], ["SpellID"] = L["Spell CD"], ["ItemID"] = L["Item ID"]}, 
			get = function()
				local Aura = E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]
				if Aura["AuraID"] then return "AuraID" end
				if Aura["SpellID"] then return "SpellID" end
				if Aura["ItemID"] then return "ItemID" end	
			end, 
			set = function(_, value)
				local Aura = E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]
				if value == "AuraID" then Aura["AuraID"] = 118 Aura["SpellID"] = nil Aura["ItemID"] = nil end
				if value == "SpellID" then Aura["AuraID"] = nil Aura["SpellID"] = 118 Aura["ItemID"] = nil end
				if value == "ItemID" then Aura["AuraID"] = nil Aura["SpellID"] = nil Aura["ItemID"] = 6948 end
				UpdateAuraList()
			end, 
		}, 
		UnitID = {
			type = "select", order = 6, 
			name = L["Monitor Object: "], 
			values = {["player"] = L['Player'], ["target"] = L['Target'], ["pet"] = L["pet"], ["focus"] = L["focus"]}, 
			get = function() return E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]["UnitID"] end, 
			set = function(_, value) E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]["UnitID"] = value end,
		}, 
		Caster = {
			type = "select", order = 7, 
			name = L["Filter by caster: "], 
			values = {["player"] = L['Player'], ["None"] = L["None"]}, 
			get = function() return E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]["Caster"] or "None" end, 
			set = function(_, value)
				if value == "None" then
					E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]["Caster"] = nil
				else
					E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]["Caster"] = value
				end
			end,
		}, 
		Filter = {
			type = "select", order = 7, 
			name = L["Filter by type: "], 
			values = {["BUFF"] = L['BUFF'], ["DEBUFF"] = L["DEBUFF"], ["CD"] = L["CD"]}, 
			get = function() return E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]["filter"] or "DEBUFF" end, 
			set = function(_, value)
				if value then
					E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]["filter"] = value
				end
			end,
		}, 
		Stack = {
			type = "select", order = 8, 
			name = L["Filter by Stacked layers: "], 
			values = {[0] = L["None"], [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6, [7] = 7, [8] = 8, [9] = 9, [10] = 10, [11] = 11, [12] = 12, [13] = 13, [14] = 14, [15] = 15, [16] = 16, [17] = 17, [18] = 18, [19] = 19, [20] = 20}, 
			get = function() return E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]["Stack"] or 0 end, 
			set = function(_, value)
				if value == 0 then
					E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]["Stack"] = nil
				else
					E.db.AuraWatch.DB[GroupSelectValue]["List"][AuraSelectValue]["Stack"] = value
				end
			end,
		}, 
	}
end
local function UpdateGruopValue()
	GruopValue = {
		GroupSelect = {
			type = "select", order = 1, 
			name = L["Choise Group:"],
			values = function()
				local Table = {}
				for key, value in pairs(E.db.AuraWatch.DB) do Table[key] = value["Name"] end
				return Table
			end, 
			get = function() return GroupSelectValue end, 
			set = function(_, value)
				GroupSelectValue = value
				UpdateGruopValue()
				UpdateAuraList()
				AuraSelectValue = 1
			end, 
		}, 
		AddNewGroup = {
			type = "execute", order = 2, 
			name = L["Add Group"], 	
			func = function()
				tinsert(E.db.AuraWatch.DB, {
					Name = L["New Group"], 
					Direction = "RIGHT", Interval = 8, 
					Mode = "ICON", IconSize = 48, 
					Pos = {"CENTER", "UIParent", "CENTER", 0, 0},
					List = {{AuraID = 118, UnitID = "player", filter = "DEBUFF"}}
				})
				GroupSelectValue = #E.db.AuraWatch.DB
				UpdateGruopValue()
				Module:DeleteAllFrame(); Module:BuildAura(); Module:UpdatePos();
			end, 
		}, 
		DeleteGroup = {
			type = "execute", order = 3, 
			name = L["Delete Group"], 
			func = function()
				if #E.db.AuraWatch.DB == 1 then return; end
				tremove(E.db.AuraWatch.DB, GroupSelectValue)
				GroupSelectValue = GroupSelectValue-1 > 0 and GroupSelectValue-1 or 1
				UpdateGruopValue()
				Module:DeleteAllFrame(); Module:BuildAura(); Module:UpdatePos();
			end, 
		}, 
		GroupName = {
			type = "input", order = 4, 
			name = L["Group Name"], desc = L["Input Group's Name"],
			get = function() return E.db.AuraWatch.DB[GroupSelectValue]["Name"] end, 
			set = function(_, value)
				if value == '通用监视组' then
					E:Print("禁止使用[通用监视组]这个光环组名称")
				else
					E.db.AuraWatch.DB[GroupSelectValue]["Name"] = value;
					Module:DeleteAllFrame();
					Module:BuildAura();
					Module:UpdatePos();
				end
			end,
		}, 
		Mode = {
			type = "select", order = 4, 
			name = L["Display Mode"],
			values = {["ICON"] = L["Icon Mode"], ["BAR"] = L["Bar Mode"]}, 
			get = function() return E.db.AuraWatch.DB[GroupSelectValue]["Mode"] end, 
			set = function(_, value)
				E.db.AuraWatch.DB[GroupSelectValue]["Mode"] = value
				if not E.db.AuraWatch.DB[GroupSelectValue]["BarWidth"] then E.db.AuraWatch.DB[GroupSelectValue]["BarWidth"] = 200 end
				Module:DeleteAllFrame(); Module:BuildAura(); Module:UpdatePos();
			end, 
		}, 
		Direction = {
			type = "select", order = 5, 
			name = L["Direction"], desc = L["Growth direction"], 
			values = {["LEFT"] = L["LEFT"], ["RIGHT"] = L["RIGHT"], ["UP"] = L["UP"], ["DOWN"] = L["DOWN"]}, 
			get = function() return E.db.AuraWatch.DB[GroupSelectValue].Direction end, 
			set = function(_, value) E.db.AuraWatch.DB[GroupSelectValue].Direction = value; Module:UpdatePos(); end, 
		}, 
		Interval = {
			type = "range", order = 6, 
			name = L["Interval"],
			min = 0, max = 30, step = 1, 
			get = function() return E.db.AuraWatch.DB[GroupSelectValue].Interval end, 
			set = function(_, value) E.db.AuraWatch.DB[GroupSelectValue].Interval = value; Module:UpdatePos(); end, 
		}, 
		IconSize = {
			type = "range", order = 7, 
			name = L["Icon Size"], 
			min = 8, max = 64, step = 1, 
			get = function() return E.db.AuraWatch.DB[GroupSelectValue].IconSize end, 
			set = function(_, value) E.db.AuraWatch.DB[GroupSelectValue].IconSize = value; Module:DeleteAllFrame(); Module:BuildAura(); Module:UpdatePos(); end, 
		}, 
		BarWidth = {
			type = "range", order = 8, 
			name = L["Bar Width"],
			min = 20, max = 300, step = 5, 
			get = function() return E.db.AuraWatch.DB[GroupSelectValue]["BarWidth"] end, 
			set = function(_, value) E.db.AuraWatch.DB[GroupSelectValue]["BarWidth"] = value; Module:DeleteAllFrame(); Module:BuildAura(); Module:UpdatePos(); end, 
		}, 		
	}
end

UpdateGruopValue()
UpdateAuraList()

E.Options.args.Watch.args.AuraWatch = {
	type = "group", 
--	childGroups = "tab",
	name = '02.'..E.ValColor..L["AuraWatch"].."|r",
	order = 2,
	args = {
		intro = {
			order = 0,
			type = "description",
			name = L["Sora's AuraWatch"],
			width = "full",		
		},		
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			get = function() return E.private.AuraWatch.enable end,
			set = function(info, value)
				E.private.AuraWatch.enable = value;
				E:StaticPopup_Show("CONFIG_RL");
			end
		},	
		Default = {
			type = "execute",
			order = 2,
			name = L["Defaults"],
			disabled = function() return not E.private.AuraWatch.enable end,
			func = function() wipe(E.db.AuraWatch.DB); E.private.AuraWatch.enable = false; E.db.AuraWatch.loadDefault = false; Module:LoadSettings(); end,
		},
		checkSpellid = {
			type = "toggle",
			order = 3,
			name = L["Strict Filter"]..'ID',
			set = function(info, value) E.private.AuraWatch.checkSpellid = value end,
			get = function() return E.private.AuraWatch.checkSpellid end,
		},
		delay = {
			type = "range",
			order = 4,
			name = L["Update interval"],
			desc = L["The smaller the interval, the greater the impact on performance, low-performance computers preferably not less than 0.2"],
			min = 0.01, max = 1, step = 0.01,
			disabled = function() return not E.private.AuraWatch.enable end,
			set = function(info, value) E.db.AuraWatch.delay = value; E:StaticPopup_Show("CONFIG_RL"); end,
			get = function() return E.db.AuraWatch.delay end,
		},
		Spellname = {
			type = "toggle",
			order = 5,
			name = L["Show spell name:"],
			set = function(info, value) E.db.AuraWatch.Spellname = value end,
			get = function() return E.db.AuraWatch.Spellname end,
		},		
		fontGroup = {
			order = 10,
			type = 'group',
			guiInline = true,
			name = L['Fonts'],
			get = function(info) return E.db.AuraWatch[ info[#info] ] end,
			set = function(info, value) E.db.AuraWatch[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,			
			args = {
				font = {
					type = "select", dialogControl = 'LSM30_Font',
					order = 4,
					name = L["Font"],
					values = AceGUIWidgetLSMlists.font,
				},
				fontSize = {
					order = 5,
					name = L["Count Font Size"],
					type = "range",
					min = 4, max = 22, step = 1,
				},	
				fontSize2 = {
					order = 5,
					name = L["Spellname Font Size"],
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
		GruopValue= {
			type = "group", order = 20, 
			name = " ", guiInline = true, 
			disabled = function() return not E.private.AuraWatch.enable end,
			args = GruopValue, 
		}, 
		AuraList = {
			type = "group", order = 30, 
			name = " ", guiInline = true, 
			disabled = function() return not E.private.AuraWatch.enable end,
			args = AuraList, 
		},
	}
}