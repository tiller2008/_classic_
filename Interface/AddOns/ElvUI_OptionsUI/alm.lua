local E, _, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local C, L = unpack(select(2, ...))
local Module = E:GetModule("ALM")

local function getSpellLink(spellID)
	if not spellID then return; end
	local name = GetSpellInfo(spellID)
	if spellID == GetInventoryItemID("player", 10) then
		return select(2, GetItemInfo(spellID))
	end
	if not name then return; end
	
	if type(spellID) == 'string' then spellID = tonumber(spellID) end
	
	if GetSpellLink(spellID) then
		return GetSpellLink(spellID)
	else
		return string.format("|cff71d5ff|Hspell:%d|h[%s]|h|r", spellID, name)
	end
end

local function GetList(p, t)
	local spec = Module:GetSpecID()
	
	if t == 'useList' then
		local table1 = {}
		if Module.db[p][t][spec] then
			for k, v in pairs(Module.db[p][t][spec]) do
				table1[k] = getSpellLink(k);
			end
		end
		return table1
	else
		local table1 = {}
		if Module.db[p][t] then
			local num = 1
			for k, v in pairs(Module.db[p][t]) do
				table1[k] = getSpellLink(k);
				num = num + 1
				if num > E.db.ALM.maxCacheNum and t == 'cacheList' then break; end
			end
		end
		return table1
	end	
end

local function DelSpell(p, k)
	E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.detala = nil
	
	E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.detala = {
		order = 2,
		type = 'group',
		guiInline = true,
		name = L['Detailed settings'],
		args = {
			SpellID = {
				order = 1,
				name = getSpellLink(k),
				type = "description",
			},
			enable = {
				order = 2,
				type = 'toggle',
				name = L['enable'],
				get = function(info) return Module.db[p].whiteList[tonumber(k)] end,
				set = function(info, value)
					Module.db[p].whiteList[tonumber(k)] = value;
					E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.whiteList.values = GetList(p, 'whiteList')
				end,
			},			
			DeleteSpell = {
				order = 3,
				type = 'execute',
				name = L['Delete Spell'],
				func = function()
					if Module.db[p].whiteList then
						Module.db[p].whiteList[tonumber(k)] = nil;
						Module.db[p].cacheList[tonumber(k)] = true;
					end
					E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.whiteList.values = GetList(p, 'whiteList');
					E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.cacheList.values = GetList(p, 'cacheList');
					E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.detala = nil
				end,
			},
		},
	}
end

local function ADSpell(p, k)
	E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.detal = nil
	
	E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.detal = {
		order = 4,
		type = 'group',
		guiInline = true,
		name = L['Detailed settings'],
		args = {
			SpellID = {
				order = 1,
				name = getSpellLink(k),
				type = "description",
			},
			AddSpell = {
				order = 3,
				type = 'execute',
				name = L['Add Spell'],
				func = function()
					if Module.db[p].whiteList then
						Module.db[p].whiteList[tonumber(k)] = true;
						Module.db[p].cacheList[tonumber(k)] = nil;
					end
					E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.whiteList.values = GetList(p, 'whiteList');
					E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.cacheList.values = GetList(p, 'cacheList');
					E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.detal = nil
				end,
			},
			DeleteSpell = {
				order = 4,
				type = 'execute',
				name = L['Delete Spell'],
				func = function()
					if Module.db[p].whiteList then
						Module.db[p].whiteList[tonumber(k)] = nil;
						Module.db[p].cacheList[tonumber(k)] = true;
					end
					E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.whiteList.values = GetList(p, 'whiteList');
					E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.cacheList.values = GetList(p, 'cacheList');
					E.Options.args.Watch.args.ALM.args[p].args.WhiteList.args.detal = nil
				end,
			},
		},
	}
end

local function UpdateSpellInfo(p, k)
	local spec = Module:GetSpecID()
	
	E.Options.args.Watch.args.ALM.args[p].args.UseList.args.detal = nil
	
	E.Options.args.Watch.args.ALM.args[p].args.UseList.args.detal = {
		order = 2,
		type = 'group',
		guiInline = true,
		name = L['Detailed settings'],
		get = function(info) return Module.db[p].useList[spec][tonumber(k)][ info[#info] ] end,
		set = function(info, value) Module.db[p].useList[spec][tonumber(k)][ info[#info] ] = value; end,		
		args = {
			SpellID = {
				order = 1,
				name = getSpellLink(k),
				type = "description",
			},
			enable = {
				order = 2,
				type = 'toggle',
				name = L['enable'],
				get = function(info) return Module.db[p].useList[spec][tonumber(k)].enable end,
				set = function(info, value)
					Module.db[p].useList[spec][tonumber(k)].enable = value;
					E.Options.args.Watch.args.ALM.args[p].args.UseList.args.useList.values = GetList(p, 'useList')
				end,
			},
			count = {
				order = 3,
				name = L['count'],
				type = 'range',
				min = 0, max = 20, step = 1,
			},
			caster = {
				order = 4,
				name = L['caster'],
				type = 'select',
				values = {
					['player'] = L['player'],
					['target'] = L['target'],
					['focus'] = L['focus'],
					['any'] = L['Any'],
				},
			},
		},
	}
end	

local function GetTalentName(spec)
	if spec == 0 then
		return TALENT.. ': '.. E.ValColor.. L['no talent'].. '|r';
	else
		return TALENT.. ': '.. E.ValColor.. select(2, GetSpecializationInfoByID(spec)).. '|r';
	end
end

function Module:GenerateOptions()
	local spec = Module:GetSpecID();
	
	Module.pb, Module.pd, Module.tb, Module.td = '','','','';
	E.Options.args.Watch.args.ALM = {
		type = "group", 
		name = '06.'..E.ValColor..L["ALM"].."|r",
		order = 2,
		args = {
			intro = {
				order = 0,
				type = "description",
				name = L["Auto learning monitor"],
				width = "full",		
			},		
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function() return E.db.ALM.enable end,
				set = function(info, value)
					E.db.ALM.enable = value;
					Module:Toggle();
				end
			},	
			CloseOtherModule = {
				type = 'execute',
				order = 2,
				name = L['close other module'],
				desc = L['close other module desc'],
				func = function()
					E.db.unitframe.units.player.aurabar.enable = false
					E.db.unitframe.units.target.aurabar.enable = false
					E.db.unitframe.units.player.buffs.enable = false
					E.db.unitframe.units.player.debuffs.enable = false
					E.db.unitframe.units.target.buffs.enable = false
					E.db.unitframe.units.target.debuffs.enable = false						
					E:GetModule('UnitFrames'):CreateAndUpdateUF('player')
					E:GetModule('UnitFrames'):CreateAndUpdateUF('target')
					if E.private.AuraWatch.enable then
						E.private.AuraWatch.enable = false;				
						E:StaticPopup_Show("CONFIG_RL");
					end
					if E.private.SoraClassTimer.enable then
						E.private.SoraClassTimer.enable = false;
						E:StaticPopup_Show("CONFIG_RL");
					end
				end,
			},
			Default = {
				type = "execute",
				order = 3,
				name = L["Defaults"],
				disabled = function() return not E.db.ALM.enable end,
				func = function() wipe(E.db.ALM); E:CopyTable(E.db.ALM, P.ALM); E:StaticPopup_Show("CONFIG_RL"); end,
			},
			learning = {
				type = "toggle",
				order = 4,
				name = L['learning'],
				set = function(info, value) E.db.ALM.learning = value; Module:Toggle() end,
				get = function() return E.db.ALM.learning end,
			},
			tooltip = {
				order = 5,
				type = "toggle",
				name = L['Tooltip'],
				set = function(info, value) E.db.ALM.tooltip = value;E:StaticPopup_Show("CONFIG_RL"); end,
				get = function() return E.db.ALM.tooltip end,			
			},	
			maxCacheNum = {
				order = 6,
				type = 'range',
				name = L['maxCacheNum'],
				min = 10, max = 100, step = 1,
				set = function(info,value) E.db.ALM.maxCacheNum = value; end,
				get = function() return E.db.ALM.maxCacheNum end,
			},
			fontGroup = {
				order = 10,
				type = 'group',
				guiInline = true,
				name = L['Fonts'],
				get = function(info) return E.db.ALM[ info[#info] ] end,
				set = function(info, value) E.db.ALM[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,			
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
							['NONE'] = L["None"],
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROME'] = 'MONOCHROME',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE'
						},
					},	
				},
			},				
			playerBuff = {
				order = 20,
				type = 'group',
				name = L['playerBuff'],
				guiInline = false,
				disabled = function() return not E.db.ALM.enable end,
				set = function(info, value) E.db.ALM.playerBuff[ info[#info] ] = value; Module:DeleteAllFrame(); Module:BuildAura(); Module:UpdatePos(); end,
				get = function(info) return E.db.ALM.playerBuff[ info[#info] ]; end,
				args = {
					enable = {
						order = 0,
						type = "toggle",
						name = L["Enable"],
					},
					iconSize = {
						order = 1,
						type = 'range',
						min = 1, max = 100, step = 1,
						name = L['iconSize'],
					},
					x_direction = {
						order = 2,
						type = 'select',
						name = L['x-direction'],
						values = {
							['LEFT'] = L['LEFT'],
							['RIGHT'] = L['RIGHT'],
						},
					},
					y_direction = {
						order = 3,
						type = 'select',
						name = L['y-direction'],
						values = {
							['UP'] = L['UP'],
							['DOWN'] = L['DOWN'],
						},
					},
					interval = {
						order = 4,
						type = 'range',
						name = L['interval'],
						min = 1, max = 20, step = 1,
					},
					perRow = {
						order = 5,
						type = 'range',
						name = L['perRow'],
						min = 1, max = 50, step = 1,
					},
					maxNum = {
						order = 6,
						type = 'range',
						name = L['maxNum'],
						min = 1, max = 50, step = 1,
					},					
					Default = {
						type = "execute",
						order = 8,
						name = L["Defaults"],
						disabled = function() return not E.db.ALM.playerBuff.enable end,
						func = function() wipe(E.db.ALM.playerBuff); E:CopyTable(E.db.ALM.playerBuff, P.ALM.playerBuff); E:StaticPopup_Show("CONFIG_RL"); end,
					},
					UseList = {
						order = 10,
						type = 'group',
						name = L['useList'],
						guiInline = true,
						args = {
							talent = {
								order = 0,
								name = GetTalentName(spec),
								type = "description",
							},	
							useList = {
								order = 1,
								type = 'multiselect',
								name = L['useList'],
								desc = L['userList desc'],
								get = function(info, k) return Module.db.playerBuff.useList[spec][k].enable end,
								set = function(info, k, v) UpdateSpellInfo('playerBuff', k) end,
								values = GetList('playerBuff', 'useList'),
							},
						},
					},
					WhiteList = {
						order = 11,
						type = 'group',
						name = L['WhiteList'],
						guiInline = true,
						args = {
							whiteList = {
								order = 1,
								type = 'multiselect',
								name = L['WhiteList'],
								desc = L['WhiteList desc'],
								get = function(info, k) return Module.db.playerBuff.whiteList[k] end,
								set = function(info, k, v) DelSpell('playerBuff', k); end,
								values = GetList('playerBuff', 'whiteList'),
							},					
							cacheList = {
								order = 3,
								type = 'multiselect',
								name = L['cacheList'],
								desc = L['cacheList desc'],
								set = function(info, k, v) ADSpell('playerBuff', k); end,
								get = function(info, k) return Module.db.playerBuff.cacheList[k] end,
								values = GetList('playerBuff', 'cacheList'),
							},
						},
					},
				},
			},
			playerDebuff = {
				order = 30,
				type = 'group',
				name = L['playerDebuff'],
				guiInline = false,
				disabled = function() return not E.db.ALM.enable end,
				set = function(info, value) E.db.ALM.playerDebuff[ info[#info] ] = value; Module:DeleteAllFrame(); Module:BuildAura(); Module:UpdatePos(); end,
				get = function(info) return E.db.ALM.playerDebuff[ info[#info] ]; end,
				args = {
					enable = {
						order = 0,
						type = "toggle",
						name = L["Enable"],
					},
					iconSize = {
						order = 1,
						type = 'range',
						min = 1, max = 100, step = 1,
						name = L['iconSize'],
					},
					x_direction = {
						order = 2,
						type = 'select',
						name = L['x-direction'],
						values = {
							['LEFT'] = L['LEFT'],
							['RIGHT'] = L['RIGHT'],
						},
					},
					y_direction = {
						order = 3,
						type = 'select',
						name = L['y-direction'],
						values = {
							['UP'] = L['UP'],
							['DOWN'] = L['DOWN'],
						},
					},
					interval = {
						order = 4,
						type = 'range',
						name = L['interval'],
						min = 1, max = 20, step = 1,
					},
					perRow = {
						order = 5,
						type = 'range',
						name = L['perRow'],
						min = 1, max = 50, step = 1,
					},
					maxNum = {
						order = 6,
						type = 'range',
						name = L['maxNum'],
						min = 1, max = 50, step = 1,
					},
					Default = {
						type = "execute",
						order = 7,
						name = L["Defaults"],
						disabled = function() return not E.db.ALM.playerDebuff.enable end,
						func = function() wipe(E.db.ALM.playerDebuff); E:CopyTable(E.db.ALM.playerDebuff, P.ALM.playerDebuff); E:StaticPopup_Show("CONFIG_RL"); end,
					},					
					UseList = {
						order = 10,
						type = 'group',
						name = L['useList'],
						guiInline = true,
						args = {
							talent = {
								order = 0,
								name = GetTalentName(spec),
								type = "description",
							},							
							useList = {
								order = 1,
								type = 'multiselect',
								name = L['useList'],
								desc = L['userList desc'],
								get = function(info, k) return Module.db.playerDebuff.useList[spec][k].enable end,
								set = function(info, k, v) UpdateSpellInfo('playerDebuff', k) end,
								values = GetList('playerDebuff', 'useList'),
							},
						},
					},
					WhiteList = {
						order = 11,
						type = 'group',
						name = L['WhiteList'],
						guiInline = true,
						args = {
							whiteList = {
								order = 1,
								type = 'multiselect',
								name = L['WhiteList'],
								desc = L['WhiteList desc'],
								get = function(info, k) return Module.db.playerDebuff.whiteList[k] end,
								set = function(info, k, v) DelSpell('playerDebuff', k); end,
								values = GetList('playerDebuff', 'whiteList'),
							},					
							cacheList = {
								order = 3,
								type = 'multiselect',
								name = L['cacheList'],
								desc = L['cacheList desc'],
								set = function(info, k, v) ADSpell('playerDebuff', k); end,
								get = function(info, k) return Module.db.playerDebuff.cacheList[k] end,
								values = GetList('playerDebuff', 'cacheList'),
							},
						},
					},
				},
			},
			targetBuff = {
				order = 40,
				type = 'group',
				name = L['targetBuff'],
				guiInline = false,
				disabled = function() return not E.db.ALM.enable end,
				set = function(info, value) E.db.ALM.targetBuff[ info[#info] ] = value; Module:DeleteAllFrame(); Module:BuildAura(); Module:UpdatePos(); end,
				get = function(info) return E.db.ALM.targetBuff[ info[#info] ]; end,
				args = {
					enable = {
						order = 0,
						type = "toggle",
						name = L["Enable"],
					},
					iconSize = {
						order = 1,
						type = 'range',
						min = 1, max = 100, step = 1,
						name = L['iconSize'],
					},
					x_direction = {
						order = 2,
						type = 'select',
						name = L['x-direction'],
						values = {
							['LEFT'] = L['LEFT'],
							['RIGHT'] = L['RIGHT'],
						},
					},
					y_direction = {
						order = 3,
						type = 'select',
						name = L['y-direction'],
						values = {
							['UP'] = L['UP'],
							['DOWN'] = L['DOWN'],
						},
					},
					interval = {
						order = 4,
						type = 'range',
						name = L['interval'],
						min = 1, max = 20, step = 1,
					},
					perRow = {
						order = 5,
						type = 'range',
						name = L['perRow'],
						min = 1, max = 50, step = 1,
					},
					maxNum = {
						order = 6,
						type = 'range',
						name = L['maxNum'],
						min = 1, max = 50, step = 1,
					},
					Default = {
						type = "execute",
						order = 7,
						name = L["Defaults"],
						disabled = function() return not E.db.ALM.targetBuff.enable end,
						func = function() wipe(E.db.ALM.targetBuff); E:CopyTable(E.db.ALM.targetBuff, P.ALM.targetBuff); E:StaticPopup_Show("CONFIG_RL"); end,
					},					
					UseList = {
						order = 10,
						type = 'group',
						name = L['useList'],
						guiInline = true,
						args = {
							talent = {
								order = 0,
								name = GetTalentName(spec),
								type = "description",
							},						
							useList = {
								order = 1,
								type = 'multiselect',
								name = L['useList'],
								desc = L['userList desc'],
								get = function(info, k) return Module.db.targetBuff.useList[spec][k].enable end,
								set = function(info, k, v) UpdateSpellInfo('targetBuff', k) end,
								values = GetList('targetBuff', 'useList'),
							},
						},
					},
					WhiteList = {
						order = 11,
						type = 'group',
						name = L['WhiteList'],
						guiInline = true,
						args = {
							whiteList = {
								order = 1,
								type = 'multiselect',
								name = L['WhiteList'],
								desc = L['WhiteList desc'],
								get = function(info, k) return Module.db.targetBuff.whiteList[k] end,
								set = function(info, k, v) DelSpell('targetBuff', k); end,
								values = GetList('targetBuff', 'whiteList'),
							},					
							cacheList = {
								order = 3,
								type = 'multiselect',
								name = L['cacheList'],
								desc = L['cacheList desc'],
								set = function(info, k, v) ADSpell('targetBuff', k); end,
								get = function(info, k) return Module.db.targetBuff.cacheList[k] end,
								values = GetList('targetBuff', 'cacheList'),
							},
						},
					},
				},
			},
			targetDebuff = {
				order = 50,
				type = 'group',
				name = L['targetDebuff'],
				guiInline = false,
				disabled = function() return not E.db.ALM.enable end,
				set = function(info, value) E.db.ALM.targetDebuff[ info[#info] ] = value; Module:DeleteAllFrame(); Module:BuildAura(); Module:UpdatePos(); end,
				get = function(info) return E.db.ALM.targetDebuff[ info[#info] ]; end,
				args = {
					enable = {
						order = 0,
						type = "toggle",
						name = L["Enable"],
					},
					iconSize = {
						order = 1,
						type = 'range',
						min = 1, max = 100, step = 1,
						name = L['iconSize'],
					},
					x_direction = {
						order = 2,
						type = 'select',
						name = L['x-direction'],
						values = {
							['LEFT'] = L['LEFT'],
							['RIGHT'] = L['RIGHT'],
						},
					},
					y_direction = {
						order = 3,
						type = 'select',
						name = L['y-direction'],
						values = {
							['UP'] = L['UP'],
							['DOWN'] = L['DOWN'],
						},
					},
					interval = {
						order = 4,
						type = 'range',
						name = L['interval'],
						min = 1, max = 20, step = 1,
					},
					perRow = {
						order = 5,
						type = 'range',
						name = L['perRow'],
						min = 1, max = 50, step = 1,
					},
					maxNum = {
						order = 6,
						type = 'range',
						name = L['maxNum'],
						min = 1, max = 50, step = 1,
					},
					Default = {
						type = "execute",
						order = 7,
						name = L["Defaults"],
						disabled = function() return not E.db.ALM.targetDebuff.enable end,
						func = function() wipe(E.db.ALM.targetDebuff); E:CopyTable(E.db.ALM.targetDebuff, P.ALM.targetDebuff); E:StaticPopup_Show("CONFIG_RL"); end,
					},						
					UseList = {
						order = 10,
						type = 'group',
						name = L['useList'],
						guiInline = true,
						args = {
							talent = {
								order = 0,
								name = GetTalentName(spec),
								type = "description",
							},						
							useList = {
								order = 1,
								type = 'multiselect',
								name = L['useList'],
								desc = L['userList desc'],
								get = function(info, k) return Module.db.targetDebuff.useList[spec][k].enable end,
								set = function(info, k, v) UpdateSpellInfo('targetDebuff', k) end,
								values = GetList('targetDebuff', 'useList'),
							},
						},
					},
					WhiteList = {
						order = 11,
						type = 'group',
						name = L['WhiteList'],
						guiInline = true,
						args = {
							whiteList = {
								order = 1,
								type = 'multiselect',
								name = L['WhiteList'],
								desc = L['WhiteList desc'],
								get = function(info, k) return Module.db.targetDebuff.whiteList[k] end,
								set = function(info, k, v) DelSpell('targetDebuff', k); end,
								values = GetList('targetDebuff', 'whiteList'),
							},					
							cacheList = {
								order = 3,
								type = 'multiselect',
								name = L['cacheList'],
								desc = L['cacheList desc'],
								set = function(info, k, v) ADSpell('targetDebuff', k); end,
								get = function(info, k) return Module.db.targetDebuff.cacheList[k] end,
								values = GetList('targetDebuff', 'cacheList'),
							},
						},
					},
				},
			},
			spellCD = {
				order = 60,
				type = 'group',
				name = L['spellCD'],
				guiInline = false,
				disabled = function() return not E.db.ALM.enable end,
				set = function(info, value) E.db.ALM.spellCD[ info[#info] ] = value; Module:DeleteAllFrame(); Module:BuildAura(); Module:UpdatePos(); end,
				get = function(info) return E.db.ALM.spellCD[ info[#info] ]; end,
				args = {
					enable = {
						order = 0,
						type = "toggle",
						name = L["Enable"],
						set = function(info, value) E.db.ALM.spellCD.enable = value; Module:Toggle(); end,
					},
					iconSize = {
						order = 1,
						type = 'range',
						min = 1, max = 100, step = 1,
						name = L['iconSize'],
					},
					x_direction = {
						order = 2,
						type = 'select',
						name = L['x-direction'],
						values = {
							['LEFT'] = L['LEFT'],
							['RIGHT'] = L['RIGHT'],
						},
					},
					y_direction = {
						order = 3,
						type = 'select',
						name = L['y-direction'],
						values = {
							['UP'] = L['UP'],
							['DOWN'] = L['DOWN'],
						},
					},
					interval = {
						order = 4,
						type = 'range',
						name = L['interval'],
						min = 1, max = 20, step = 1,
					},
					perRow = {
						order = 5,
						type = 'range',
						name = L['perRow'],
						min = 1, max = 50, step = 1,
					},
					maxNum = {
						order = 6,
						type = 'range',
						name = L['maxNum'],
						min = 1, max = 50, step = 1,
					},
					alwaysShow = {
						order = 7,
						type = 'toggle',
						name = L['Always Display'],
						set = function(info, value) E.db.ALM.spellCD.alwaysShow = value; Module:Toggle(); end,
					},
					combat = {
						order = 8,
						type = 'toggle',
						name = L["Combat only"],
						disabled = function() return not E.db.ALM.spellCD.alwaysShow; end,
						set = function(info, value) E.db.ALM.spellCD.combat = value; Module:Toggle(); end,
					},
					Default = {
						type = "execute",
						order = 9,
						name = L["Defaults"],
						disabled = function() return not E.db.ALM.spellCD.enable end,
						func = function() wipe(E.db.ALM.spellCD); E:CopyTable(E.db.ALM.spellCD, P.ALM.spellCD); E:StaticPopup_Show("CONFIG_RL"); end,
					},
					talent = {
						order = 10,
						name = GetTalentName(spec),
						type = "description",
					},	
					SpellID = {
						order = 11,
						name = L['Add SpellID'],
						type = 'input',
					},
					AddSpellToList = {
						order = 12,
						type = 'execute',
						name = L['Add SpellID'],
						func = function() 
							if E.db.ALM.spellCD.SpellID and tonumber(E.db.ALM.spellCD.SpellID) and GetSpellInfo(tonumber(E.db.ALM.spellCD.SpellID)) then
								Module.db.spellCD.useList[spec][tonumber(E.db.ALM.spellCD.SpellID)] = true;
								E.Options.args.Watch.args.ALM.args.spellCD.args.useList.values = GetList('spellCD', 'useList');
								E.db.ALM.spellCD.SpellID = nil
							end
						end,
					},
					DelSpellFromList = {
						order = 13,
						type = 'execute',
						name = L['Remove SpellID'],
						func = function()
							if E.db.ALM.spellCD.SpellID and GetSpellInfo(tonumber(E.db.ALM.spellCD.SpellID)) then
								Module.db.spellCD.useList[spec][tonumber(E.db.ALM.spellCD.SpellID)] = nil;
								E.Options.args.Watch.args.ALM.args.spellCD.args.useList.values = GetList('spellCD', 'useList');
								E.db.ALM.spellCD.SpellID = nil
							end
						end,
					},								
					useList = {
						order = 20,
						type = 'multiselect',
						name = L['useList'],
						get = function(info, k) return Module.db.spellCD.useList[spec][k] end,
						set = function(info, k, v) Module.db.spellCD.useList[spec][k] = v end,
						values = GetList('spellCD', 'useList'),
					},
				},
			},			
		},
	}
end

Module:GenerateOptions()