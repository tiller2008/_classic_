local ODC = LibStub("AceAddon-3.0"):GetAddon("OfflineDataCenter")
local ODC_SF = ODC:GetModule("SortFilter")
if not ODC_SF then return end
local Module = ODC:NewModule("OfflineInventory", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("OfflineDataCenter")
Module.description = L["Offline Character"]
Module.type = "tab"
Module.name = "OfflineInventory"
Module.tabs = {
	["inventory"] = {
		Textures = "INTERFACE\\CHARACTERFRAME\\TempPortraitAlphaMask.blp", --PaperDollSidebarTab1.Icon
		Tooltip = L['Offline Character'],
		CallTabFunc = function()
			ODC_SF:CreateOrShowSubFrame("inventory")
			ODC_SF:Update("sort")
		end,
		CharChangedFunc = function()
			ODC_SF:CreateOrShowSubFrame("inventory")
			ODC_SF:Update("sort")
		end,
		Settings = {
			type = "group",
			name = L["Offline Character"],
			args = {
				group1 = { 
					type = "group", order = 1, 
					name = L["Offline Character"],guiInline = true, 
					args = { 
						enable = {
							type = "toggle",
							name = ENABLE,
							order = 1,
							set = function(info,val)
								if val then
									ODC:EnableTab("inventory")
								else
									ODC:DisableTab("inventory")
								end
							end,
							get = function(info)
								return ODC_Config.toggle.inventory
							end,
						}, 
					} 
				},
			},
		},
	}
}

local playername, selectChar, selectTab = ODC.playername, ODC.selectChar, ODC.selectTab

local function AddItemEquipped(itemLink)
	tinsert(ODC_DB[playername]["inventory"][1], ODC:MergeItem(itemLink, 1))
end
--[[
ODC_DB[charName] structure:
							INVSLOT
["inventory"]= {	[1]		{	[1]			{	.itemLink
								[2]				.count
["inventory"]= {	[1]		{	itemLink, itemLink	, ...
					[2]		{	count	, count		, ...
]]
function Module:CheckEquipped()
	ODC_DB[playername]["inventory"] = {[1]={}}
	for slotID = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		local link = GetInventoryItemLink("player", slotID)
		if link then
			AddItemEquipped(link)
		end
	end

	if ODC.Frame:IsVisible() and selectChar == playername and selectTab == "inventory" then
		ODC_SF:Update("sort")
	end
end

function Module:UNIT_INVENTORY_CHANGED()
	self:CheckEquipped()
end

function Module:ITEM_UPGRADE_MASTER_UPDATE()
	self:CheckEquipped()
end

function Module:REPLACE_ENCHANT()
	self:CheckEquipped()
end

function Module:UPDATE_PORTRAIT()
	if ODC.Frame.tabButton["inventory"] then
		if not ODC.Frame.tabButton["inventory"].img1 then
			ODC.Frame.tabButton["inventory"].img1 = ODC.Frame.tabButton["inventory"]:CreateTexture(nil, "BACKGROUND")
			ODC.Frame.tabButton["inventory"].img1:SetHeight(32)
			ODC.Frame.tabButton["inventory"].img1:SetWidth(32)
			if ElvUI then
				ODC.Frame.tabButton["inventory"].img1:SetInside()
			else
				ODC.Frame.tabButton["inventory"].img1:SetAllPoints(ODC.Frame.tabButton["inventory"])
			end
		end	
		SetPortraitTexture(ODC.Frame.tabButton["inventory"].img1, "player")		

		ODC.Frame.tabButton["inventory"].img1:SetTexCoord(0.2, 0.8, 0.0666, 0.9);
		ODC.Frame.tabButton["inventory"].img1:SetAlpha(1);
		ODC.Frame.tabButton["inventory"]:SetNormalTexture(ODC.Frame.tabButton["inventory"].img1)
	end
	if ElvUI and ElvUI_ContainerFrame and ElvUI_ContainerFrame.offlineButton then
		if not ElvUI_ContainerFrame.offlineButton.img1 then
			ElvUI_ContainerFrame.offlineButton.img1 = ElvUI_ContainerFrame.offlineButton:CreateTexture(nil, "BACKGROUND")
			ElvUI_ContainerFrame.offlineButton.img1:SetHeight(32)
			ElvUI_ContainerFrame.offlineButton.img1:SetWidth(32)
			ElvUI_ContainerFrame.offlineButton.img1:SetInside()
		end
		SetPortraitTexture(ElvUI_ContainerFrame.offlineButton.img1, "player")

		ElvUI_ContainerFrame.offlineButton.img1:SetTexCoord(0.2, 0.8, 0.0666, 0.9);
		ElvUI_ContainerFrame.offlineButton.img1:SetAlpha(1);		
		ElvUI_ContainerFrame.offlineButton:SetNormalTexture(ElvUI_ContainerFrame.offlineButton.img1)
	end	
end

Module.selectTabCallbackFunc = function(selectedTab)
	selectTab = selectedTab
end

Module.selectCharCallbackFunc = function(selectedChar)
	selectChar = selectedChar
end

function Module:OnInitialize()
	if ODC_Config.toggle.inventory == nil then ODC_Config.toggle.inventory = true end
	ODC:AddAvaliableTab("inventory", self)
end

function Module:OnEnable()
	if not ODC_Config.toggle.inventory then return end
	ODC:AddModule(self)
	ODC:AddTab("inventory", self.tabs["inventory"])
	if not ODC_DB[playername]["inventory"] then
		ODC_DB[playername]["inventory"] = {[1] = {}}
		self:CheckEquipped()
	end
	self:RegisterEvent("UNIT_INVENTORY_CHANGED");
	self:RegisterEvent("REPLACE_ENCHANT");
--	self:RegisterEvent("ITEM_UPGRADE_MASTER_UPDATE");
	self:RegisterEvent("UNIT_PORTRAIT_UPDATE", "UPDATE_PORTRAIT");
--	self:SecureHook('OpenAllBags', 'UPDATE_PORTRAIT');
--	self:SecureHook('ToggleBag', 'UPDATE_PORTRAIT');
end

function Module:OnDisable()
	if ODC_Config.toggle.inventory then return end
	ODC:RemoveModule(self)
	ODC:RemoveTab("inventory")
	self:UnregisterEvent("UNIT_INVENTORY_CHANGED");
	self:UnregisterEvent("REPLACE_ENCHANT");
--	self:UnregisterEvent("ITEM_UPGRADE_MASTER_UPDATE");
	self:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
--	self:UnhookAll()
end