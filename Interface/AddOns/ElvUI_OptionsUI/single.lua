local E, L, V, P, G, _ = unpack(ElvUI); --Engine

local AD = LibStub('AceAddon-3.0')
local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
local IsAddOnLoaded = IsAddOnLoaded
local SetCVar = SetCVar
local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory
local ENABLE, DISABLE = ENABLE, DISABLE

local convertAddonName = {
	["HandyNotes_DungeonLocations"] = "HandyNotes_DungeonLocations (Classic)",
	["HandyNotes_NPCs"] = "HandyNotes_NPCs (Classic)",
	["AuctionLite"] = "AuctionLite-classic",
}
local function ToggleAddOnMsg(info, value)
	if not value then
		E:StaticPopup_Show("CONFIG_RL");
	else
		info = info and convertAddonName[info] or info
		EnableAddOn(info)
		LoadAddOn(info)
	end
end

E.Options.args.singleFunc = {
	type = "group",
	name = '17.|cfffe7b2c'..L['singleFunc']..'|r',
	desc = L['singleFunc desc'],
	childGroups = 'tab',
	get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
	set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
	args = {
		Map = {
			order = 1,
			type = 'group',
			name = L["World Map"],
			guiInline = false,
			args = {
				HandyNotes_DungeonLocations = {
					order = 1,
					type = "group",
					name = L["HandyNotes_DungeonLocations"],
					guiInline = false,
					args = {
						HandyNotes_DungeonLocations = {
							order = 1,
							type = 'toggle',
							name = L["HandyNotes_DungeonLocations"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["HandyNotes_DungeonLocations"],
							disabled = function() return not E:IsConfigurableAddOn('HandyNotes_DungeonLocations (Classic)'); end,
						},
						ShowHandyNotes_DungeonLocationsCfg = {
							order = 2,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('HandyNotes_DungeonLocations (Classic)'); end,
							func = function()
								LibStub("AceConfigDialog-3.0"):Open("HandyNotes");
								E:ToggleOptionsUI();
							end,
						},
					}
				},
				HandyNotes_NPCs = {
					order = 2,
					type = "group",
					name = L["HandyNotes_NPCs"],
					guiInline = false,
					args = {
						HandyNotes_NPCs = {
							order = 1,
							type = 'toggle',
							name = L["HandyNotes_NPCs"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["HandyNotes_NPCs"],
							disabled = function() return not E:IsConfigurableAddOn('HandyNotes_NPCs (Classic)'); end,
						},
						ShowHandyNotes_NPCsCfg = {
							order = 2,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('HandyNotes_NPCs (Classic)'); end,
							func = function()
								LibStub("AceConfigDialog-3.0"):Open("HandyNotes");
								E:ToggleOptionsUI();
							end,
						},
					}
				},
				GatherMate2 = {
					order = 2,
					type = "group",
					name = L["GatherMate2"],
					guiInline = false,
					args = {
						GatherMate2 = {
							order = 1,
							type = 'toggle',
							name = L["GatherMate2"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["GatherMate2"],
							disabled = function() return not E:IsConfigurableAddOn('GatherMate2'); end,
						},
						ShowGatherMate2Cfg = {
							order = 2,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('GatherMate2'); end,
							func = function()
								InterfaceOptionsFrame_OpenToCategory("GatherMate 2")
								InterfaceOptionsFrame_OpenToCategory("GatherMate 2")
								E:ToggleOptionsUI();
							end,
						},
					}
				},
				Mapster = {
					order = 3,
					type = "group",
					name = L['Mapster'],
					guiInline = false,
					args = {
						Mapster = {
							order = 1,
							type = 'toggle',
							name = L["Mapster"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["Mapster"],
							disabled = function() return not E:IsConfigurableAddOn('Mapster'); end,
						},
						ZoneInfo = {
							order = 2,
							type = 'toggle',
							name = L['Show Zone Info'],
							disabled = function() return not IsAddOnLoaded('Mapster'); end,
							get = function(info) return E.db.euiscript.ZoneInfo; end,
							set = function(info, value)
								E.db.euiscript.ZoneInfo = value;
								local ZoneInfoClassic = LibStub("AceAddon-3.0"):GetAddon("ZoneInfoClassic")
								if value then ZoneInfoClassic:OnEnable() else ZoneInfoClassic:OnDisable() end
							end,
						},
						ShowMapsterFrame = {
							order = 3,
							type = 'execute',
							name = L['Show Mapster Frame'],
							disabled = function() return not IsAddOnLoaded('Mapster'); end,
							func = function()
								local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
								if Mapster and Mapster.optionsFrames then
									InterfaceOptionsFrame_OpenToCategory(Mapster.optionsFrames.Profiles)
									InterfaceOptionsFrame_OpenToCategory(Mapster.optionsFrames.Mapster)
									E:ToggleOptionsUI();
								end
							end,
						},
					}
				},
				SilverDragon = {
					order = 4,
					type = "group",
					name = L['SilverDragon'],
					guiInline = false,
					args = {
						SilverDragon = {
							order = 1,
							type = 'toggle',
							name = L["SilverDragon"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["SilverDragon"],
							disabled = function() return not E:IsConfigurableAddOn('SilverDragon'); end,
						},
						ShowSilverDragonFrame = {
							order = 2,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('SilverDragon'); end,
							func = function()
								LibStub("AceConfigDialog-3.0"):Open("SilverDragon")
								E:ToggleOptionsUI();
							end,
						},
					}
				},
			},
		},
		quest = {
			order = 2,
			name = L["Quest Frames"],
			type = 'group',
			guiInline = false,
			args = {
				ClassicCodex = {
					order = 1,
					type = "group",
					name = L["ClassicCodex"],
					guiInline = false,
					args = {
						ClassicCodex = {
							order = 1,
							type = 'toggle',
							name = L["ClassicCodex"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["ClassicCodex"],
							disabled = function() return not E:IsConfigurableAddOn('ClassicCodex'); end,
						},
						ClassicCodexShowNameplateIcon = {
							order = 2,
							type = 'toggle',
							name = L["ClassicCodex"],
							desc = L["Enable/Disable"]..L["ClassicCodex"],
							disabled = function() return not E:IsConfigurableAddOn('ClassicCodex'); end,
							set = function(info, value) CodexConfig.nameplateIcon = value; end,
							get = function(info) return CodexConfig.nameplateIcon end,
						},
						ShowClassicCodexFrame = {
							order = 3,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('ClassicCodex'); end,
							func = function()
								if codexConfig then
									InterfaceOptionsFrame_OpenToCategory(codexConfig)
									InterfaceOptionsFrame_OpenToCategory(codexConfig)
									E:ToggleOptionsUI();
								end
							end,
						},
					}
				},
				ButterQuestTracker = {
					order = 2,
					type = "group",
					name = L["ButterQuestTracker"],
					guiInline = false,
					args = {
						ButterQuestTracker = {
							order = 1,
							type = 'toggle',
							name = L["ButterQuestTracker"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["ButterQuestTracker"],
							disabled = function() return not E:IsConfigurableAddOn('ButterQuestTracker'); end,
						},
						ShowButterQuestTrackerFrame = {
							order = 3,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('ButterQuestTracker'); end,
							func = function()
								if ButterQuestTracker then
									InterfaceOptionsFrame:Show();
									InterfaceOptionsFrame_OpenToCategory("ButterQuestTracker");
									E:ToggleOptionsUI();
								end
							end,
						},
					}
				},
			},
		},
		combat = {
			order = 3,
			type = 'group',
			name = L['Combat']..'&'.._G.RAID,
			guiInline = false,
			args = {
				MikScrollingBattle = {
					order = 1,
					type = "group",
					name = L["MikScrollingBattleText"],
					guiInline = false,
					args = {
						MikScrollingBattleText = {
							order = 1,
							type = 'toggle',
							name = L["MikScrollingBattleText"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["MikScrollingBattleText"],
							disabled = function() return not E:IsConfigurableAddOn('MikScrollingBattleText'); end,
						},
						UseEUINumberFormat = {
							order= 2,
							type = 'toggle',
							name = L["Use Eui's number format"],
							get = function() return MikSBT and MikSBT.Profiles.currentProfile.groupNumbers or false; end,
							set = function(info, value) if MikSBT then MikSBT.Profiles.currentProfile.groupNumbers = value; end; end,
							disabled = function() return not E:IsConfigurableAddOn('MikScrollingBattleText'); end,
						},
						ShowMSBTOpt = {
							order = 3,
							type = 'execute',
							name = L['Show MikScrollingBattleText Config'],
							disabled = function() return not IsAddOnLoaded('MikScrollingBattleText'); end,
							func = function()
								if E:IsDisabledAddon('MSBTOptions') then
									EnableAddOn('MSBTOptions')
									E:StaticPopup_Show("CONFIG_RL");
								end
								if (not IsAddOnLoaded('MSBTOptions')) then
									LoadAddOn('MSBTOptions');
								end
								if (IsAddOnLoaded('MSBTOptions')) then
									MSBTOptions.Main.ShowMainFrame();
									E:ToggleOptionsUI();
								end
							end,
						},
					}
				},
				DBM = {
					order = 2,
					type = "group",
					name = L['DBM-Core'],
					guiInline = false,
					args = {
						ShowDBMOpt = {
							order = 1,
							type = 'execute',
							name = L['Show Config'],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							disabled = function() return not IsAddOnLoaded('DBM-Core'); end,
							func = function()
								DBM:LoadGUI();
								E:ToggleOptionsUI();
							end,
						},
						TestDBMSound = {
							order = 2,
							type = 'execute',
							name = L['Test DBM Sound'],
							disabled = function() return not IsAddOnLoaded('DBM-Core'); end,
							func = function()
								if E:IsConfigurableAddOn('DBM-Core') then
									DBM:DemoMode();
									E:ToggleOptionsUI();
								end
							end,
						},
					}
				},
				Recount = {
					order = 3,
					type = "group",
					name = L['Recount'],
					guiInline = false,
					args = {
						Recount = {
							order = 1,
							type = 'toggle',
							name = L["Recount"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["Recount"],
							disabled = function() return not E:IsConfigurableAddOn('Recount'); end,
						},
						ShowRecountConfig = {
							order = 2,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('Recount'); end,
							func = function()
								local AceConfigDialog = LibStub("AceConfigDialog-3.0")
								InterfaceOptionsFrame:Hide()
								AceConfigDialog:SetDefaultSize("Recount", 500, 550)
								AceConfigDialog:Open("Recount")
								E:ToggleOptionsUI();
							end,
						},
						ResetRecountProfile = {
							order = 3,
							type = 'execute',
							name = L['Reset Recount Profile'],
							disabled = function() return not IsAddOnLoaded('Recount'); end,
							func = function()
								if Recount then
									Recount:ResetData();
									E:ToggleOptionsUI();
								end
							end,
						},
						ShowRecountFrame = {
							order = 4,
							type = 'execute',
							name = L['Show Recount Window'],
							disabled = function() return not IsAddOnLoaded('Recount'); end,
							func = function()
								if Recount then
									Recount.MainWindow:Show()
									Recount:RefreshMainWindow()
									E:ToggleOptionsUI();
								end
							end,
						},
					}
				},
				GSE = {
					order = 5,
					type = "group",
					name = L['GSE'],
					guiInline = false,
					args = {
						GSE = {
							order = 1,
							type = 'toggle',
							name = L["GSE"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["GSE"],
							disabled = function() return not E:IsConfigurableAddOn('GSE'); end,
						},
						CreateMacroButton = {
							order = 2,
							type = 'execute',
							name = L["Create Macro"],
							func = function()
								if GSE then
									GSE.GUIShowViewer()
									E:ToggleOptionsUI();
								end;
							end,
						},
						ShowGSEFrame = {
							order = 3,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('GSE'); end,
							func = function()
								if GSE then
									GSE.OpenOptionsPanel()
									E:ToggleOptionsUI();
								end
							end,
						},
					}
				},
				WeaponSwingTimer = {
					order = 6,
					type = "group",
					name = L['WeaponSwingTimer'],
					guiInline = false,
					args = {
						WeaponSwingTimer = {
							order = 1,
							type = 'toggle',
							name = L["WeaponSwingTimer"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["WeaponSwingTimer"],
							disabled = function() return not E:IsConfigurableAddOn('WeaponSwingTimer'); end,
						},
						ShowWSFrame = {
							order = 2,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('WeaponSwingTimer'); end,
							func = function()
								InterfaceOptionsFrame_OpenToCategory("WeaponSwingTimer")
								InterfaceOptionsFrame_OpenToCategory("WeaponSwingTimer")
								E:ToggleOptionsUI();
							end,
						},
					}
				},
				ClassicThreatMeter = {
					order = 7,
					type = "group",
					name = L['ClassicThreatMeter'],
					guiInline = false,
					args = {
						ClassicThreatMeter = {
							order = 1,
							type = 'toggle',
							name = L["ClassicThreatMeter"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["ClassicThreatMeter"],
							disabled = function() return not E:IsConfigurableAddOn('ClassicThreatMeter'); end,
						},
						ShowClassicThreatMeterFrame = {
							order = 2,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('ClassicThreatMeter'); end,
							func = function()
								LibStub("AceConfigDialog-3.0"):Open("ClassicThreatMeter")
								E:ToggleOptionsUI();
							end,
						},
					}
				},
				WebDKP = {
					order = 8,
					type = "group",
					name = L['WebDKP'],
					guiInline = false,
					args = {
						WebDKP = {
							order = 1,
							type = 'toggle',
							name = L["WebDKP"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["WebDKP"],
							disabled = function() return not E:IsConfigurableAddOn('WebDKP'); end,
						},
						ShowClassicThreatMeterFrame = {
							order = 2,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('WebDKP'); end,
							func = function()
								WebDKP_ToggleGUI()
								E:ToggleOptionsUI()
							end,
						},
					}
				},
				ExRT = {
					order = 9,
					type = "group",
					name = L['ExRT'],
					guiInline = false,
					args = {
						ExRT = {
							order = 1,
							type = 'toggle',
							name = L["ExRT"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["ExRT"],
							disabled = function() return not E:IsConfigurableAddOn('ExRT'); end,
						},
						ShowExRTFrame = {
							order = 2,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('ExRT'); end,
							func = function()
								if ExRT and ExRT.Options then
									ExRT.Options:Open()
									E:ToggleOptionsUI()
								end
							end,
						},
					}
				},
			},
		},
		ui = {
			order = 6,
			type = 'group',
			name = L['About UI'],
			guiInline = false,
			args = {
				OfflineDataCenter = {
					order = 1,
					type = "group",
					name = L['OfflineDataCenter'],
					guiInline = false,
					args = {
						OfflineDataCenter = {
							order = 1,
							type = 'toggle',
							name = L["OfflineDataCenter"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["OfflineDataCenter"],
							disabled = function() return not E:IsConfigurableAddOn('OfflineDataCenter'); end,
						},
						ShowODCFrame = {
							order = 2,
							type = 'execute',
							name = L['Show OfflineDataCenter Frame'],
							disabled = function() return not IsAddOnLoaded('OfflineDataCenter'); end,
							func = function()
								AD:GetAddon("OfflineDataCenter"):ToggleWindow();
								E:ToggleOptionsUI();
							end,
						},
						ShowODCCfg = {
							order = 3,
							type = 'execute',
							name = L['Show OfflineDataCenter Config Frame'],
							disabled = function() return not IsAddOnLoaded('OfflineDataCenter'); end,
							func = function()
								local ODC = LibStub("AceAddon-3.0"):GetAddon("OfflineDataCenter")
								if ODC then
									ODC:GetModule("Setting"):CreateOrShowSubFrame("settings");
									ODCFrameSettingSubFrame.configdialog:Click();
									E:ToggleOptionsUI();
								end
							end,
						},
					}
				},
				MerInspect = {
					order = 2,
					type = "group",
					name = L['MerInspect'],
					guiInline = false,
					args = {
						MerInspect = {
							order = 1,
							type = 'toggle',
							name = L["MerInspect"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["MerInspect"],
							disabled = function() return not E:IsConfigurableAddOn('MerInspect'); end,
						},
						MerInspectConfig = {
							order = 2,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('MerInspect'); end,
							func = function()
								SlashCmdList.MerInspect();
								E:ToggleOptionsUI();
							end,
						},
					}
				},
				AtlasLootClassic = {
					order = 3,
					type = "group",
					name = L['AtlasLootClassic'],
					guiInline = false,
					args = {
						AtlasLootClassic = {
							order = 1,
							type = 'toggle',
							name = L["AtlasLootClassic"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["AtlasLootClassic"],
							disabled = function() return not E:IsConfigurableAddOn('AtlasLootClassic'); end,
						},
						ShowAtlasLootClassicFrame = {
							order = 2,
							type = 'execute',
							name = L['Show Config'],
							disabled = function() return not IsAddOnLoaded('AtlasLootClassic'); end,
							func = function()
								if _G.AtlasLoot then
									_G.AtlasLoot.SlashCommands:Run("")
									E:ToggleOptionsUI();
								end
							end,
						},
					}
				},
				AuctionFaster = {
					order = 4,
					type = "group",
					name = L['AuctionFaster'],
					guiInline = false,
					args = {
						AuctionFaster = {
							order = 1,
							type = 'toggle',
							name = L["AuctionFaster"],
							desc = L["Enable/Disable"]..L["AuctionFaster"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	
								E.db.SingleAddons[ info[#info] ] = value;
								ToggleAddOnMsg(info[#info], value);
							end,
							disabled = function() return not E:IsConfigurableAddOn('AuctionFaster'); end,
						},
					}
				},
				Masque = {
					order = 6,
					type = "group",
					name = L['Masque'],
					guiInline = false,
					args = {
						Masque = {
							order = 1,
							type = 'toggle',
							name = L["Masque"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["Masque"],
							disabled = function() return not E:IsConfigurableAddOn('Masque'); end,
						},
					}
				},
				Ex_AutoEquip = {
					order = 7,
					type = "group",
					name = L['Ex_AutoEquip'],
					guiInline = false,
					args = {
						Ex_AutoEquip = {
							order = 1,
							type = 'toggle',
							name = L["Ex_AutoEquip"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["Ex_AutoEquip"],
							disabled = function() return not E:IsConfigurableAddOn('Ex_AutoEquip'); end,
						},
					}
				},
				FriendsMenuXP = {
					order = 8,
					type = "group",
					name = L['FriendsMenuXP'],
					guiInline = false,
					args = {
						FriendsMenuXP = {
							order = 1,
							type = 'toggle',
							name = L["FriendsMenuXP"],
							get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
							set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
							desc = L["Enable/Disable"]..L["FriendsMenuXP"],
							disabled = function() return not E:IsConfigurableAddOn('FriendsMenuXP'); end,
						},
					}
				},
			},
		},
	},
}