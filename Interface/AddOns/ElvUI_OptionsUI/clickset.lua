local E, _, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local C, L = unpack(select(2, ...))
local ClickSet = E:GetModule('ClickSet')
local UF = E:GetModule('UnitFrames');
	
E.Options.args.clickset = {
	type = "group",
	name = '07.'..L["ClickSet"],
	childGroups = "tab",
	get = function(info) return E.db.clickset[ info[#info] ] end,
	set = function(info, value) E.db.clickset[ info[#info] ] = value; ClickSet:updateClickset() end,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = L["CLICKSET_DESC"],
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value) E.db.clickset[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,
		},
		dispel = {
			order = 4,
			type = "toggle",
			name = L["mousedispel"],
			desc = L["MOUSEDISPEL_DESC"],
			get = function() return E.db.euiscript.dispel end,
			set = function(info, value)
				if not value then
					SetBinding("MOUSEWHEELUP", "CAMERAZOOMIN");
					SetBinding("MOUSEWHEELDOWN", "CAMERAZOOMOUT");
					SaveBindings(2);
					if GetMacroInfo("EuiDebuffa") then DeleteMacro("EuiDebuffa") end
					if GetMacroInfo("EuiDebuffb") then DeleteMacro("EuiDebuffb") end
				end
				E.db.euiscript.dispel = value; 
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},		
		spec1 = {
			type = 'group',
			name = L['Spec'],
			order = 10,
			get = function(info) return E.db.clickset.spec1[ info[#info] ] end,
			set = function(info, value) E.db.clickset.spec1[ info[#info] ] = value; ClickSet:updateClickset() end,			
			args = {		
				MouseButton1 = {
					order = 4,
					type = "group",
					name = L["MouseButton1"],
					disabled = function() return not E.db.clickset.enable end,	
					args = {
						type1 = {
							order = 1,
							type = "select",
							name = L["type1"],
							desc = L["TYPE1_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						shiftztype1 = {
							order = 2,
							type = "select",
							name = L["shiftztype1"],
							desc = L["SHIFTZTYPE1_DESC"],
							values = {
								["NONE"] = L["None"],
							},				
						},
						ctrlztype1 = {
							order = 3,
							type = "select",
							name = L["ctrlztype1"],
							desc = L["CTRLZTYPE1_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						altztype1 = {
							order = 4,
							type = "select",
							name = L["altztype1"],
							desc = L["ALTZTYPE1_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						altzctrlztype1 = {
							order = 5,
							type = "select",
							name = L["altzctrlztype1"],
							desc = L["ALTZCTRLZTYPE1_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						shiftzaltztype1 = {
							order = 6,
							type = "select",
							name = L["shiftzaltztype1"],
							desc = L["SHIFTZALTZTYPE1_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
					},
				},
				MouseButton2 = {
					order = 5,
					type = "group",
					name = L["MouseButton2"],
					disabled = function() return not E.db.clickset.enable end,	
					args = {				
						type2 = {
							order = 1,
							type = "select",
							name = L["type2"],
							desc = L["TYPE2_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						shiftztype2 = {
							order = 2,
							type = "select",
							name = L["shiftztype2"],
							desc = L["SHIFTZTYPE2_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						ctrlztype2 = {
							order = 3,
							type = "select",
							name = L["ctrlztype2"],
							desc = L["CTRLZTYPE2_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						altztype2 = {
							order = 4,
							type = "select",
							name = L["altztype2"],
							desc = L["ALTZTYPE2_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						altzctrlztype2 = {
							order = 5,
							type = "select",
							name = L["altzctrlztype2"],
							desc = L["ALTZCTRLZTYPE2_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						shiftzaltztype2 = {
							order = 6,
							type = "select",
							name = L["shiftzaltztype2"],
							desc = L["SHIFTZALTZTYPE2_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},						
					},
				},
				MouseButton3 = {
					order = 6,
					type = "group",
					name = L["MouseButton3"],
					disabled = function() return not E.db.clickset.enable end,	
					args = {				
						type3 = {
							order = 1,
							type = "select",
							name = L["type3"],
							desc = L["TYPE3_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						shiftztype3 = {
							order = 2,
							type = "select",
							name = L["shiftztype3"],
							desc = L["SHIFTZTYPE3_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						ctrlztype3 = {
							order = 3,
							type = "select",
							name = L["ctrlztype3"],
							desc = L["CTRLZTYPE3_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						altztype3 = {
							order = 4,
							type = "select",
							name = L["altztype3"],
							desc = L["ALTZTYPE3_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						altzctrlztype3 = {
							order = 5,
							type = "select",
							name = L["altzctrlztype3"],
							desc = L["ALTZCTRLZTYPE3_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						shiftzaltztype3 = {
							order = 6,
							type = "select",
							name = L["shiftzaltztype3"],
							desc = L["SHIFTZALTZTYPE3_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
--[[ 						MOUSEWHEELUP = {
							order = 6,
							type = "select",
							name = L["MOUSE WHEEL UP"],
							values = {
								["NONE"] = L["None"],
							},
						},
						MOUSEWHEELDOWN = {
							order = 7,
							type = "select",
							name = L["MOUSE WHEEL DOWN"],
							values = {
								["NONE"] = L["None"],
							},
						}, ]]						
					},
				},
				MouseButton4 = {
					order = 7,
					type = "group",
					name = L["MouseButton4"],
					disabled = function() return not E.db.clickset.enable end,	
					args = {				
						shiftztype4 = {
							order = 1,
							type = "select",
							name = L["shiftztype4"],
							desc = L["SHIFTZTYPE4_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						ctrlztype4 = {
							order = 2,
							type = "select",
							name = L["ctrlztype4"],
							desc = L["CTRLZTYPE4_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						altztype4 = {
							order = 3,
							type = "select",
							name = L["altztype4"],
							desc = L["ALTZTYPE4_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						altzctrlztype4 = {
							order = 4,
							type = "select",
							name = L["altzctrlztype4"],
							desc = L["ALTZCTRLZTYPE4_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},				
						type4 = {
							order = 5,
							type = "select",
							name = L["type4"],
							desc = L["TYPE4_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
					},
				},
				MouseButton5 = {
					order = 8,
					type = "group",
					name = L["MouseButton5"],
					disabled = function() return not E.db.clickset.enable end,	
					args = {				
						shiftztype5 = {
							order = 1,
							type = "select",
							name = L["shiftztype5"],
							desc = L["SHIFTZTYPE5_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						ctrlztype5 = {
							order = 2,
							type = "select",
							name = L["ctrlztype5"],
							desc = L["CTRLZTYPE5_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						altztype5 = {
							order = 3,
							type = "select",
							name = L["altztype5"],
							desc = L["ALTZTYPE5_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						altzctrlztype5 = {
							order = 4,
							type = "select",
							name = L["altzctrlztype5"],
							desc = L["ALTZCTRLZTYPE5_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},
						type5 = {
							order = 5,
							type = "select",
							name = L["type5"],
							desc = L["TYPE5_DESC"],
							values = {
								["NONE"] = L["None"],
							},
						},				
					},
				},
			},
		},
			
		CustomClickSetSpell = {
			order = 30,
			type = "group",
			name = L["CustomClickSetSpell"],
			guiInline = true,
			disabled = function() return not E.db.clickset.enable end,
			args = {
				NewName = {
					type = "input",
					name = L["clickset_newname"],
					desc = L["clickset_newname_desc"],
					order = 4,
					get = function(info) return "" end,
					set = function(info, value)
						if not GetSpellInfo(value) then
							print(L["clickset_newname_err1"])
							return
						end			
						E.db.clickset.clicksetlist[value] = false
						E.Options.args.clickset.args.CustomClickSetSpell.args.clicksetlist.values[value] = GetSpellInfo(value).." ("..value..") "
					end,
				},
				DeleteName = {
					type = 'input',
					name = L['clickset_deletename'],
					desc = L["clickset_deletename_desc"],
					order = 5,
					get = function(info) return "" end,
					set = function(info, value)
						if E.db.clickset.clicksetlist[value] == nil then
							print(L["clickset_deletename_err"])
							return
						end
						E.db.clickset.clicksetlist[value] = nil
						E.Options.args.clickset.args.CustomClickSetSpell.args.clicksetlist.values[value] = nil
					end,
				},		
				clicksetlist = {
					type = "multiselect",	
					order = 6,
					name = L["clicksetlist"],
					get = function(info, k) return E.db.clickset.clicksetlist[k] end,
					set = function(info, k, v)
						E.db.clickset.clicksetlist[k] = v
						if v then
							--启用技能
							for key, value in pairs(E.Options.args.clickset.args.spec1.args) do
								for key2, value2 in pairs(E.Options.args.clickset.args.spec1.args[key].args) do
									E.Options.args.clickset.args.spec1.args[key].args[key2].values[GetSpellInfo(k)] = GetSpellInfo(k)
									
								end
							end
						else
							--禁用技能
							for key, value in pairs(E.Options.args.clickset.args.spec1.args) do
								for key2, value2 in pairs(E.Options.args.clickset.args.spec1.args[key].args) do
									E.Options.args.clickset.args.spec1.args[key].args[key2].values[GetSpellInfo(k)] = nil
									
								end
							end
						end
					end,
					values = {			
					},
				},
			},
		},		
	},
}

ClickSet:LoadClassOpt()