local ODC = LibStub("AceAddon-3.0"):GetAddon("OfflineDataCenter")
local Module = ODC:NewModule("Setting", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("OfflineDataCenter")

Module.description = L["settings"]
Module.type = "tab"
Module.name = "settings"
Module.tabs = {
	["settings"] = {
		Textures = "Interface\\ICONS\\Trade_Engineering",
		Tooltip = L["settings"],
		CallTabFunc = function()
			Module:CreateOrShowSubFrame("settings")
		end,
		CharChangedFunc = function()

		end,
	},
}

local FRAMENAME = "ODCFrameSettingSubFrame"
local ABOUTTEXT = "ODC - "..L["Offline Data Center"]..L[" version: "].." %s".." %s"
local selectedCharToWipe

local Config = {
	-- ResetToDefault = {
		-- type = "execute",
		-- name = "恢复默认设置",
		-- order = 1,
		-- func = function()
			-- Module:SetDefault()
			-- ReloadUI() 
		-- end,
	-- },
	wipedata = {
		type = "group",
		name = L["|cffff2222Wipe Data|r"],
		order = -1,
		args = {
			group1 = { 
				type = "group", order = 1, 
				name = L["wipe disabled tab data"],guiInline = true, 
				args = {
					WipeChar = {
						type = "execute",
						name = L["wipe disabled tab data"],
						order = 1,
						func = function()
							 ODC:WipeData("disabled")
						end,
					},
				}
			},
			group2 = { 
				type = "group", order = 2, 
				name = L["wipe selected character data"],guiInline = true, 
				args = {
					selectChar = {
						type = "select",
						name = L["Select a character to wipe"],
						order = 1,
						values = function()
							local characterTable = {}
							for k, v in pairs(ODC_DB) do
								if type(k) == 'string' and type(v) == 'table' then
									characterTable[k] = k
								end
							end
							return characterTable
						end,
						set = function(info,val)
							selectedCharToWipe = val
						end,
						get = function(info)
							return selectedCharToWipe
						end,
					},
					WipeUnused = {
						type = "execute",
						name = L["wipe selected character data"],
						order = 2,
						func = function()
							ODC:WipeData("character", selectedCharToWipe)
						end,
					},
				}
			},
			group3 = { 
				type = "group", order = 3, 
				name = L["wipe |cffff2222ALL|r data"],guiInline = true, 
				args = {
					WipeAll = {
						type = "execute",
						name = L["wipe |cffff2222ALL|r data"],
						order = 1,
						func = function()
							ODC:WipeData("all")
						end,
					},
				}
			},
		}
	}
}

local function LoadSettings()
	for _, module in ODC:IterateModules() do
		if module.type == "tab" and module.tabs then
			for tabname, tab in pairs(module.tabs) do
				if tab.Settings then
					Config[tabname] = tab.Settings
				end
			end
		end
	end 
end

local function CreateSubFrame()
	local p = ODC.Frame
	local f = CreateFrame('Frame',FRAMENAME, p);
	f:SetPoint('TOPLEFT', 0, -40);
	f:SetPoint('BOTTOMRIGHT', 0, 0);
	Module.Frame = f
	f:Hide()
	
	--Create Configure Dialogue Toggle Button
	f.configdialog = CreateFrame("Button", nil, f, "UIPanelButtonTemplate");
	f.configdialog:SetPoint('TOPLEFT', f, 'TOPLEFT', 12, -10)
	f.configdialog:SetText(L["Open config"])
	f.configdialog:SetScript("OnClick", function()
		if not IsAddOnLoaded("OfflineDataCenterOpts") then
			local _, _, _, _, reason = GetAddOnInfo("OfflineDataCenterOpts")
			if reason ~= "MISSING" and reason ~= "DISABLED" then 
				LoadAddOn("OfflineDataCenterOpts")
			else 
				f.configdisabled = f:CreateFontString(nil, 'OVERLAY');
				if ElvUI then
					f.configdisabled:FontTemplate(nil, 14, 'OUTLINE')
				else
					f.configdisabled:SetFont(STANDARD_TEXT_FONT, 14);
				end
				f.configdisabled:SetPoint("BOTTOMLEFT", f.configdialog, "BOTTOMLEFT", 10, -80);
				f.configdisabled:SetJustifyH("LEFT");
				f.configdisabled:SetText(L["|cffff2222OfflineDataCenterOpts\nhas been disabled in addons list.\nPlease enable it to open config window\nor use command line|r |cff22ff22/ODC|r |cffff2222to config|r"])
				return
			end
		end
		local _, ODCO_enabled = GetAddOnInfo("OfflineDataCenterOpts")
		if ODCO_enabled then
			local ACD = LibStub("AceConfigDialog-3.0")	
			local mode = 'Close'
			if not ACD.OpenFrames["OfflineDataCenter"] then
				mode = 'Open'
			end
			LibStub("AceConfig-3.0"):RegisterOptionsTable("OfflineDataCenter", {
				type = "group",
				name = format(ABOUTTEXT, ODC.versionstate, ODC.version),
				args = Config,
			})
			ACD[mode](ACD, "OfflineDataCenter") 
		end
	end)
	f.configdialog:SetSize(150, 30);
	
	----Create About text
	f.aboutText = f:CreateFontString(nil, 'OVERLAY');
	if ElvUI then
		f.aboutText:FontTemplate(nil, 14, 'OUTLINE')
	else
		f.aboutText:SetFont(STANDARD_TEXT_FONT, 14);
	end
	f.aboutText:SetPoint("BOTTOMLEFT", 10, 10);
	f.aboutText:SetJustifyH("LEFT");
	f.aboutText:SetText(format(ABOUTTEXT, ODC.versionstate, ODC.version))
	
	if ElvUI then
		local S = ElvUI[1]:GetModule("Skins")
		if S then
			S:HandleButton(f.configdialog);
		end
	end
end

function Module:CreateOrShowSubFrame(tabName)
	if not self.Frame then
		CreateSubFrame()
	end
	LoadSettings()

	ODC:ShowSubFrame(tabName, Module.Frame)
end

function Module:OnEnable()
	ODC:AddTab("settings", self.tabs["settings"])
	-- ODC:AddModule(self)
end

function Module:OnDisable()
	ODC:RemoveTab("settings")
	-- ODC:RemoveModule(self)
end