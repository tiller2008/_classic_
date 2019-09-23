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
	name = '17.'..L['singleFunc'],
	desc = L['singleFunc desc'],
	childGroups = 'tree',
	get = function(info) return E.db.SingleAddons[ info[#info] ]; end,
	set = function(info, value)	E.db.SingleAddons[ info[#info] ] = value; ToggleAddOnMsg(info[#info], value); end,
	args = {
		ClearLuaError = {
			order = 0,
			type = "execute",
			name = L["Clear Lua Error"],
			func = function() wipe(E.global.luaError); end
		},
		HandyNotes_DungeonLocationsHeader = {
			order = 1,
			type = "header",
			name = L['HandyNotes_DungeonLocations'],
		},		
		HandyNotes_DungeonLocations = {
			order = 2,
			type = 'toggle',
			name = L["HandyNotes_DungeonLocations"],
			desc = L["Enable/Disable"]..L["HandyNotes_DungeonLocations"],
			disabled = function() return not E:IsConfigurableAddOn('HandyNotes_DungeonLocations (Classic)'); end,
		},
		ShowHandyNotes_DungeonLocationsCfg = {
			order = 3,
			type = 'execute',
			name = L['Show Config'],
			disabled = function() return not IsAddOnLoaded('HandyNotes_DungeonLocations (Classic)'); end,
			func = function()
				LibStub("AceConfigDialog-3.0"):Open("HandyNotes");
				E:ToggleOptionsUI();
			end,
		},
		HandyNotes_NPCsHeader = {
			order = 7,
			type = "header",
			name = L['HandyNotes_NPCs'],
		},
		HandyNotes_NPCs = {
			order = 8,
			type = 'toggle',
			name = L["HandyNotes_NPCs"],
			desc = L["Enable/Disable"]..L["HandyNotes_NPCs"],
			disabled = function() return not E:IsConfigurableAddOn('HandyNotes_NPCs (Classic)'); end,
		},
		ShowHandyNotes_NPCsCfg = {
			order = 9,
			type = 'execute',
			name = L['Show Config'],
			disabled = function() return not IsAddOnLoaded('HandyNotes_NPCs (Classic)'); end,
			func = function()
				LibStub("AceConfigDialog-3.0"):Open("HandyNotes");
				E:ToggleOptionsUI();
			end,
		},
		ClassicCodexHeader = {
			order = 10,
			type = "header",
			name = L['ClassicCodex'],
		},
		ClassicCodex = {
			order = 11,
			type = 'toggle',
			name = L["ClassicCodex"],
			desc = L["Enable/Disable"]..L["ClassicCodex"],
			disabled = function() return not E:IsConfigurableAddOn('ClassicCodex'); end,
		},
		ShowClassicCodexFrame = {
			order = 12,
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
		MikScrollingBattleTextHeader = {
			order = 13,
			type = "header",
			name = L['MikScrollingBattleText'],
		},
		MikScrollingBattleText = {
			order = 14,
			type = 'toggle',
			name = L["MikScrollingBattleText"],
			desc = L["Enable/Disable"]..L["MikScrollingBattleText"],
			disabled = function() return not E:IsConfigurableAddOn('MikScrollingBattleText'); end,
		},
		UseEUINumberFormat = {
			order= 15,
			type = 'toggle',
			name = L["Use Eui's number format"],
			get = function() return MikSBT and MikSBT.Profiles.currentProfile.groupNumbers or false; end,
			set = function(info, value) if MikSBT then MikSBT.Profiles.currentProfile.groupNumbers = value; end; end,
			disabled = function() return not E:IsConfigurableAddOn('MikScrollingBattleText'); end,
		},
		ShowMSBTOpt = {
			order = 16,
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
		DBM_CoreHeader = {
			order = 18,
			type = "header",
			name = L['DBM-Core'],
		},
		ShowDBMOpt = {
			order = 19,
			type = 'execute',
			name = L['Show Config'],
			disabled = function() return not IsAddOnLoaded('DBM-Core'); end,
			func = function()
				DBM:LoadGUI();
				E:ToggleOptionsUI();
			end,
		},
		TestDBMSound = {
			order = 20,
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
		OfflineDataCenterHeader = {
			order = 21,
			type = "header",
			name = L['OfflineDataCenter'],
		},
		OfflineDataCenter = {
			order = 22,
			type = 'toggle',
			name = L["OfflineDataCenter"],
			desc = L["Enable/Disable"]..L["OfflineDataCenter"],
			disabled = function() return not E:IsConfigurableAddOn('OfflineDataCenter'); end,
		},
		ShowODCFrame = {
			order = 23,
			type = 'execute',
			name = L['Show OfflineDataCenter Frame'],
			disabled = function() return not IsAddOnLoaded('OfflineDataCenter'); end,
			func = function()
				AD:GetAddon("OfflineDataCenter"):ToggleWindow();
				E:ToggleOptionsUI();
			end,
		},
		ShowODCCfg = {
			order = 24,
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
		RecountHeader = {
			order = 29,
			type = "header",
			name = L['Recount'],
		},
		Recount = {
			order = 30,
			type = 'toggle',
			name = L["Recount"],
			desc = L["Enable/Disable"]..L["Recount"],
			disabled = function() return not E:IsConfigurableAddOn('Recount'); end,
		},
		ShowRecountConfig = {
			order = 31,
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
			order = 33,
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
			order = 34,
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
		MerInspectHeader = {
			order = 57,
			type = "header",
			name = L['MerInspect'],
		},
		MerInspect = {
			order = 58,
			type = 'toggle',
			name = L["MerInspect"],
			desc = L["Enable/Disable"]..L["MerInspect"],
			disabled = function() return not E:IsConfigurableAddOn('MerInspect'); end,
		},
		MerInspectConfig = {
			order = 59,
			type = 'execute',
			name = L['Show Config'],
			disabled = function() return not IsAddOnLoaded('MerInspect'); end,
			func = function()
				SlashCmdList.MerInspect();
				E:ToggleOptionsUI();
			end,
		},
		MapsterHeader = {
			order = 67,
			type = "header",
			name = L['Mapster'],
		},		
		Mapster = {
			order = 68,
			type = 'toggle',
			name = L["Mapster"],
			desc = L["Enable/Disable"]..L["Mapster"],
			disabled = function() return not E:IsConfigurableAddOn('Mapster'); end,
		},
		ShowMapsterFrame = {
			order = 69,
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
		GSEHeader = {
			order = 70,
			type = "header",
			name = L['GSE'],
		},
		GSE = {
			order = 71,
			type = 'toggle',
			name = L["GSE"],
			desc = L["Enable/Disable"]..L["GSE"],
			disabled = function() return not E:IsConfigurableAddOn('GSE'); end,
		},
		CreateMacroButton = {
			order = 72,
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
			order = 73,
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
		WeaponSwingTimerHeader = {
			order = 80,
			type = "header",
			name = L['WeaponSwingTimer'],
		},
		WeaponSwingTimer = {
			order = 81,
			type = 'toggle',
			name = L["WeaponSwingTimer"],
			desc = L["Enable/Disable"]..L["WeaponSwingTimer"],
			disabled = function() return not E:IsConfigurableAddOn('WeaponSwingTimer'); end,
		},
		ShowWSFrame = {
			order = 82,
			type = 'execute',
			name = L['Show Config'],
			disabled = function() return not IsAddOnLoaded('WeaponSwingTimer'); end,
			func = function()
				InterfaceOptionsFrame_OpenToCategory("WeaponSwingTimer")
				InterfaceOptionsFrame_OpenToCategory("WeaponSwingTimer")
				E:ToggleOptionsUI();
			end,
		},
		AtlasLootClassicHeader = {
			order = 90,
			type = "header",
			name = L['AtlasLootClassic'],
		},
		AtlasLootClassic = {
			order = 91,
			type = 'toggle',
			name = L["AtlasLootClassic"],
			desc = L["Enable/Disable"]..L["AtlasLootClassic"],
			disabled = function() return not E:IsConfigurableAddOn('AtlasLootClassic'); end,
		},
		ShowAtlasLootClassicFrame = {
			order = 92,
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
		AuctionFasterHeader = {
			order = 100,
			type = "header",
			name = L['AuctionFaster'],
		},
		AuctionFaster = {
			order = 101,
			type = 'toggle',
			name = L["AuctionFaster"],
			desc = L["Enable/Disable"]..L["AuctionFaster"],
			disabled = function() return not E:IsConfigurableAddOn('AuctionFaster'); end,
		},
		ClassicThreatMeterHeader = {
			order = 110,
			type = "header",
			name = L['ClassicThreatMeter'],
		},
		ClassicThreatMeter = {
			order = 111,
			type = 'toggle',
			name = L["ClassicThreatMeter"],
			desc = L["Enable/Disable"]..L["ClassicThreatMeter"],
			disabled = function() return not E:IsConfigurableAddOn('ClassicThreatMeter'); end,
		},
		ShowClassicThreatMeterFrame = {
			order = 112,
			type = 'execute',
			name = L['Show Config'],
			disabled = function() return not IsAddOnLoaded('ClassicThreatMeter'); end,
			func = function()
				LibStub("AceConfigDialog-3.0"):Open("ClassicThreatMeter")
				E:ToggleOptionsUI();
			end,
		},
	},
}