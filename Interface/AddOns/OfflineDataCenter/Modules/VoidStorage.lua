local ODC = LibStub("AceAddon-3.0"):GetAddon("OfflineDataCenter")
local ODC_SF = ODC:GetModule("SortFilter")
if not ODC_SF then return end
local Module = ODC:NewModule("OfflineVoidStorage", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("OfflineDataCenter")
Module.description = L["Offline Void Storage"]
Module.type = "tab"
Module.name = "OfflineVoidStorage"
Module.tabs = {
	["voidstorage"] = {
		["Textures"] = "Interface\\ICONS\\Spell_Nature_AstralRecalGroup",
		["Tooltip"] = L['Offline Void Storage'],
		["CallTabFunc"] = function()
			ODC_SF:CreateOrShowSubFrame("voidstorage")
			ODC_SF:Update("sort")
		end,
		["CharChangedFunc"] = function()
			ODC_SF:CreateOrShowSubFrame("voidstorage")
			ODC_SF:Update("sort")
		end,
		Settings = {
			type = "group",
			name = L["Offline Void Storage"],
			args = {
				group1 = { 
					type = "group", order = 1, 
					name = L["Offline Void Storage"],guiInline = true, 
					args = { 
						enable = {
							type = "toggle",
							name = ENABLE,
							order = 1,
							set = function(info,val)
								if val then
									ODC:EnableTab("voidstorage")
								else
									ODC:DisableTab("voidstorage")
								end
							end,
							get = function(info)
								return ODC_Config.toggle.voidstorage
							end,
						}, 
					} 
				},
			},
		},
	},
}

local playername, selectChar, selectTab = ODC.playername, ODC.selectChar, ODC.selectTab

local function AddItem(itemLink)
	tinsert(ODC_DB[playername]["voidstorage"][1], ODC:MergeItem(itemLink, 1))
end
--[[
ODC_DB[charName] structure:
					bagID		slotID
["voidstorage"]= {	[1]			[1]			{	(.itemLink)
								[n]
["voidstorage"]= {	[1]		{	itemLink, itemLink	, ...
					[2]		{	count	, count		, ...
]]
function Module:CheckVoidItems()
	if CanUseVoidStorage() and IsVoidStorageReady() then
		ODC_DB[playername]["voidstorage"] = {[1]={}}
		for slotIndex = 1, 80 do
			local itemLink = GetVoidItemHyperlinkString(slotIndex)
			if itemLink then
				AddItem(itemLink)
			end
		end
	end
	
	if ODC.Frame:IsVisible() and selectChar == playername and selectTab == "voidstorage" then
		ODC_SF:Update("sort")
	end
end

function Module:VOID_STORAGE_CONTENTS_UPDATE()
	self:CheckVoidItems()
end

function Module:VOID_STORAGE_UPDATE()
	self:CheckVoidItems()
end

Module.selectTabCallbackFunc = function(selectedTab)
	selectTab = selectedTab
end

Module.selectCharCallbackFunc = function(selectedChar)
	selectChar = selectedChar
end

function Module:OnInitialize()
	if ODC_Config.toggle.voidstorage == nil then ODC_Config.toggle.voidstorage = true end
	ODC:AddAvaliableTab("voidstorage", self)
end

function Module:OnEnable()
	if ODC_Config.toggle.voidstorage then
		if not ODC_DB[playername]["voidstorage"] then
			ODC_DB[playername]["voidstorage"] = {}
			self:CheckVoidItems()
		end
		ODC:AddTab("voidstorage", self.tabs["voidstorage"])
		ODC:AddModule(self)
		self:RegisterEvent("VOID_STORAGE_CONTENTS_UPDATE")
		self:RegisterEvent("VOID_STORAGE_UPDATE")
	end
end

function Module:OnDisable()
	if not ODC_Config.toggle.voidstorage then
		ODC:RemoveTab("voidstorage")
		ODC:RemoveModule(self)
		self:UnregisterEvent("VOID_STORAGE_CONTENTS_UPDATE")
		self:UnregisterEvent("VOID_STORAGE_UPDATE")
	end
end