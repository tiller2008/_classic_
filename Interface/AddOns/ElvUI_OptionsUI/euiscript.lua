local E, _, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local C, L = unpack(select(2, ...))
local class = select(2, UnitClass("player"));
local format = string.format
if not IsAddOnLoaded('EuiScript') then return; end

local GetSpellInfo = GetSpellInfo
local selectedSpell;
local selectedItemid;
local adItemid;
local function UpdateRaidCD_Spell()
	E.Options.args.euiscript.args.euiscript_raidcd.args.filterGroup = {
		type = 'group',
		name = SPELLS,
		guiInline = true,
		order = 10,
		args = {
			addSpell = {
				order = 1,
				name = L['Add Spell'].. 'ID',
				type = 'input',
				get = function(info) return "" end,
				set = function(info, value) 
					if not GetSpellInfo(value) then
						E:Print(L["Not valid spell id"]);
						return;
					end
					if not E.db.euiscript.raid_spells[value] then
						E.db.euiscript.raid_spells[value] = { 
							['enable'] = true,
							['cd'] = 30,
							['cc'] = false,
						}
					end
					UpdateRaidCD_Spell();
				end,					
			},
			removeSpell = {
				order = 1,
				name = L['Remove Spell'].. 'ID',
				type = 'input',
				get = function(info) return "" end,
				set = function(info, value) 
					if P['euiscript']['raid_spells'][value] then
						E.db.euiscript.raid_spells[value].enable = false;
						E:Print(L['You may not remove a spell from a default filter that is not customly added. Setting spell to false instead.'])
					else
						E.db.euiscript.raid_spells[value] = nil;
					end
					UpdateRaidCD_Spell();
				end,				
			},		
			selectSpell = {
				name = L["Select Spell"],
				type = 'select',
				order = -9,
				get = function(info) return selectedSpell end,
				set = function(info, value) selectedSpell = value; UpdateRaidCD_Spell() end,							
				values = function()
					local filters = {}
					filters[''] = NONE
					for filter in pairs(E.db.euiscript.raid_spells) do
						if GetSpellInfo(tonumber(filter)) then
							filters[filter] = GetSpellInfo(tonumber(filter))..'('..filter..')';
						end
					end

					return filters
				end,
			},			
		},	
	}

	if not selectedSpell or not E.db.euiscript.raid_spells[selectedSpell] then
		E.Options.args.euiscript.args.euiscript_raidcd.args.spellGroup = nil
		return
	end
	
	E.Options.args.euiscript.args.euiscript_raidcd.args.spellGroup = {
		type = "group",
		name = GetSpellInfo(tonumber(selectedSpell))..'('..selectedSpell..')',
		order = 15,
		guiInline = true,
		args = {
			enable = {
				name = L["Enable"],
				type = "toggle",
				get = function() 
					if not selectedSpell then
						return false
					else
						return E.db.euiscript.raid_spells[selectedSpell].enable
					end
				end,
				set = function(info, value) E.db.euiscript.raid_spells[selectedSpell].enable = value; UpdateRaidCD_Spell(); end
			},
			cd = {
				name = L["CD"],
				type = "range",
				get = function() 
					if not selectedSpell then
						return 5
					else
						return E.db.euiscript.raid_spells[selectedSpell].cd
					end
				end,
				set = function(info, value) E.db.euiscript.raid_spells[selectedSpell].cd = value; UpdateRaidCD_Spell(); end,
				min = 5, max = 1800, step = 1,
			},	
			cc = {
				name = L["CC Spell"],
				type = "toggle",
				get = function()
					if not selectedSpell then
						return false
					else
						return E.db.euiscript.raid_spells[selectedSpell].cc
					end
				end,
				set = function(info, value) E.db.euiscript.raid_spells[selectedSpell].cc = value; UpdateRaidCD_Spell(); end,
			},				
		},
	}
end

local function UpdateAutobuyGroup()
	if not selectedItemid then
		E.Options.args.euiscript.args.euiscript_autobuy.args.itemidGroup = nil;
		return;
	end
	
	E.Options.args.euiscript.args.euiscript_autobuy.args.itemidGroup = {
		type = 'group',
		name = GetItemInfo(selectedItemid)..'('..selectedItemid..')',
		guiInline = true,
		order = 10,
		args = {
			number = {
				order = 1,
				type = 'range',
				name = L['Item Count'],
				min = 0, max = 200, step = 1,
				get = function(info) return E.db.euiscript.autobuylist[selectedItemid]; end,
				set = function(info, value) E.db.euiscript.autobuylist[selectedItemid] = tonumber(value); end,
			},
		},
	}
end		

local class_table = {
--	['ANY'] = L["Any"],
	['DRUID'] = L['DRUID'],
	['HUNTER'] = L['HUNTER'],
	['MAGE'] = L['MAGE'],
	['WARLOCK'] = L['WARLOCK'],
	['SHAMAN'] = L['SHAMAN'],
	['PALADIN'] = L['PALADIN'],
	['PRIEST'] = L['PRIEST'],
	['WARRIOR'] = L['WARRIOR'],
	['ROGUE'] = L['ROGUE'],
	['DEATHKNIGHT'] = L['DEATHKNIGHT'],
	['MONK'] = L['MONK'],
}

local function GetSpecIdTable(class)
	local temptable = {}

	if not class or class == '' then return temptable; end
	
	local class_specidx_table = {
		['DRUID'] = {102,103,104,105},
		['HUNTER'] = {253,254,255},
		['MAGE'] = {62,63,64},
		['WARLOCK'] = {265,266,267},
		['SHAMAN'] = {262,263,264},
		['PALADIN'] = {65,66,67},
		['PRIEST'] = {256,257,258},
		['WARRIOR'] = {71,72,73},
		['ROGUE'] = {259,260,261},
		['DEATHKNIGHT'] = {250,251,252},
		['MONK'] = {268,269,270},
	}

	for i = 1, #class_specidx_table[class] do
		local specidx = class_specidx_table[class][i]
		temptable[specidx] = select(2, GetSpecializationInfoByID(specidx))
	end
	temptable[0] = NONE
	
	return temptable
end	

local function RLBox_Addspell()
	local spellID = '';
	local class = ''
	local allic = ''
	local enable = true
	local specidx, specid, cooldown = 0, 0, 0
	--GetTalentInfo (tier, col)
	
	if E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.spellgroup then wipe(E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.spellgroup); end
		
	E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.spellgroup = {
		type = "group",
		name = spellID,
		order = 15,
		guiInline = true,
		args = {
			spellid = {
				order = 1,
				name = L["Spell ID"],
				type = 'input',
				get = function(info) return tostring(spellID) end,
				set = function(info, value) 
					if not tonumber(value) then
						E:Print(L["Value must be a number"])
					elseif not GetSpellInfo(value) then
						E:Print(L["Not valid spell id"])
					else
						spellID = tonumber(value);
						cooldown = E.global.RLBox.SPELL_MONITOR_SCHEMA.cooldowns[spellID]
						for reqSpellId, reqs in pairs(E.global.RLBox.SPELL_MONITOR_SCHEMA.requirements) do
							if reqSpellId == spellID then
								for reqindex, req in pairs(reqs) do
									specid = req.specialization
									specidx = req.talentIndex
								end
							end
						end
						E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.spellgroup.name = E.ValColor..GetSpellInfo(spellID)..'('..spellID..')|r';
					end
				end,
			},
			class_en = {
				order = 2,
				name = CLASS,
				type = 'select',
				get = function() return class end,
				set = function(info, value)
					class = value;
					E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.spellgroup.args.spec.values = GetSpecIdTable(class);
				end,
				values = class_table,
			},
			alliance = {
				order = 3,
				name = L["faction"],
				type = 'select',
				get = function() return allic end,
				set = function(info, value) allic = value; end,
				values = {
					['Horde'] = L['Horde'],
					['Alliance'] = L['Alliance'],
					['NONE'] = L["Any"],
				},
			},
			cooldowns = {
				order = 4,
				name = L["Cooldown"],
				type = 'range',
				min = 1, max = 600, step = 1,
				get = function() return cooldown end,
				set = function(info, value) cooldown = value; end,
			},
			spec = {
				order = 5,
				name = L["Talent Tree"],
				type = 'select',
				get = function() return specid or 0 end,
				set = function(info, value) if value == 0 then specid = nil; else specid = value; end; end,
				disabled = function() return not class or class == 'ANY'; end,
				values = GetSpecIdTable(class),
			},
			specidx = {
				order = 6,
				name = L["Talent id"],
				desc = L["Talent id desc"],
				type = 'range',
				min = 0, max = 999999, step = 1,
				get = function() return specidx or 0 end,
				set = function(info, value) if value == 0 then specidx = nil; else specidx = value; end; end,
				disabled = function() return not class or class == 'ANY'; end,
			},
			enabled = {
				order = 7,
				name = L["Enable"],
				type = 'toggle',
				get = function() return enable end,
				set = function(info, value) enable = value; end,
			},
			addSpell = {
				order = 10,
				name = L['Add Spell'],
				type = 'execute',
				disabled = function() return not GetSpellInfo(spellID) end,
				func = function()
					if cooldown == 0 or class == '' or spellid == '' then return; end
					if not E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.selectSpell.values()[spellID] then
						tinsert(E.global.RLBox.MISC_SPELLS, {class, spellID, enable, allic, cooldown, specid, specidx});
						E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.selectSpell.values()[spellID] = GetSpellInfo(spellID)..'('..spellID..')';
						E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.spellgroup = nil
					else
						E:Print(spellID..L["already exists."]);
					end
				end,
			},
		},
	}			
end
local function RLBox_RemoveSpell()
	local spellID = '';
	if E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.spellgroup then wipe(E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.spellgroup); end
	
	E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.spellgroup = {
		type = "group",
		name = spellID,
		order = 15,
		guiInline = true,
		args = {	
			spellid = {
				order = 1,
				name = L["Spell ID"],
				type = 'input',
				get = function(info) return tostring(spellID) end,
				set = function(info, value) 
					if not tonumber(value) then
						E:Print(L["Value must be a number"])
					elseif not GetSpellInfo(value) then
						E:Print(L["Not valid spell id"])
					else
						spellID = tonumber(value);
						E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.spellgroup.name = E.ValColor..GetSpellInfo(spellID)..'('..spellID..')|r';
					end
				end,
			},	
			removeSpell = {
				order = 2,
				name = L['Remove Spell'],
				type = 'execute',
				disabled = function() return not GetSpellInfo(spellID) end,
				func = function()
					for i = 1, #G.RLBox.MISC_SPELLS do
						if G.RLBox.MISC_SPELLS[i][2] == spellID then
							E:Print(L['You may not remove a spell from a default filter that is not customly added. Setting spell to false instead.'])
							return;
						end
					end
					if not E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.selectSpell.values()[spellID] then
						E:Print(L["spell not exists, id:"]..spellID);
					else
						for i = 1, #E.global.RLBox.MISC_SPELLS do
							if E.global.RLBox.MISC_SPELLS[i][2] == spellID then
								tremove(E.global.RLBox.MISC_SPELLS, i)
								break;
							end
						end
						E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.selectSpell.values()[spellID] = nil;
						E.Options.args.euiscript.args.rlbox.args.MISC_SPELLS_GROUP.args.spellgroup = nil
					end
				end,
			},
		},
	}
end

local function RLBox_EditSpell(spellID, tab, opt, toggle)
	if not toggle then return; end
	
	local class = ''
	local allic = ''
	local enable = true
	local specidx, specid, cooldown = 0, 0, 0
	
	for i = 1, #tab do
		if tab[i][2] == spellID then
			class = tab[i][1]
			allic = tab[i][4]
			enable = tab[i][3]
			cooldown = tab[i][5]
			specid = tab[i][6]
			specidx = tab[i][7]
			break;
		end
	end
	
	cooldown = cooldown or E.global.RLBox.SPELL_MONITOR_SCHEMA.cooldowns[spellID]
	for reqSpellId, reqs in pairs(E.global.RLBox.SPELL_MONITOR_SCHEMA.requirements) do
		if reqSpellId == spellID then
			for reqindex, req in pairs(reqs) do
				specid = specid or req.specialization
				specidx = specidx or req.talentIndex
			end
		end
	end
	
	if E.Options.args.euiscript.args.rlbox.args[opt].args.spellgroup then wipe(E.Options.args.euiscript.args.rlbox.args[opt].args.spellgroup); end
		
	E.Options.args.euiscript.args.rlbox.args[opt].args.spellgroup = {
		type = "group",
		name = E.ValColor..GetSpellInfo(spellID)..'('..spellID..')|r',
		order = 15,
		guiInline = true,
		args = {	
			class_en = {
				order = 1,
				name = CLASS,
				type = 'select',
				get = function() return class end,
				set = function(info, value) class = value; end,
				values = class_table,
			},
			alliance = {
				order = 2,
				name = L["faction"],
				type = 'select',
				get = function() if not allic then return 'NONE' else return allic; end; end,
				set = function(info, value) allic = value; end,
				values = {
					['Horde'] = L['Horde'],
					['Alliance'] = L['Alliance'],
					['NONE'] = L["Any"],
				},
			},
			cooldowns = {
				order = 4,
				name = L['Cooldown'],
				type = 'range',
				min = 1, max = 600, step = 1,
				get = function() return cooldown end,
				set = function(info, value) cooldown = value; end,
			},
			spec = {
				order = 5,
				name = L["Talent Tree"],
				type = 'select',
				get = function() return specid or 0 end,
				set = function(info, value) if value == 0 then specid = nil; else specid = value; end; end,
				disabled = function() return not class or class == 'ANY'; end,
				values = GetSpecIdTable(class),
			},
			specidx = {
				order = 6,
				name = L["Talent id"],
				desc = L["Talent id desc"],
				type = 'range',
				min = 0, max = 999999, step = 1,
				get = function() return specidx or 0 end,
				set = function(info, value) if value == 0 then specidx = nil; else specidx = value; end; end,
				disabled = function() return not class or class == 'ANY'; end,
			},			
			enabled = {
				order = 7,
				name = L["Enable"],
				type = 'toggle',
				get = function() return enable end,
				set = function(info, value) enable = value; end,
			},			
			ModifySpell = {
				order = 8,
				name = UPDATE..SPELLS,
				type = 'execute',
				disabled = function() return not GetSpellInfo(spellID) end,
				func = function()
					for i = 1, #tab do
						if tab[i][2] == spellID then
							tab[i][1] = class
							tab[i][3] = enable
							tab[i][4] = allic
							tab[i][5] = cooldown
							tab[i][6] = specid
							tab[i][7] = specidx
							E.Options.args.euiscript.args.rlbox.args[opt].args.spellgroup = nil
							break;
						end
					end
				end,
			},
		},
	}		
end

local whiteItemID, blackItemID
E.Options.args.euiscript = {
	type = "group",
	name = '15.'..L["euiscript"],
	desc = L["euiscript_desc"],
	childGroups = "tab",
	get = function(info) return E.db.euiscript[ info[#info] ] end,
	set = function(info, value) E.db.euiscript[ info[#info] ] = value end,
	args = {
		euiscript_general = {
			order = 1,
			type = "group",
			name = L["euiscript_general"],
			guiInline = false,
			get = function(info) return E.db.euiscript[ info[#info] ] end,
			set = function(info, value) E.db.euiscript[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,
			args = {
				uiGroup = {
					order = 1,
					type = 'group',
					guiInline = false,
					name = L['About UI'],
					get = function(info) return E.db.euiscript[ info[#info] ] end,
					set = function(info, value) E.db.euiscript[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,	
					args = {
						chatbar = {
							order = 1,
							type = "toggle",
							name = L["chatbar"],
						},
						statreport = {
							order = 2,
							type = "toggle",
							name = L["statreport"],
						},
						chatmod = {
							order = 3,
							type = "toggle",
							name = L["chatmod"],
						},						
						drag = {
							order = 4,
							type = "toggle",
							name = L["drag"],
						},
						castby = {
							order = 5,
							type = "toggle",
							name = L["castby"],
						},
						tradetabs = {
							order = 6,
							type = "toggle",
							name = L["tradetabs"],
						},
						sr = {
							order = 7,
							type = "toggle",
							name = L["sr"],
						},	
						gemplus = {
							order = 8,
							type = "toggle",
							name = L['GemPlus'],
						},
						autoleavebnsec = {
							order = 9,
							type = 'range',
							min = -1, max = 12,step = 1,
							name = L['automatically leave the battlefield'],
							desc = L['automatically leave the battlefield, -1 disabled'],
						},
						hovertip = {
							order = 10,
							type = "toggle",
							name = L["hovertip"],
							desc = L["HOVERTIP_DESC"],
							get = function() return GetCVarBool('alwaysCompareItems') end,
							set = function(info, value)
								E.db.euiscript.hovertip = value;
								if not value then
									SetCVar("alwaysCompareItems", "0");
								else
									SetCVar("alwaysCompareItems", "1");
								end							
							end,
						},
						dispel = {
							order = 13,
							type = "toggle",
							name = L["mousedispel"],
							desc = L["MOUSEDISPEL_DESC"],
							set = function(info, value)
								if value ~= true then
									SetBinding("MOUSEWHEELUP", "CAMERAZOOMIN");
									SetBinding("MOUSEWHEELDOWN", "CAMERAZOOMOUT");
									SaveBindings(2);
									if GetMacroInfo("EuiDebuffa") then DeleteMacro("EuiDebuffa") end
									if GetMacroInfo("EuiDebuffb") then DeleteMacro("EuiDebuffb") end
								end
								E.db["euiscript"].dispel = value;
								E:StaticPopup_Show("CONFIG_RL");
							end,
						},							
						raid_marking1 = {
							order = 14,
							type = "select",
							name = L["raid marking key"]..'1',
							values = {
								['ctrl'] = "Ctrl",
								['alt'] = "Alt",
								['shift'] = "Shift",
								['none'] = NONE,
							},
						},
						raid_marking2 = {
							order = 15,
							type = "select",
							name = L["raid marking key"]..'2',
							disabled = function() return E.db.euiscript.raid_marking1 == 'none' end,
							values = {
								["LeftButton"] = L["MouseButton1"],
								["RightButton"] = L["MouseButton2"],
							},
						},							
						bossnotes = {
							order = 16,
							type = "toggle",
							name = L["bossnotes"],
						},	
						buttonCollect = {
							order = 19,
							type = 'toggle',
							name = L['Square minimap icons'],
						},
						buttonCollectDC = {
							order = 20,
							type = 'select',
							name = L['Square minimap icons direction'],
							values = {
								['UP'] = L['UP'],
								['DOWN'] = L['DOWN'],
								['LEFT'] = L['LEFT'],
								['RIGHT'] = L['RIGHT'],
							},
						},
						camerafactor = {
							order = 21,
							type = "range",
							min = 1, max = 3.5, step = 1,
							name = L["Camera Distance MAX Factory"],
							set = function(info, value) SetCVar("cameraDistanceMaxZoomFactor", value); E.db.euiscript.camerafactor = value end,
							get = function() return E.db.euiscript.camerafactor end,
						},
						cameraspeed = {
							order = 23,
							type = "range",
							min = 1, max = 50, step = 1,
							name = L["Camera Move Speed"],
							set = function(info, value) SetCVar("cameraDistanceMoveSpeed", value); E.db.euiscript.cameraspeed = value end,
							get = function() return E.db.euiscript.cameraspeed end,
						},
						-- FriendGroups = {
							-- order = 24,
							-- type = 'toggle',
							-- name = L["FriendGroups"],
							-- set = function(info,value) E.db.euiscript.FriendGroups.enable = value; E:StaticPopup_Show("CONFIG_RL"); end,
							-- get = function(info) return E.db.euiscript.FriendGroups.enable; end,
						-- },
						csc = {
							order = 24,
							type = 'toggle',
							name = L["CharacterStatsClassic"],
							set = function(info, value) E.db.euiscript.csc = value; E:StaticPopup_Show("CONFIG_RL");  end,
							get = function(info) return E.db.euiscript.csc; end,
						},
						disable_talking = {
							order = 25,
							type = 'toggle',
							name = DISABLE..L["TalkingHead"],
							set = function(info, value) E.db.euiscript.disable_taling = value; E:GetModule("EuiScript").ToggleTalkingFrame(); end,
							get = function(info) return E.db.euiscript.disable_taling; end,
						},
						poi = {
							order = 26,
							type = 'toggle',
							name = L['poi'],
							set = function(info, value) E.db.euiscript.poi = value; E:GetModule('EuiScript'):ToggleEuiScriptPoi(); end,
							get = function(info) return E.db.euiscript.poi; end,
						},
						poiCombat = {
							order = 27,
							type = 'toggle',
							name = L["Combat Toggle"],
							set = function(info, value) E.db.euiscript.poiCombat = value; E:GetModule('EuiScript'):ToggleEuiScriptPoi(); end,
							get = function(info) return E.db.euiscript.poiCombat; end,
							disabled = function() return not E.db.euiscript.poi; end,
						},
						poiColor = {
							order = 28,
							type = "color",
							name = L['poi color'],
							hasAlpha = false,
							get = function(info)
								local t = E.db.euiscript.poiColor
								local d = P.euiscript.poiColor
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								E.db.euiscript.poiColor = {}
								local t = E.db.euiscript.poiColor
								t.r, t.g, t.b = r, g, b
								E:GetModule('EuiScript'):ToggleEuiScriptPoi();
							end,	
							disabled = function() return not E.db.euiscript.poi end,
						},
						poiText = {
							order = 29,
							type = 'select',
							name = L['poi text'],
							disabled = function() return not E.db.euiscript.poi; end,
							values = {
								['┼'] = '┼',
								['╋'] = '╋',
								['◆'] = '◆',
								['■'] = '■',
								['●'] = '●',
								['※'] = '※',
								['↓'] = '↓',
							},
							set = function(info, value)
								E.db.euiscript.poiText = value;
								E:GetModule('EuiScript'):ToggleEuiScriptPoi();
							end,
						},
						poiTextSize = {
							order = 30,
							type = 'range',
							name = L['poi text font'],
							min = 10, max = 50, step = 1,
							set = function(info, value)
								E.db.euiscript.poiTextSize = value;
								E:GetModule('EuiScript'):ToggleEuiScriptPoi();
							end,
						},
						unitprice = {
							order = 32,
							type = 'toggle',
							name = L['UnitPrice'],
							desc = L['UnitPrice desc'],
							set = function(info, value)
								E.db.euiscript.unitprice = value;
								E:StaticPopup_Show("CONFIG_RL");
							end,
						},
						char_ilvl = {
							order = 33,
							type = 'toggle',
							name = L['Character ilvl'],
							get = function(info) return E.db.euiscript.char_ilvl end,
							set = function(info, value) E.db.euiscript.char_ilvl = value; end,
						},
						slotlv_fontsize = {
							order = 36,
							type = 'range',
							name = L["SlotItemLevel"]..L["Font Size"],
							set = function(info, value)
								E.db.euiscript.slotlv_fontsize = value;
								E:StaticPopup_Show("CONFIG_RL");
							end,
						},
						durability = {
							order = 34,
							type = 'toggle',
							name = L["DURABILITY"],
							set = function(info, value)
								E.db.euiscript.durability = value;
							end,
						},
						durability_fontsize = {
							order = 35,
							type = 'range',
							name = L["DURABILITY"]..L["Font Size"],
							set = function(info, value)
								E.db.euiscript.durability_fontsize = value;
								E:StaticPopup_Show("CONFIG_RL");
							end,
						},
						dismount = {
							order = 36,
							type = 'toggle',
							name = L["dismount"],
							set = function(info, value)
								E.db.euiscript.dismount = value;
							end,
						},
						spellactivation = {
							order = 37,
							type = 'toggle',
							name = L["Five combo"],
							set = function(info, value)
								E.db.euiscript.spellactivation = value;
							end,
						},
						-- CharacterStats = {
							-- type = 'toggle',
							-- order = 34,
							-- name = L["Character Stats Enhance"],
							-- set = function(info, value)
								-- if E.db.euiscript.CharacterStats then
									-- E.db.euiscript.CharacterStats = value
									-- E:StaticPopup_Show("CONFIG_RL");
								-- else
									-- E.db.euiscript.CharacterStats = value;
									-- E:ToggleCharacterStats(value)
								-- end
							-- end,
						-- },
						-- CharacterStatsList = {
							-- type = 'multiselect',
							-- order = 35,
							-- name = L["CharacterStats List"],
							-- disabled = function() return not E.db.euiscript.CharacterStats; end,
							-- set = function(info, k, v) E.db.euiscript.CharacterStatsList[k] = v; E:ToggleCharacterStats(true); end,
							-- get = function(info, k) return E.db.euiscript.CharacterStatsList[k]; end,
							-- values = {},
						-- },
					},
				},
				questGroup = {
					order = 2,
					type = 'group',
					guiInline = false,
					name = L["Quest Frames"],
					get = function(info) return E.db.euiscript.questnoti[ info[#info] ] end,
					set = function(info, value) E.db.euiscript.questnoti[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,	
					args = {					
						enable = {
							order = 4,
							type = "toggle",
							name = L["quest notifier"],
						},
						Instance = {
							order = 5,
							type = "toggle",
							name = INSTANCE,
							disabled = function() return not E.db.euiscript.questnoti.enable end,
						},
						Raid = {
							order = 6,
							type = "toggle",
							name = RAID,
							disabled = function() return not E.db.euiscript.questnoti.enable end,
						},
						Party = {
							order = 7,
							type = "toggle",
							name = PARTY,
							disabled = function() return not E.db.euiscript.questnoti.enable end,
						},
						Solo = {
							order = 8,
							type = "toggle",
							name = SOLO,
							disabled = function() return not E.db.euiscript.questnoti.enable end,
						},
						every = {
							order = 9,
							type = "range",
							name = L["Announce Every"],
							min = 0, max = 10,step = 1,
							disabled = function() return not E.db.euiscript.questnoti.enable end,
						},
						idq = {
							order = 10,
							type = 'toggle',
							name = L["idQuestAutomation"],
							desc = L["idQuestAutomation_desc"],
							get = function(info) return E.db.euiscript.idq; end,
							set = function(info, value)
								E.db.euiscript.idq = value;
								if CodexConfig and value then
									CodexConfig.autoAccept = false
									CodexConfig.autoTurnin = false
								end
							end,
						},
						autoTrackQuest = {
							order = 11,
							type = 'toggle',
							name = L['autoTrackQuest'],
							disabled = function() return IsAddOnLoaded('ButterQuestTracker') end,
							get = function(info) return E.db.euiscript.autoTrackQuest; end,
							set = function(info, value) E.db.euiscript.autoTrackQuest = value; end,
						},
						-- objectiveTrackerFrame = {
							-- order = 12,
							-- type = 'toggle',
							-- name = L['objectiveTrackerFrame'],
							-- get = function(info) return E.db.euiscript.objectiveTrackerFrame; end,
							-- set = function(info, value) E.db.euiscript.objectiveTrackerFrame = value;E:StaticPopup_Show("CONFIG_RL"); end,
						-- },
						-- questfontSize = {
							-- order = 13,
							-- name = L["Quest Font Size"],
							-- type = "range",
							-- min = 4, max = 32, step = 1,
							-- disabled = function() return not BetterQuestFrame end,
							-- set = function(info, value) E.db.general.questfontSize = value; BetterQuestFrame:LoadQuests() end,
							-- get = function(info) return E.db.general.questfontSize; end,
						-- },
						-- frameWidth = {
							-- order  = 15,
							-- type = "range",
							-- name = L["Width"],
							-- disabled = function() return not BetterQuestFrame end,
							-- min = 100,max = BetterQuestFrame:GetResolution().width, step = 1,
							-- set = function(info, value) BetterQuestFrameDB.frameWidth = value;BetterQuestFrame:LoadQuests() end,
							-- get = function(info) return BetterQuestFrameDB.frameWidth end,
						-- },
						-- frameHeight = {
							-- order  = 16,
							-- type = "range",
							-- name = L["Height"],
							-- disabled = function() return not BetterQuestFrame end,
							-- min = 100,max = BetterQuestFrame:GetResolution().height, step = 1,
							-- set = function(info, value) BetterQuestFrameDB.frameHeight = value;BetterQuestFrame:LoadQuests() end,
							-- get = function(info) return BetterQuestFrameDB.frameHeight end,
						-- },
						-- auto_collapse = {
							-- order = 20,
							-- type = 'toggle',
							-- name = L["auto Collapse Objective InInstance"],
							-- disabled = function() return not BetterQuestFrame end,
							-- get = function(info) return E.db.euiscript.auto_collapse; end,
							-- set = function(info, value) E.db.euiscript.auto_collapse = value end,
						-- },
						QuestLevel = {
							order = 21,
							type = 'toggle',
							name = L["Quest Level"],
							disabled = function() return IsAddOnLoaded('ButterQuestTracker') end,
							get = function(info) return E.db.euiscript.QuestLevel; end,
							set = function(info, value) E.db.euiscript.QuestLevel = value;E:StaticPopup_Show("CONFIG_RL"); end,
						},
						-- tztb = {
							-- order = 12,
							-- type = 'toggle',
							-- name = L['TZ:TanannaBonus'],
							-- get = function(info) return E.db.euiscript.tztb; end,
							-- set = function(info, value) E.db.euiscript.tztb = value; E:StaticPopup_Show("CONFIG_RL"); end,
						-- },
						-- tztb_icon = {
							-- order = 13,
							-- type = 'range',
							-- min = 10, max = 40, step = 1,
							-- disabled = function() return not E.db.euiscript.tztb_icon; end,
							-- name = L['TZ:Icon_Size'],
							-- get = function(info) return E.db.euiscript.tztb_icon; end,
							-- set = function(info, value) E.db.euiscript.tztb_icon = value; E:StaticPopup_Show("CONFIG_RL"); end,
						-- },
					},
				},					
				notiGroup = {
					order = 3,
					type = 'group',
					guiInline = false,
					name = L['About Prompt info'],
					get = function(info) return E.db.euiscript[ info[#info] ] end,
					set = function(info, value) E.db.euiscript[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,						
					args = {
						combatnoti = {
							order = 1,
							type = "toggle",
							name = L["combatnoti"],
						},	
						combatnoti_leaving = {
							order = 2,
							type = "input",
							disabled = function(info) return not E.db.euiscript.combatnoti end,
							set = function(info, value) E.db.euiscript[ info[#info] ] = value; end,
							name = L["combatnoti_leaving"],
						},
						combatnoti_entering = {
							order = 3,
							type = "input",
							disabled = function(info) return not E.db.euiscript.combatnoti end,
							set = function(info, value) E.db.euiscript[ info[#info] ] = value; end,
							name = L["combatnoti_entering"],
						},						
						-- lfgnoti = {
							-- order = 4,
							-- name = L["lfg notification"],
							-- type = "select",
							-- values = {
								-- ['NONE'] = NONE,
								-- ['GUILD'] = GUILD,
								-- ['PARTY'] = PARTY,
								-- ['RAID'] = RAID,
							-- },
						-- },
						-- wgtimenoti = {
							-- order = 5,
							-- name = L["wgtimenoti"],
							-- type = "select",
							-- values = {
								-- ['NONE'] = NONE,
								-- ['GUILD'] = GUILD,
								-- ['PARTY'] = PARTY,
								-- ['RAID'] = RAID,
							-- },					
						-- },
					--	holidayMsg = {
					--		order = 8,
					--		name = L['Holiday Msg'],
					--		type = 'toggle',
					--	},				
						autoscreenshoot = {
							order = 6,
							name = L["Auto achievement screenshoot"],
							type = "toggle",
						},
						screenFormat = {
							order = 7,
							name = L["Screenshot Format"],
							type = "select",
							values = {
								["jpeg"] = "JPG",
								["tga"] = "TGA",
							},
							get = function(info) return GetCVar("screenshotFormat") end,
							set = function(info, value) SetCVar("screenshotFormat", value) end,
						},
						screenQuality = {
							order = 8,
							name = L["Screenshot Quality"],
							type = "range",
							min = 3, max = 10, step = 1,
							get = function(info) return tonumber(GetCVar("screenshotQuality")) end,
							set = function(info, value) SetCVar("screenshotQuality", tostring(value)) end,
						},
						logging_combat = {
							order = 10,
							name = L["auto open/close combatlog"],
							type = "toggle",
						},
						fivecombo = {
							order = 11,
							name = L["Five combo"],
							type = "toggle",
						},
						announcements = {
							order = 12,
							name = L["Special spell announce"],
							type = "toggle",
						},
						spellSay = {
							order = 13,
							name = L["Player Spell Say"],
							type = "toggle",
						},
					},
				},
				inviteGroup = {
					order = 4,
					type = 'group',
					name = L['About Invite'],
					get = function(info) return E.db.euiscript[ info[#info] ] end,
					set = function(info, value) E.db.euiscript[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,						
					args = {
						autoinvenable = {
							order = 1,
							type = "toggle",
							name = L["autoinvenable"],
						},
						ainvkeyword = {
							order = 2,
							type = "input",
							disabled = function(info) return not E.db.euiscript.autoinvenable end,
							set = function(info, value) E.db.euiscript.ainvkeyword = value; end,					
							name = L["ainvkeyword"],
						},
						spacer = {
							type = 'description',
							name = '',
							desc = '',
							order = 3,
						},
						inviteRank = {
							order = 4,
							type = 'multiselect',
							name = L['Invite guild ranks member'],
							set = function(info, k, v) E.db.euiscript.InviteRank[k] = v; end,
							get = function(info, k) return E.db.euiscript.InviteRank[k] end,
							disabled = function() return not IsInGuild() end,
							values = E:GetModule('EuiScript'):GetGuildRanks(),
						},						
						refresh = {
							order = 5,
							type = 'execute',
							name = REFRESH..RANK,
							func = function() E.Options.args.euiscript.args.euiscript_general.args.inviteGroup.args.inviteRank.values = E:GetModule('EuiScript'):GetGuildRanks(); end,
						},
						startInvite = {
							order = 6,
							type = 'execute',
							name = L['Start Invite'],
							disabled = function() return not IsInGuild() end,
							func = function() 
								for k, v in pairs(E.db.euiscript.InviteRank) do
									if v then
										SendChatMessage(format(L['Invite guild ranks is %s member, in 10 sec.'], GuildControlGetRankName(k)), 'GUILD')
									end
								end
								E:ScheduleTimer(E:GetModule('EuiScript').InviteRanks, 10);
							end,
						},
					},
				},
				lootGroup = {
					order = 5,
					type = 'group',
					name = L['About Loot'],
					get = function(info) return E.db.euiscript[ info[#info] ] end,
					set = function(info, value) E.db.euiscript[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,					
					args = {
						autogreed = {
							order = 1,
							type = "toggle",
							name = L["autogreed"],
							disabled = (UnitLevel('player') ~= MAX_PLAYER_LEVEL),
						},
						autochangeloot = {
							order = 2,
							type = "toggle",
							name = L["Auto change loot"],
							desc = L["InGroup change loot to freecall, InRaid change loot to master"],
						},
						spacer = {
							type = 'description',
							name = '',
							desc = '',
							order = 3,
						},						
						autosell = {
							order = 4,
							type = "toggle",
							name = L["Auto Sell"],
							set = function(info, value) E.db.euiscript.autosell = value; end,
						},
						spacer2 = {
							type = 'description',
							name = '',
							desc = '',
							order = 5,
						},						
						selllisttext = {
							order = 6,
							type = 'input',
							name = L['Item-ID'],
							set = function(info, value)
								local itemid = tonumber(value)
								if itemid and GetItemInfo(itemid) then
									E.db.euiscript.selllisttext = itemid;
								end
							end,
							get = function(info) return tostring(E.db.euiscript.selllisttext); end,
							disabled = function(info) return not E.db.euiscript.autosell end,
						},
						selllistadd = {
							order = 7,
							type = 'execute',
							name = L['Add ItemID'],
							func = function()
								if not GetItemInfo(E.db.euiscript.selllisttext) then return; end
								E.db.euiscript.autosellList[E.db.euiscript.selllisttext] = true;
								E.Options.args.euiscript.args.euiscript_general.args.lootGroup.args.autosellList.values[E.db.euiscript.selllisttext] = select(2, GetItemInfo(E.db.euiscript.selllisttext));
							end,
							disabled = function(info) return not E.db.euiscript.autosell end,
						},
						selllistdel = {
							order = 8,
							type = 'execute',
							name = L['Delete ItemID'],
							func = function()
								if not GetItemInfo(E.db.euiscript.selllisttext) then return; end
								E.db.euiscript.autosellList[E.db.euiscript.selllisttext] = nil;
								E.Options.args.euiscript.args.euiscript_general.args.lootGroup.args.autosellList.values[E.db.euiscript.selllisttext] = nil;
							end,
							disabled = function(info) return not E.db.euiscript.autosell end,
						},
						autosellList = {
							order = 9,
							type = "multiselect",
							name = L["auto sell item list"],
							get = function(info, k) return E.db.euiscript.autosellList[k]; end,
							set = function(info, k, v) E.db.euiscript.autosellList[k] = v; end,
							disabled = function(info) return not E.db.euiscript.autosell end,
							values = {},									
						},							
						auto_confirm_de = {
							order = 10,
							type = "toggle",
							name = L["Auto Disenchant confirmation"],
						},		
						-- lootCouncil = {
							-- order = 11,
							-- type = 'toggle',
							-- name = L["Loot Council"],
							-- get = function(info) return E.db.euiscript.LCData.enable end,
							-- set = function(info, value) E.db.euiscript.LCData.enable = value; E:StaticPopup_Show("CONFIG_RL"); end,
						-- },
					},
				},			
			},
		},
		euiscript_autobuy = {
			order = 2,
			type = "group",
			name = L["autobuy reagents"],
			get = function(info) return E.db.euiscript[ info[#info] ] end,
			set = function(info, value) E.db.euiscript[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,
			args = {
				autobuy = {
					order = 1,
					type = "toggle",
					name = L["autobuy reagents"],
				},
				autobuy_maxlevel = {
					order = 2,
					type = 'range',
					min = 1, max = MAX_PLAYER_LEVEL, step = 1,
					name = PLAYER..LEVEL,
				},
				spacer = {
					order = 3,
					type = 'description',
					name = '',
				},
				autobuyitemlist = {
					order = 4,
					type = 'select',
					name = L["WhiteList"],
					set = function(info, value) if value == '' then selectedItemid = nil; else selectedItemid = value end; UpdateAutobuyGroup(); end,							
					values = {},								
				},
				spacer2 = {
					order = 5,
					type = 'description',
					name = '',
				},
				itemid = {
					order = 6,
					type = 'input',
					name = L['Item-ID'],
					set = function(info, value)
						if value and GetItemInfo(value) then
							adItemid = value;
						else
							E:Print(L['Must is itemID!']);
						end							
					end,
					get = function(info) return adItemid or ''; end,
				},
				additemid = {
					order = 7,
					type = 'execute',
					name = L['Add ItemID'],
					func = function() 
						if GetItemInfo(adItemid) then
							E.db.euiscript.autobuylist[adItemid] = 1;
							E.Options.args.euiscript.args.euiscript_autobuy.args.autobuyitemlist.values[adItemid] = GetItemInfo(adItemid)..'('..adItemid..')';
							E:Print(L['Add ItemID']..': '..adItemid..SUCCESS..'!');
							adItemid = nil;
						end							
					end,
				},
				delitemid = {
					order = 8,
					type = 'execute',
					name = L['Delete ItemID'],
					func = function()
						if GetItemInfo(adItemid) then
							E.db.euiscript.autobuylist[adItemid] = nil; 
							E.Options.args.euiscript.args.euiscript_autobuy.args.autobuyitemlist.values[adItemid] = nil;
							if adItemid == selectedItemid then selectedItemid = nil; UpdateAutobuyGroup(); end;
							E:Print(L['Delete ItemID']..': '..adItemid..SUCCESS..'!');
							adItemid = nil;
						end;
					end,
				},
			},
		},											
		euiscript_raidcd = {
			order = 3,
			type = "group",
			name = L["raidcd"],
			get = function(info) return E.db.euiscript[ info[#info] ] end,
			set = function(info, value) E.db.euiscript[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,
			args = {
				raidcd = {
					order = 0,
					type = "toggle",
					name = L["raidcd"],
					desc = L["raidcd_desc"],
				},
				raidcccd = {
					order = 1,
					type = "toggle",
					name = L["raidcccd"],
					desc = L["raidcd_desc"],
				},
				raidcd_maxbars = {
					order = 2,
					type = "range",
					name = L["raidcd_maxbars"],
					min = 1, max = 40, step = 1,
				},
				raidcd_style = {
					order = 3,
					type = "select",
					name = L["Style"],
					set = function(info, value) 
						E.db.euiscript[ info[#info] ] = value;
						E:GetModule('RAIDCD'):ToggleRaidCD();
						E:StaticPopup_Show("CONFIG_RL");
						end,
					values = {
						['bar'] = L["Bar Mode"],
						['icon'] = L["Icon Mode"],
					},
				},
				barstyle = {
					order = 4,
					type = 'group',
					name = L["Bar Mode"],
					guiInline = false,
					disabled = function() return E.db.euiscript.raidcd_style == 'icon' end,
					get = function(info) return E.db.euiscript[ info[#info] ] end,
					set = function(info, value) E.db.euiscript[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,						
					args = {
						raidcd_width = {
							order = 1,
							type = "range",
							name = L["raidcd_width"],
							min = 10, max = 600, step = 1,
						},
						raidcd_height = {
							order = 2,
							type = "range",
							name = L["raidcd_height"],
							min = 1, max = 100, step = 1,
						},
						raidcd_direction = {
							order = 3,
							type = "select",
							name = L["raidcd_direction"],
							values = {
								["up"] = L["up"],
								["down"] = L["down"],
							},
						},
					},
				},
				iconstyle = {
					order = 5,
					type = 'group',
					name = L["Icon Mode"],
					guiInline = false,
					disabled = function() return E.db.euiscript.raidcd_style == 'bar' end,
					get = function(info) return E.db.euiscript[ info[#info] ] end,
					set = function(info, value) E.db.euiscript[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,
					args = {
						raidcd_iconsize = {
							order = 1,
							type = 'range',
							name = L["Icon Size"],
							min = 10, max = 100, step =1,
						},
						raidcd_perrow = {
							order = 2,
							type = 'range',
							name = L['Buttons Per Row'],
							min = 1, max = 40, step = 1,
						},
						raidcd_iconfontsize = {
							order = 3,
							type = 'range',
							name = L["Font Size"],
							type = "range",
							min = 4, max = 50, step = 1,
						},
						raidcd_iconspace = {
							order = 4,
							type = 'range',
							name = L["Interval"],
							min = 4, max = 40, step = 1,
						},
						raidcd_icondirection = {
							order = 5,
							type = "select",
							name = L["raidcd_direction"],
							values = {
								["right"] = L['RIGHT'],
								["left"] = L['LEFT'],
							},
						},
					},
				},
			},
		},
		autobutton = {
			order = 6,
			type = 'group',
			name = L["Auto QuestItem Button"],
			get = function(info) return E.db.euiscript.autobutton[ info[#info] ] end,
			set = function(info, value) E.db.euiscript.autobutton[ info[#info] ] = value; E:GetModule('AutoButton'):UpdateAutoButton() end,
			args = {
				enable = {
					order = 0,
					type = 'toggle',
					name = L['Enable'],
				},
				bindFontSize = {
					order = 1,
					type = 'range',
					min = 4, max = 40, step =1,
					name = L['Keybind Text']..L["Font Size"],
				},
				countFontSize = {
					order = 2,
					type = 'range',
					min = 4, max = 40, step =1,
					name = L['Item Count']..L["Font Size"],
				},
				AptifactItem = {
					order = 3,
					type = 'toggle',
					name = ARTIFACT_POWER,
					set = function(info, value)
						E.db.euiscript.autobutton.AptifactItem = value;
						E:GetModule('AutoButton'):ScanItem("BAG_UPDATE_DELAYED");
					end,
				},
				questNum = {
					order = 4,
					type = 'range',
					name = L['Quset Button Number'],
					min = 0, max = 12, step = 1,
				},
				questPerRow = {
					order = 5,
					type = 'range',
					name = L['Buttons Per Row'],
					min = 1, max = 12, step = 1,
				},
				questSize = {
					order = 6,
					type = 'range',
					name = L['Size'],
					min = 10, max = 100, step = 1,
				},				
				slotNum = {
					order = 7,
					type = 'range',
					name = L['Slot Button Number'],
					min = 0, max = 12, step = 1,
				},
				slotPerRow = {
					order = 8,
					type = 'range',
					name = L['Buttons Per Row'],
					min = 1, max = 12, step = 1,
				},
				slotSize = {
					order = 9,
					type = 'range',
					name = L['Size'],
					min = 10, max = 100, step = 1,
				},
				spacer2 = {
					order = 10,
					type = 'description',
					name = '',
					width = "full",
				},				
				itemID = {
					order = 11,
					type = 'input',
					name = L['Item-ID'],
					get = function() return whiteItemID or '' end,
					set = function(info, value) whiteItemID = value end,
				},
				AddItemID = {
					order = 12,
					type = 'execute',
					name = L['Add ItemID'],
					func = function()
						if not tonumber(whiteItemID) then
							E:Print(L['Must is itemID!']);
							return;
						end
						local id = tonumber(whiteItemID)
						if not GetItemInfo(id) then
							E:Print(whiteItemID.. 'is error itemID');
							return;
						end
						E.db.euiscript.autobutton.whiteList[id] = true;
						E.Options.args.euiscript.args.autobutton.args.whiteList.values[id] = GetItemInfo(id);
						E:GetModule('AutoButton'):UpdateAutoButton();
					end,
				},
				DeleteItemID = {
					order = 13,
					type = 'execute',
					name = L['Delete ItemID'],
					func = function()
						if not tonumber(whiteItemID) then
							E:Print(L['Must is itemID!']);
							return;
						end
						local id = tonumber(whiteItemID)
						if not GetItemInfo(id) then
							E:Print(whiteItemID.. 'is error itemID');
							return;
						end
						if E.db.euiscript.autobutton.whiteList[id] == true or E.db.euiscript.autobutton.whiteList[id] == false then
							E.db.euiscript.autobutton.whiteList[id] = nil;
							E.Options.args.euiscript.args.autobutton.args.whiteList.values[id] = nil;
						end
						E:GetModule('AutoButton'):UpdateAutoButton();
					end,
				},					
				whiteList = {
					order = 14,
					type = 'multiselect',
					name = L['Whitelist'],
					get = function(info, k) return E.db.euiscript.autobutton.whiteList[k] end,
					set = function(info, k, v) E.db.euiscript.autobutton.whiteList[k] = v; E:GetModule('AutoButton'):UpdateAutoButton() end,
					values = {}
				},
				spacer4 = {
					order = 15,
					type = 'description',
					name = '',
					width = "full",
				},
				blackitemID = {
					order = 16,
					type = 'input',
					name = L['Item-ID'],
					get = function() return blackItemID or '' end,
					set = function(info, value) blackItemID = value end,
				},
				AddblankItemID = {
					order = 17,
					type = 'execute',
					name = L['Add ItemID'],
					func = function() 
						if not tonumber(blackItemID) then
							E:Print(L['Must is itemID!']);
							return;
						end
						local id = tonumber(blackItemID)							
						if not GetItemInfo(id) then
							E:Print(blackItemID.. 'is error itemID');
							return;
						end
						E.db.euiscript.autobutton.blankList[id] = true;
						E.Options.args.euiscript.args.autobutton.args.blankList.values[id] = GetItemInfo(id);
						E:GetModule('AutoButton'):UpdateAutoButton();
					end,
				},
				DeleteblankItemID = {
					order = 18,
					type = 'execute',
					name = L['Delete ItemID'],
					func = function()
						if not tonumber(blackItemID) then
							E:Print(L['Must is itemID!']);
							return;
						end
						local id = tonumber(blackItemID)
						if not GetItemInfo(id) then
							E:Print(blackItemID.. 'is error itemID');
							return;
						end
						if E.db.euiscript.autobutton.blankList[id] == true or E.db.euiscript.autobutton.blankList[id] == false then
							E.db.euiscript.autobutton.blankList[id] = nil;
							E.Options.args.euiscript.args.autobutton.args.blankList.values[id] = nil;
						end
						E:GetModule('AutoButton'):UpdateAutoButton();
					end,
				},					
				blankList = {
					order = 19,
					type = 'multiselect',
					name = L['Blacklist'],
					get = function(info, k) return E.db.euiscript.autobutton.blankList[k] end,
					set = function(info, k, v) E.db.euiscript.autobutton.blankList[k] = v; E:GetModule('AutoButton'):UpdateAutoButton() end,
					values = {}
				},					
			},
		},
		fsbutton = {
			order = 8,
			type = 'group',
			name = GetSpellInfo(12654) or '?',
			hidden = function() return class ~= "MAGE" end,
			get = function(info) return E.db.euiscript.fsbutton[ info[#info] ] end,
			set = function(info, value) E.db.euiscript.fsbutton[ info[#info] ] = value; E:GetModule('FireMage'):Toggle() end,
			args = {
				enable = {
					order = 1,
					type = 'toggle',
					name = L['Enable'],
				},
				size = {
					order = 2,
					type = 'range',
					name = L['Size'],
					min = 10, max = 100, step = 1,
				},
				fontsize = {
					order = 3,
					type = 'range',
					name = L["Font Size"],
					type = "range",
					min = 4, max = 50, step = 1,
				},
				overlay = {
					order = 4,
					type = 'toggle',
					name = L['Overlay Style'],
				},
				maxValue = {
					order = 5,
					type = 'input',
					name = L['Alert Value'],
					desc = L['show alert value'],
					get = function(info) return tostring(E.db.euiscript.fsbutton.maxValue) end,
					set = function(info, value) 
						if tonumber(value) == nil or tonumber(value) < 1000 then
							return;
						else
							E.db.euiscript.fsbutton.maxValue = tonumber(value);
						end
					end,
				},
				sound = {
					type = 'select', dialogControl = 'LSM30_Sound',
					name = L["Alert"],
					desc = L["Alert, set to NONE disable it!"],
					disabled = function() return not E.db.euiscript.fsbutton.sound end,
					values = AceGUIWidgetLSMlists.sound,
					set = function(info, value) E.db.euiscript.fsbutton.sound = value; end,
				},
			},
		},
		threat = {
			order = 12,
			type = 'group',
			name = L['Nice threat bar'],
			get = function(info) return E.db.euiscript.threat[ info[#info] ] end,
			set = function(info, value) E.db.euiscript.threat[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,
			args = {
				enable = {
					order = 1,
					type = 'toggle',
					name = L['Enable'],
				},			
				NameTextL = {
					order = 2,
					type = 'range',
					name = L['Name']..L["Length"],
					min = 2, max = 12, step = 1,
				},
				ThreatLimited = {
					order = 3,
					type = 'range',
					name = L['ThreatLimited'],
					min = 2, max = 40, step = 1,
				},
				ThreatUnit = {
					order = 4,
					type = 'select',
					name = L['ThreatUnit'],
					values = {
						['target'] = L['target'],
						['focus'] = L['focus'],
						['boss1'] = 'BOSS1',
						['boss2'] = 'BOSS2',
						['boss3'] = 'BOSS3',
						['boss4'] = 'BOSS4',
					},
					set = function(info, value)
						E.db.euiscript.threat.ThreatUnit = value;
						E:GetModule('EuiThreat'):ChangeThreatUnit();
					end,
				},
				width = {
					order = 5,
					type = 'range',
					name = L['Width'],
					type = "range",
					min = 10, max = 500, step = 1,
				},
				height = {
					order = 6,
					type = 'range',
					name = L['Height'],
					type = "range",
					min = 1, max = 50, step = 1,
				},	
				solo = {
					order = 7,
					type = 'toggle',
					name = L['Solo Show'],
				},				
				font_size = {
					order = 8,
					type = 'range',
					name = L["Font Size"],
					type = "range",
					min = 4, max = 50, step = 1,
				},
			},
		},			
		rlbox = {
			order = 100,
			type = 'group',
			name = L['RLBox'],
			get = function(info) return E.db.RLBox[ info[#info] ] end,
			set = function(info, value) E.db.RLBox[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
			args = {
				intro = {
					order = 0,
					type = "description",
					fontSize = "medium",
					name = L["RLBox_DESC"],
				},
				enable = {
					order = 1,
					type = 'toggle',
					name = L['Enable'],
				},
				TitleFontSize = {
					order = 2,
					type = 'range',
					min = 4, max = 30, step = 1,
					name = L["Title Font Size"],
				},
				wpTime = {
					order = 4,
					type = 'range',
					min = 0, max = 6, step = 1,
					width = 'full',
					name = L['Duration'],
					desc = L["When the value of the duration of this next group members informed of the WHISPER, set to 0 to disable WHISPER."],
				},
				UIType = {
					order = 5,
					type = 'select',
					name = L['UI Type'],
					values = {
						['bar'] = L["Bar Mode"],
						['icon'] = L["Icon Mode"],
					},
				},
				party = {
					order = 6,
					type = 'toggle',
					name = L['Allow grouping'],
				},
				DEFAULT_SPELLS_GROUP = {
					order = 10,
					type = 'group',
					name = L['EUIRaidToolBox1'],
					guiInline = false,
					get = function(info) return E.db.RLBox.DEFAULT[ info[#info] ] end,
					set = function(info, value) E.db.RLBox.DEFAULT[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
					disabled = function() return not E.db.RLBox.enable end,
					args = {
						enable = {
							order = 1,
							type = 'toggle',
							name = L['Enable'],
						},
						resetSettings = {
							type = 'execute',
							order = 2,
							name = L['Restore Defaults'],
							func = function(info, value) wipe(E.global.RLBox.DEFAULT_SPELLS); E:CopyTable(E.global.RLBox.DEFAULT_SPELLS, G.RLBox.DEFAULT_SPELLS); E:ResetMovers(L['EUIRaidToolBox1']); end,
						},						
						sendStartMsg = {
							order = 3,
							name = L['Send Cast Info'],
							type = "select",
							disabled = function() return not E.db.RLBox.DEFAULT.enable end,
							values = {
								['NONE'] = NONE,
								['GUILD'] = GUILD,
								['PARTY'] = PARTY,
								['RAID'] = RAID,
								['RAID_WARNING'] = L['RW'],								
							},
						},
						sendEndMsg = {
							order = 4,
							name = L['Send Ready Info'],
							type = "select",
							disabled = function() return not E.db.RLBox.DEFAULT.enable end,
							values = {
								['NONE'] = NONE,
								['GUILD'] = GUILD,
								['PARTY'] = PARTY,
								['RAID'] = RAID,
								['RAID_WARNING'] = L['RW'],								
							},
						},						
						IconSize = {
							order = 5,
							type = 'range',
							min = 5, max = 50, step = 1,
							name = L['IconSize'],
							disabled = function() return not E.db.RLBox.DEFAULT.enable end,
							set = function(info, value)
								E.db.RLBox.DEFAULT[ info[#info] ] = value;
								E:GetModule('RLBox'):UpdateBoxUI(EUIRaidToolBox1, true)
							end,
						},
						BarHeight = {
							order = 6,
							type = 'range',
							min = 2, max = 20, step = 1,
							name = L['BarHeight'],
							disabled = function() return (not E.db.RLBox.DEFAULT.enable) or (E.db.RLBox.UIType == 'icon') end,
							set = function(info, value)
								E.db.RLBox.DEFAULT[ info[#info] ] = value;
								E:GetModule('RLBox'):UpdateBoxUI(EUIRaidToolBox1, true)
							end,							
						},
						BarWidth = {
							order = 7,
							type = 'range',
							min = 5, max = 500, step = 1,
							name = L['BarWidth'],
							disabled = function() return (not E.db.RLBox.DEFAULT.enable) or (E.db.RLBox.UIType == 'icon') end,
							set = function(info, value)
								E.db.RLBox.DEFAULT[ info[#info] ] = value;
								E:GetModule('RLBox'):UpdateBoxUI(EUIRaidToolBox1, true)
							end,
						},
						FontSize = {
							order = 8,
							type = 'range',
							min = 4, max = 30, step = 1,
							name = L["Font Size"],
							disabled = function() return not E.db.RLBox.DEFAULT.enable end,
							set = function(info, value)
								E.db.RLBox.DEFAULT[ info[#info] ] = value;
								E:GetModule('RLBox'):UpdateBoxUI(EUIRaidToolBox1, true)
							end,							
						},
						minperrow = {
							order = 9,
							type = 'range',
							min = 5, max = 20, step = 1,
							name = L['minperrow'],
							desc = L['minperrow_desc']..L["Bar Mode"],
							disabled = function() return (not E.db.RLBox.DEFAULT.enable) or (E.db.RLBox.UIType == 'icon') end,
						},	
						rownums = {
							order = 10,
							type = 'range',
							min = 1, max = 20, step = 1,
							name = L['perRow'],
							desc = L["Icon Mode"],
							disabled = function() return (not E.db.RLBox.DEFAULT.enable) or (E.db.RLBox.UIType == 'bar') end,
						},							
						selectSpell = {
							order = 11,
							name = L["Select Spell"],
							type = 'select',
							set = function(info, value) RLBox_EditSpell(value, E.global.RLBox.DEFAULT_SPELLS, "DEFAULT_SPELLS_GROUP", E.db.RLBox.DEFAULT.enable); end,
							disabled = function() return not E.db.RLBox.DEFAULT.enable end,
							values = function()
								local spells = {}
								for k, default in pairs(E.global.RLBox.DEFAULT_SPELLS) do
									local spellid = default[2]
									if GetSpellInfo(spellid) then
										spells[spellid] = GetSpellInfo(spellid)..'('..spellid..')';
									end
								end
								
								return spells
							end,
						},
					},
				},
				OTHER_SPELLS_GROUP = {
					order = 15,
					type = 'group',
					name = L['EUIRaidToolBox2'],
					guiInline = false,
					get = function(info) return E.db.RLBox.OTHER[ info[#info] ] end,
					set = function(info, value) E.db.RLBox.OTHER[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
					disabled = function() return not E.db.RLBox.enable end,
					args = {
						enable = {
							order = 1,
							type = 'toggle',
							name = L['Enable'],
						},
						resetSettings = {
							type = 'execute',
							order = 2,
							name = L['Restore Defaults'],
							func = function(info, value) wipe(E.global.RLBox.OTHER_SPELLS); E:CopyTable(E.global.RLBox.OTHER_SPELLS, G.RLBox.OTHER_SPELLS); E:ResetMovers(L['EUIRaidToolBox2']); end,
						},						
						sendStartMsg = {
							order = 3,
							name = L['Send Cast Info'],
							type = "select",
							disabled = function() return not E.db.RLBox.OTHER.enable end,
							values = {
								['NONE'] = NONE,
								['GUILD'] = GUILD,
								['PARTY'] = PARTY,
								['RAID'] = RAID,
								['RAID_WARNING'] = L['RW'],								
							},
						},
						sendEndMsg = {
							order = 4,
							name = L['Send Ready Info'],
							type = "select",
							disabled = function() return not E.db.RLBox.OTHER.enable end,
							values = {
								['NONE'] = NONE,
								['GUILD'] = GUILD,
								['PARTY'] = PARTY,
								['RAID'] = RAID,
								['RAID_WARNING'] = L['RW'],								
							},
						},
						IconSize = {
							order = 5,
							type = 'range',
							min = 5, max = 50, step = 1,
							name = L['IconSize'],
							disabled = function() return not E.db.RLBox.OTHER.enable end,
							set = function(info, value)
								E.db.RLBox.OTHER[ info[#info] ] = value;
								E:GetModule('RLBox'):UpdateBoxUI(EUIRaidToolBox2, true)
							end,							
						},
						BarHeight = {
							order = 6,
							type = 'range',
							min = 2, max = 20, step = 1,
							name = L['BarHeight'],
							disabled = function() return (not E.db.RLBox.OTHER.enable) or (E.db.RLBox.UIType == 'icon') end,
							set = function(info, value)
								E.db.RLBox.OTHER[ info[#info] ] = value;
								E:GetModule('RLBox'):UpdateBoxUI(EUIRaidToolBox2, true)
							end,							
						},
						BarWidth = {
							order = 7,
							type = 'range',
							min = 5, max = 500, step = 1,
							name = L['BarWidth'],
							disabled = function() return (not E.db.RLBox.OTHER.enable) or (E.db.RLBox.UIType == 'icon') end,
							set = function(info, value)
								E.db.RLBox.OTHER[ info[#info] ] = value;
								E:GetModule('RLBox'):UpdateBoxUI(EUIRaidToolBox2, true)
							end,							
						},
						FontSize = {
							order = 8,
							type = 'range',
							min = 4, max = 30, step = 1,
							name = L["Font Size"],
							disabled = function() return not E.db.RLBox.OTHER.enable end,
							set = function(info, value)
								E.db.RLBox.OTHER[ info[#info] ] = value;
								E:GetModule('RLBox'):UpdateBoxUI(EUIRaidToolBox2, true)
							end,							
						},
						minperrow = {
							order = 9,
							type = 'range',
							min = 5, max = 20, step = 1,
							name = L['minperrow'],
							desc = L['minperrow_desc']..L["Bar Mode"],
							disabled = function() return (not E.db.RLBox.OTHER.enable) or (E.db.RLBox.UIType == 'icon') end,
						},	
						rownums = {
							order = 10,
							type = 'range',
							min = 1, max = 20, step = 1,
							name = L['perRow'],
							desc = L["Icon Mode"],
							disabled = function() return (not E.db.RLBox.DEFAULT.enable) or (E.db.RLBox.UIType == 'bar') end,
						},						
						selectSpell = {
							order = 11,
							name = L["Select Spell"],
							type = 'select',
							set = function(info, value) RLBox_EditSpell(value, E.global.RLBox.OTHER_SPELLS, "OTHER_SPELLS_GROUP", E.db.RLBox.OTHER.enable); end,
							disabled = function() return not E.db.RLBox.OTHER.enable end,
							values = function()
								local spells = {}
								for k, default in pairs(E.global.RLBox.OTHER_SPELLS) do
									local spellid = default[2]
									if GetSpellInfo(spellid) then
										spells[spellid] = GetSpellInfo(spellid)..'('..spellid..')';
									end
								end
								
								return spells
							end,
						},
					},
				},				
				MISC_SPELLS_GROUP = {
					order = 20,
					type = 'group',
					guiInline = false,
					name = L['EUIRaidToolBox3'],
					get = function(info) return E.db.RLBox.MISC[ info[#info] ] end,
					set = function(info, value) E.db.RLBox.MISC[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,					
					disabled = function() return not E.db.RLBox.enable end,
					args = {
						enable = {
							order = 1,
							type = 'toggle',
							name = L['Enable'],
						},
						resetSettings = {
							type = 'execute',
							order = 2,
							name = L['Restore Defaults'],
							func = function(info, value) wipe(E.global.RLBox.MISC_SPELLS); E:CopyTable(E.global.RLBox.MISC_SPELLS, G.RLBox.MISC_SPELLS); E:ResetMovers(L['EUIRaidToolBox3']); end,
						},						
						sendStartMsg = {
							order = 3,
							name = L['Send Cast Info'],
							type = "select",
							disabled = function() return not E.db.RLBox.MISC.enable end,
							values = {
								['NONE'] = NONE,
								['GUILD'] = GUILD,
								['PARTY'] = PARTY,
								['RAID'] = RAID,
								['RAID_WARNING'] = L['RW'],								
							},
						},
						sendEndMsg = {
							order = 4,
							name = L['Send Ready Info'],
							type = "select",
							disabled = function() return not E.db.RLBox.MISC.enable end,
							values = {
								['NONE'] = NONE,
								['GUILD'] = GUILD,
								['PARTY'] = PARTY,
								['RAID'] = RAID,
								['RAID_WARNING'] = L['RW'],								
							},
						},
						IconSize = {
							order = 5,
							type = 'range',
							min = 5, max = 50, step = 1,
							name = L['IconSize'],
							disabled = function() return not E.db.RLBox.MISC.enable end,
							set = function(info, value)
								E.db.RLBox.MISC[ info[#info] ] = value;
								E:GetModule('RLBox'):UpdateBoxUI(EUIRaidToolBox3, true)
							end,							
						},
						BarHeight = {
							order = 6,
							type = 'range',
							min = 2, max = 20, step = 1,
							name = L['BarHeight'],
							disabled = function() return (not E.db.RLBox.MISC.enable) or (E.db.RLBox.UIType == 'icon') end,
							set = function(info, value)
								E.db.RLBox.MISC[ info[#info] ] = value;
								E:GetModule('RLBox'):UpdateBoxUI(EUIRaidToolBox3, true)
							end,
						},
						BarWidth = {
							order = 7,
							type = 'range',
							min = 5, max = 500, step = 1,
							name = L['BarWidth'],
							disabled = function() return (not E.db.RLBox.MISC.enable) or (E.db.RLBox.UIType == 'icon') end,
							set = function(info, value)
								E.db.RLBox.MISC[ info[#info] ] = value;
								E:GetModule('RLBox'):UpdateBoxUI(EUIRaidToolBox3, true)
							end,							
						},
						FontSize = {
							order = 8,
							type = 'range',
							min = 4, max = 30, step = 1,
							name = L["Font Size"],
							disabled = function() return not E.db.RLBox.MISC.enable end,
							set = function(info, value)
								E.db.RLBox.MISC[ info[#info] ] = value;
								E:GetModule('RLBox'):UpdateBoxUI(EUIRaidToolBox3, true)
							end,							
						},
						minperrow = {
							order = 9,
							type = 'range',
							min = 5, max = 20, step = 1,
							name = L['minperrow'],
							desc = L['minperrow_desc']..L["Bar Mode"],
							disabled = function() return (not E.db.RLBox.MISC.enable) or (E.db.RLBox.UIType == 'icon') end,
						},	
						rownums = {
							order = 11,
							type = 'range',
							min = 1, max = 20, step = 1,
							name = L['perRow'],
							desc = L["Icon Mode"],
							disabled = function() return (not E.db.RLBox.DEFAULT.enable) or (E.db.RLBox.UIType == 'bar') end,
						},						
						addSpell = {
							order = 20,
							name = L['Add Spell'],
							type = 'execute',
							func = function(info, value) RLBox_Addspell() end,
							disabled = function() return not E.db.RLBox.MISC.enable end,
						},
						removeSpell = {
							order = 21,
							name = L['Remove Spell'],
							type = 'execute',
							func = function(info, value) RLBox_RemoveSpell()  end,
							disabled = function() return not E.db.RLBox.MISC.enable end,
						},
						selectSpell = {
							order = 22,
							name = L["Select Spell"],
							type = 'select',
							set = function(info, value) RLBox_EditSpell(value, E.global.RLBox.MISC_SPELLS, "MISC_SPELLS_GROUP", E.db.RLBox.MISC.enable); end,
							disabled = function() return not E.db.RLBox.MISC.enable end,
							values = function()
								local spells = {}
								for k, default in pairs(E.global.RLBox.MISC_SPELLS) do
									local spellid = default[2]
									if GetSpellInfo(spellid) then
										spells[spellid] = GetSpellInfo(spellid)..'('..spellid..')';
									end
								end
								
								return spells
							end,
						},
					},
				},		
			},
		},
	},
}


for k, v in pairs(E.db.euiscript.autosellList) do
	local _, link = GetItemInfo(k)
	E.Options.args.euiscript.args.euiscript_general.args.lootGroup.args.autosellList.values[k] = link or tostring(k)
end

if E.myclass ~= 'WARLOCK' then
	E.Options.args.euiscript.args.teleportie = nil;
end

-- for k, v in pairs(E.db.euiscript.executebutton.spellList[class]) do
	-- if v then
		-- E.Options.args.euiscript.args.executebutton.args['talent'..k] = {
			-- order = 6,
			-- name = "talent"--select(2, GetSpecializationInfo(k)),
			-- type = 'group',
			-- guiInline = false,
			-- args = {
				-- enabled = {
					-- order = 1,
					-- type = 'toggle',
					-- name = L['Enable'],
					-- get = function(info) return v.enabled end,
					-- set = function(info, value) v.enabled = value; E:GetModule('Execute'):Toggle() end,
				-- },
				-- spellid = {
					-- order = 2,
					-- name = L["Spell ID"],
					-- type = 'input',
					-- desc = GetSpellInfo(v.spellid) or '',
					-- get = function(info) return tostring(v.spellid) end,
					-- set = function(info, value)
						-- if not tonumber(value) or not GetSpellInfo(value) then
							-- E:Print(L["Not valid spell id"]);
							-- return;
						-- end
						-- v.spellid = tonumber(value); 
						-- E.Options.args.euiscript.args.executebutton.args['talent'..k].args.spellid.desc = GetSpellInfo(value);
						-- E:GetModule('Execute'):Toggle()
					-- end,
				-- },
				-- perc = {
					-- order = 3,
					-- name = L['Health'].. L['Percent'],
					-- get = function(info) return v.perc end,
					-- set = function(info, value) v.perc = value; E:GetModule('Execute'):Toggle() end,
					-- type = 'range',
					-- min = 1, max = 100, step = 1,
				-- },
			-- },
		-- }
	-- end
-- end

--赋值
for k, v in pairs(E.db.euiscript.autobutton.whiteList) do
	if type(k) == 'string' then k = tonumber(k) end
	if GetItemInfo(k) then
		E.Options.args.euiscript.args.autobutton.args.whiteList.values[k] = GetItemInfo(k);
	end
end
for k, v in pairs(E.db.euiscript.autobutton.blankList) do
	if type(k) == 'string' then k = tonumber(k) end
	if GetItemInfo(k) then
		E.Options.args.euiscript.args.autobutton.args.blankList.values[k] = GetItemInfo(k);
	end
end

for k, v in pairs(E.db.euiscript.autobuylist) do
	if GetItemInfo(k) then
		E.Options.args.euiscript.args.euiscript_autobuy.args.autobuyitemlist.values[k] = GetItemInfo(k)..'('..k..')';
	end
end

-- for k, v in pairs(P.euiscript.CharacterStatsList) do
	-- E.Options.args.euiscript.args.euiscript_general.args.uiGroup.args.CharacterStatsList.values[k] = L[k]
-- end

UpdateRaidCD_Spell();

local positionValues = {
	TOPLEFT = L['TOPLEFT'],
	LEFT = L['LEFT'],
	BOTTOMLEFT = L['BOTTOMLEFT'],
	RIGHT = L['RIGHT'],
	TOPRIGHT = L['TOPRIGHT'],
	BOTTOMRIGHT = L['BOTTOMRIGHT'],
	CENTER = L['CENTER'],
	TOP = L['TOP'],
	BOTTOM = L['BOTTOM'],
};

local selectedspell = 0
--[[
local function UpdateSAOGroup()
	if selectedspell == 0 or not E.db.sao['spells'][E.myclass][selectedspell] then
		E.Options.args.Watch.args.sao.args.spell.args.spellGroup = nil
		return
	end
	
	E.Options.args.Watch.args.sao.args.spell.args.spellGroup = {
		type = "group",
		name = GetSpellInfo(selectedspell),
		order = 15,
		guiInline = true,
		args = {
			enable = {
				order = 1,
				name = L["Enable"],
				type = "toggle",
				get = function() return E.db.sao['spells'][E.myclass][selectedspell].enable end,
				set = function(info, value) E.db.sao['spells'][E.myclass][selectedspell].enable = value; UpdateSAOGroup(); end
			},
			texture = {
				order = 2,
				name = L["Textures"], dialogControl = 'LSM30_Background',
				type = "select",
				get = function() return E.db.sao['spells'][E.myclass][selectedspell].texture end,
				set = function(info, value) E.db.sao['spells'][E.myclass][selectedspell].texture = value; UpdateSAOGroup(); end,
				disabled = function() return E.db.sao.useBuffIcon end,
				values = LibStub("LibSharedMedia-3.0"):HashTable("sao"),
			},
			position = {
				order = 3,
				name = L['Position'],
				type = "select",
				get = function() return E.db.sao['spells'][E.myclass][selectedspell].position end,
				set = function(info, value) E.db.sao['spells'][E.myclass][selectedspell].position = value; UpdateSAOGroup(); end,
				values = positionValues,
			},
			offsetX = {
				order = 4,
				type = 'range',
				name = L['X Offset'],
				min = -800, max = 800, step = 1,
				get = function() return E.db.sao['spells'][E.myclass][selectedspell].offsetX end,
				set = function(info, value) E.db.sao['spells'][E.myclass][selectedspell].offsetX = value; UpdateSAOGroup(); end,
			},
			offsetY = {
				order = 5,
				type = 'range',
				name = L['Y Offset'],
				min = -600, max = 600, step = 1,
				get = function() return E.db.sao['spells'][E.myclass][selectedspell].offsetY end,
				set = function(info, value) E.db.sao['spells'][E.myclass][selectedspell].offsetY = value; UpdateSAOGroup(); end,
			},			
		},				
	}	
end

E.Options.args.Watch.args.sao = {
	type = 'group',
	name = '04.'..E.ValColor..L['Display spell trigger graphics prompt'].."|r",
--	childGroups = 'tree',
	order = 4,
	get = function(info) return E.db.sao[ info[#info] ] end,
	set = function(info, value) E.db.sao[ info[#info] ] = value end,
	args = {
		enable = {
			order = 1,
			type = 'toggle',
			name = L['Enable'],
			set = function(info, value) 
				E.db.sao.enable = value; 
				if value then SetCVar('displaySpellActivationOverlays', 1) end
				E:StaticPopup_Show("CONFIG_RL") 
			end,
		},
		general = {
			order = 2,
			type = 'group',
			name = L["General"],
			guiInline = true,
			disabled = function() return not E.db.sao.enable end,
			args = {
				onlyTime = {
					order = 3,
					type = 'select',
					name = L['Text Format'],
					values = {
						['no'] = NONE,
						['time'] = L['Remaining Time'],
						['name'] = L["Show spell name:"].. L['Remaining Time'],
					},
				},
				offsetX = {
					order = 4,
					type = 'range',
					name = L['X Offset'],
					min = -800, max = 800, step = 1,
				},
				offsetY = {
					order = 5,
					type = 'range',
					name = L['Y Offset'],
					min = -600, max = 600, step = 1,
				},					
				fontSize = {
					order = 6,
					type = 'range',
					name = L["Font Size"],
					min = 5, max = 50, step = 1,
				},
			},
		},
		useIcon = {
			order = 6,
			type = 'group',
			name = L['useIcon style'],
			guiInline = true,
			disabled = function() return not E.db.sao.enable end,
			args = {
				useIcon = {
					order = 1,
					type = 'toggle',
					name = L['useIcon style'],
					set = function(info, value) E.db.sao.useIcon = value; E.db.sao.useBuffIcon = value; end,
				},
				useBuffIcon = {
					order = 7,
					type = 'toggle',
					name = L['use Buff Icon'],
					disabled = function() return not E.db.sao.useIcon end,
				},
				iconSize = {
					order = 8,
					type = 'range',
					name = L["Icon Size"],
					min = 10, max = 100, step = 1,
					disabled = function() return not E.db.sao.useIcon end,
				},
				iconGap = {
					order = 9,
					type = 'range',
					name = L['X Spacing'],
					min = 1, max = 20, step = 1,
					disabled = function() return not E.db.sao.useIcon end,
				}, 			
			},
		},
		spell = {
			order = 100,
			type = 'group',
			name = L['Spells'],
			guiInline = true,
			disabled = function() return not E.db.sao.enable end,
			args = {
				addSpell = {
					order = 1,
					name = L['Add Spell']..'ID',
					desc = L['Add a spell to the filter.'],
					type = 'input',
					get = function(info) return "" end,
					set = function(info, value) 
						if not tonumber(value) or not GetSpellInfo(tonumber(value)) then return; end
						if not E.db.sao['spells'][E.myclass][tonumber(value)] then
							E.db.sao['spells'][E.myclass][tonumber(value)] = { 
								['texture'] = 'FURY_OF_STORMRAGE',
								['position'] = 'TOP',
								['showing'] = false,
								['active'] = false,
								['enable'] = true,
								['offsetX'] = 0,
								['offsetY'] = 0,
							}
						end
						UpdateSAOGroup();
					end,					
				},
				removeSpell = {
					order = 2,
					name = L['Remove Spell']..'ID',
					desc = L['Remove a spell from the filter.'],
					type = 'input',
					get = function(info) return "" end,
					set = function(info, value) 
						if P['sao']['spells'][E.myclass] then
							if P['sao']['spells'][E.myclass][tonumber(value)] then
								E.db.sao['spells'][E.myclass][tonumber(value)].enable = false;
								E:Print(L['You may not remove a spell from a default filter that is not customly added. Setting spell to false instead.'])
							else
								E.db.sao['spells'][E.myclass][tonumber(value)] = nil;
							end
						else
							E.db.sao['spells'][E.myclass][tonumber(value)] = nil;
						end
						
						UpdateSAOGroup();
					end,				
				},		
				selectSpell = {
					name = L["Select Spell"],
					type = 'select',
					order = 0,
					get = function(info) return selectedspell end,
					set = function(info, value) selectedspell = value; UpdateSAOGroup() end,							
					values = function()
						local spells = {}
						spells[0] = NONE
						for k in pairs(E.db.sao['spells'][E.myclass]) do
							if type(k) == 'number' and GetSpellInfo(k) then
								spells[k] = GetSpellInfo(k)..'( '..k..' )'
							end
						end

						return spells
					end,
				},				
			},
		},
	},
}

]]

local DeleteChoisedToggle = false;
local DeleteAllToggle = false;

E.Options.args.InfoFilter = {
	type = "group",
	name = '16.'..L["InfoFilter"],
	get = function(info) return E.global.InfoFilter[ info[#info] ] end,
	set = function(info, value) E.global.InfoFilter[ info[#info] ] = value; end,
	args = {
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.global.InfoFilter.enable = value;
				E:StaticPopup_Show("CONFIG_RL");
			end,
		},
		InfoFilter_general = {
			order = 2,
			type = "group",
			name = L["General"],
			guiInline = true,
			disabled = function() return not E.global.InfoFilter.enable end,
			args = {
				Debug = {
					order = 1,
					type = "toggle",
					name = L["debug"],
				},
				matchNum = {
					order = 2,
					type = "range",
					name = L["Keywords Match Number"],
					min = 1, max = 10, step = 1,
				},
				rtNum = {
					order = 3,
					type = 'range',
					min = 0, max = 8, step = 1,
					name = L['rt char filter'],
					desc = L['rt char filter desc'],
				},
				filterFriend = {
					order = 4,
					type = "toggle",
					name = L["filterFriend"],
					desc = L["filter Friend desc"],
				},
				nowhisperSticky = {
					order = 5,
					type = "toggle",
					name = L["No whisperSticky"],
					set = function(info, value)
						E.global.InfoFilter.nowhisperSticky = value;
						if value then
							ChatTypeInfo.WHISPER.sticky = 0
							ChatTypeInfo.BN_WHISPER.sticky = 0
						else
							ChatTypeInfo.WHISPER.sticky = 1
							ChatTypeInfo.BN_WHISPER.sticky = 1
						end
					end,
				},
				profanityFilter = {
					order = 6,
					type = "toggle",
					name = L["Disable profanityFilter"],
					set = function(info, value)
						E.global.InfoFilter.profanityFilter = value;
						if value then
							SetCVar("profanityFilter", "0");
						else
							SetCVar("profanityFilter", "1");
						end
					end,
				},
				level = {
					order = 7,
					type = 'range',
					min = 0, max = MAX_PLAYER_LEVEL-1, step = 1,
					name = L["Allow send whisper player's level"],
					desc = L["Level is 0 to disable!"],
					set = function(info, value)
						if E.global.InfoFilter.level < 1 and value >= 1 then
							E.global.InfoFilter.level = value;
							E:StaticPopup_Show("CONFIG_RL");
						end
						if E.global.InfoFilter.level >= 1 and value < 1 then
							E.global.InfoFilter.level = value;
							E:StaticPopup_Show("CONFIG_RL");
						end
						E.global.InfoFilter.level = value;
					end,
				},
				repeatTime = {
					order = 8,
					type = 'range',
					min = 0, max = 100, step = 1,
					name = L['Repeat time(s)'],
					desc = L['Repeated statements within how many seconds of the filter\nSet to 0 to disable.'],
				},
			},
		},
		blackList = {
			order = 3,
			type = "group",
			name = L["Word BlackList"],
			guiInline = true,
			disabled = function() return not E.global.InfoFilter.enable end,
			args = {
				intro = {
					order = 0,
					type = "description",
					name = L["Word BlackList intro"],
				},
				NewWord = {
					order = 1,
					type = "input",
					name = L["New Word"],
					get = function(info) return "" end,
					set = function(info, value)
						E.global.InfoFilter.blackList[value] = true
						E.Options.args.InfoFilter.args.blackList.args.List.values[value] = value;
					end,
				},
				DeleteWord = {
					order = 2,
					type = "input",
					name = L["Delete Word"],
					get = function(info) return "" end,
					set = function(info, value)
						if E.global.InfoFilter.blackList[value] ~= nil then
							E.global.InfoFilter.blackList[value] = nil
							E.Options.args.InfoFilter.args.blackList.args.List.values[value] = nil
						end
					end,
				},
				spacer = {
					order = 3,
					type = 'description',
					name = '',
				},				
				--local DeleteChoisedToggle = false;
				--local DeleteAllToggle = false;
				DeleteChoised = {
					order = 4,
					type = "execute",
					name = L["Delete choised keywords"],
					func = function()
						if not DeleteChoisedToggle then
							DeleteChoisedToggle = true;
							E.Options.args.InfoFilter.args.blackList.args.DeleteChoised.name = L["Delete choised keywords, Yes?"];
							C_Timer.After(5, function()
								DeleteChoisedToggle = false;
								E.Options.args.InfoFilter.args.blackList.args.DeleteChoised.name = L["Delete choised keywords"];
							end)
						else						
							for k, v in pairs(E.global.InfoFilter.blackList) do
								if v then
									E.global.InfoFilter.blackList[k] = nil;
								end
							end
							DeleteChoisedToggle = false;
							E.Options.args.InfoFilter.args.blackList.args.DeleteChoised.name = L["Delete choised keywords"];
							wipe(E.Options.args.InfoFilter.args.blackList.args.List.values);
							for k, v in pairs(E.global.InfoFilter.blackList) do
								E.Options.args.InfoFilter.args.blackList.args.List.values[k] = k
							end
						end
					end,
				},
				DeleteAll = {
					order = 5,
					type = "execute",
					name = L["Delete all keywords"],
					func = function()
						if not DeleteAllToggle then
							DeleteAllToggle = true;
							E.Options.args.InfoFilter.args.blackList.args.DeleteAll.name = L["Delete all keywords, Yes?"];
							C_Timer.After(5, function()
								DeleteAllToggle = false;
								E.Options.args.InfoFilter.args.blackList.args.DeleteAll.name = L["Delete all keywords"];
							end)							
						else						
							wipe(E.global.InfoFilter.blackList);
							wipe(E.Options.args.InfoFilter.args.blackList.args.List.values);
							DeleteAllToggle = false;
							E.Options.args.InfoFilter.args.blackList.args.DeleteAll.name = L["Delete all keywords"];
						end
					end,
				},				
				List = {
					order = 10,
					type = "multiselect",
					name = L["BlackList"],
					get = function(info, k) return E.global.InfoFilter.blackList[k] end,
					set = function(info, k, v)
						E.global.InfoFilter.blackList[k] = v
					end,
					values = {
					},
				},
			},
		},
		blackName = {
			order = 4,
			type = "group",
			name = L["sender blacklist"],
			guiInline = true,
			disabled = function() return not E.global.InfoFilter.enable end,
			args = {
				intro = {
					order = 0,
					type = "description",
					name = L["sender blacklist intro"],
				},
				NewWord = {
					order = 1,
					type = "input",
					name = L["New Word"],
					get = function(info) return "" end,
					set = function(info, value)
						E.global.InfoFilter.blackName[value] = value
					end,
				},
				DeleteWord = {
					order = 2,
					type = "input",
					name = L["Delete Word"],
					get = function(info) return "" end,
					set = function(info, value)
						if E.global.InfoFilter.blackName[value] ~= nil then
							E.global.InfoFilter.blackName[value] = nil
						end
					end,
				},
				Reset = {
					order = 3,
					type = "execute",
					name = L['Restore Defaults'],
					func = function() wipe(E.global.InfoFilter.blackName); E:StaticPopup_Show("CONFIG_RL") end,
				},
				List = {
					order = 4,
					type = "multiselect",
					name = L["sender blacklist"],
					get = function(info, k) return E.global.InfoFilter.blackName[k] end,
					set = function(info, k, v)
						E.global.InfoFilter.blackName[k] = v
					end,
					values = {
					},
				},
			},
		},			
	},
}

for k, v in pairs(E.global.InfoFilter.blackName) do
	E.Options.args.InfoFilter.args.blackName.args.List.values[k] = k
end	

for k, v in pairs(E.global.InfoFilter.blackList) do
	E.Options.args.InfoFilter.args.blackList.args.List.values[k] = k
end

if E.zhlocale then
	local QASTRING = ''
	for i = 1, 200 do
		if L["Q"..i] == tostring("Q"..i) then break end
		QASTRING = QASTRING ..'\n\n'..E.ValColor..L["Q"..i]..'|r'..'\n'..L["A"..i]
	end

	E.Options.args.QA = {
		type = "group",
		name = E.ValColor..L["Q&A"].."|r",
		order = -2,
		args = {
			text = {
				order  = 1,
				type = "description",
				name = QASTRING,
				fontSize = 'medium',
			},
		},
	}
end

local UF = E:GetModule('UnitFrames');

E.Options.args.Watch.args.aurabar = {
	type = "group",
	name = '01.'.. E.ValColor.. L["Aura Bars"].. "|r",
	order = 1,
	childGroups = "tab",
	args = {	
		player = {
			order = 1,
			type = 'group',
			name = L['Player Frame'],
			guiInline = false,
			get = function(info) return E.db.unitframe.units['player']['aurabar'][ info[#info] ] end,
			set = function(info, value) E.db.unitframe.units['player']['aurabar'][ info[#info] ] = value; UF:CreateAndUpdateUF('player') end,
			args = E.Options.args.unitframe.args.player.args.aurabar.args,
		},
		target = {
			order = 2,
			type = 'group',
			name = L['Target Frame'],
			get = function(info) return E.db.unitframe.units['target']['aurabar'][ info[#info] ] end,
			set = function(info, value) E.db.unitframe.units['target']['aurabar'][ info[#info] ] = value; UF:CreateAndUpdateUF('target') end,
			args = E.Options.args.unitframe.args.target.args.aurabar.args,
		},		
	},
}

E.Options.args.Watch.args.CooldownFlash = {	
	type = "group",
	name = '05.'.. L["Middle CD Reminder"],
	get = function(info) return E.db.CooldownFlash[ info[#info] ] end,
	set = function(info, value) E.db.CooldownFlash[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,		
	order = 4,
	args = {
		desc = {
			order = 1,
			name = L["Middle CD Reminder Module, Blink spell icon at middle of screen when spell CD."],
			type = "description",
		},
		enable = {
			order = 2,
			name = L['Enable'],
			type = 'toggle',
		},
		iconSize = {
			order = 5,
			name = L["Icon size"],
			type = "range",
			min = 30, max = 125, step = 1,
			set = function(info, value) E.db.CooldownFlash[ info[#info] ] = value; DCP:SetSize(value, value) end,
			disabled = function() return not E.db.CooldownFlash.enable end,
		},
		fadeInTime = {
			order = 6,
			name = L["Fadein duration"],
			type = "range",
			min = 0, max = 2.5, step = 0.1,
			disabled = function() return not E.db.CooldownFlash.enable end,
		},
		fadeOutTime = {
			order = 7,
			name = L["Fadeout duration"],
			type = "range",
			min = 0, max = 2.5, step = 0.1,
			disabled = function() return not E.db.CooldownFlash.enable end,
		},
		maxAlpha = {
			order = 8,
			name = L["Max transparent"],
			type = "range",
			min = 0, max = 1, step = 0.05,
			isPercent = true,
			disabled = function() return not E.db.CooldownFlash.enable end,
		},
		holdTime = {
			order = 9,
			name = L["Duration time"],
			type = "range",
			min = 0, max = 2.5, step = 0.1,
			disabled = function() return not E.db.CooldownFlash.enable end,
		},
		animScale = {
			order = 10,
			name =  L["Animation size"],
			type = "range",
			min = 0, max = 2, step = 0.1,
			disabled = function() return not E.db.CooldownFlash.enable end,
		},
		showSpellName = {
			order = 11,
			name = L["Display spell name"],
			type = "toggle",
			disabled = function() return not E.db.CooldownFlash.enable end,
		},
		enablePet = {
			order = 12,
			name = L["Watch on pet spell"],
			type = "toggle",
			get = function(info) return E.db.CooldownFlash[ info[#info] ] end,
			set = function(info, value)
				E.db.CooldownFlash[ info[#info] ] = value
				if value then
					DCP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
				else
					DCP:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
				end
			end,
			disabled = function() return not E.db.CooldownFlash.enable end,
		},
		ignoredSpells = {
			order = 13,
			name = L['Blacklist'],
			desc = L["Note: Separate multiple spells with commas"],
			type = 'input',
			width = 'full',
			get = function(info) return E.db.CooldownFlash.ignoredSpells; end,
			set = function(info, value)
				E.db.CooldownFlash.ignoredSpells = string.gsub(value, '，', ',');
				if not DCP.ignoredSpells then DCP.ignoredSpells = {} end
				wipe(DCP.ignoredSpells)
				for _,v in ipairs({strsplit(",",E.db.CooldownFlash.ignoredSpells)}) do
					DCP.ignoredSpells[strtrim(v)] = true
				end
			end,
		},
	},
}

--Support MySlot
local function RefreshProfileList()
	wipe(E.Options.args.actionbar.args.myslot.args.profileList.values)
	for name in pairs(E.db.Myslot.sets) do
		E.Options.args.actionbar.args.myslot.args.profileList.values[name] = name;
	end
end

local PROFILENAME, PROFILENAME2 = '', '';
local delIt = 0;
E.Options.args.actionbar.args.myslot = {
	order = 100,
	name = L["MySlot Support"],
	type = "group",
	guiInline = true,
	disabled = function() return not IsAddOnLoaded('MySlot') end,
	args = {
		profileName = {
			order = 0,
			name = L['profileName'],
			type = 'input',
			get = function() return PROFILENAME; end,
			set = function(info, value) PROFILENAME = value; end,
		},
		spacer = {
			type = 'description',
			name = '',
			order = 1,
		},
		saveProfile = {
			order = 2,
			name = L['save profile'],
			type = 'execute',
			width = 'double',			
			func = function()
				if not E:IsConfigurableAddOn('MySlot') then return; end
				E:MySlotExport(PROFILENAME);
				RefreshProfileList();
				if E.db.Myslot.sets[PROFILENAME] then
					E:Print(PROFILENAME..L[' profile saved!'])
				end
			end,
		},
		spacer2 = {
			type = 'description',
			name = '',
			order = 3,
		},
		profileList = {
			order = 4,
			name = L['profile list'],
			type = 'select',
			values = {},
			get = function() return PROFILENAME2; end,
			set = function(info,value) PROFILENAME2 = value; end,
		},
		importProfile = {
			order = 5,
			name = L['import profile'],
			type = 'execute',
			func = function()
				if not E:IsConfigurableAddOn('MySlot') then return; end
				E:MySlotImport(PROFILENAME2);
				E:ToggleOptionsUI();
			end,
		},
		delProfile = {
			order = 6,
			name = L['delete profile'],
			type = 'execute',
			func = function()
				delIt = delIt + 1;
				if delIt == 1 then
					E.Options.args.actionbar.args.myslot.args.delProfile.name = L['|cff00ff00delete profile, Yes!|r'];
				elseif delIt == 2 then
					E.db.Myslot.sets[PROFILENAME2] = nil;
					RefreshProfileList();
					delIt = 0;
					E.Options.args.actionbar.args.myslot.args.delProfile.name = L['delete profile'];
				end
			end,
		},	
		showMyslot = {
			order = 7,
			name = L['Show Myslot'],
			type = 'execute',
			func = function() MYSLOT_ReportFrame:Show();E:ToggleOptionsUI(); end,
		},
	},
}

RefreshProfileList();