local ODC = LibStub("AceAddon-3.0"):GetAddon("OfflineDataCenter")
local ODC_SF = ODC:GetModule("SortFilter")
if not ODC_SF then return end
local Module = ODC:NewModule("OfflineBag", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("OfflineDataCenter")
Module.description = L["Offline Bag"]
Module.type = "tab"
Module.name = "OfflineBag"
Module.tabs = {
	bag = {
		Textures = "Interface\\Buttons\\Button-Backpack-Up",
		Tooltip = L['Offline Bag'],
		CallTabFunc = function()
			ODC_SF:CreateOrShowSubFrame("bag")
			ODC_SF:Update("sort")
		end,
		CharChangedFunc = function()
			ODC_SF:CreateOrShowSubFrame("bag")
			ODC_SF:Update("sort")
		end,
		Settings = {
			type = "group",
			name = L['Offline Bag'],
			args = {
				group1 = { 
					type = "group", order = 1, 
					name =  L['Offline Bag'],guiInline = true, 
					args = { 
						enable = {
							type = "toggle",
							name = ENABLE,
							order = 1,
							set = function(info,val)
								if val then
									ODC:EnableTab("bag")
								else
									ODC:DisableTab("bag")
								end
							end,
							get = function(info)
								return ODC_Config.toggle.bag
							end,
						}, 
					} 
				},
			},
		},
	},
	bank = {
		Textures = "Interface\\AddOns\\OfflineDataCenter\\Textures\\ACHIEVEMENT_GUILDPERK_MOBILEBANKING.blp",
		Tooltip = L['Offline Bank'],
		CallTabFunc = function()
			ODC_SF:CreateOrShowSubFrame("bank")
			ODC_SF:Update("sort")
		end,
		CharChangedFunc = function()
			ODC_SF:CreateOrShowSubFrame("bank")
			ODC_SF:Update("sort")
		end,
		Settings = {
			type = "group",
			name = L['Offline Bank'],
			args = {
				group1 = { 
					type = "group", order = 1, 
					name = L['Offline Bank'],guiInline = true, 
					args = { 
						enable = {
							type = "toggle",
							name = ENABLE,
							order = 1,
							set = function(info,val)
								if val then
									ODC:EnableTab("bank")
								else
									ODC:DisableTab("bank")
								end
							end,
							get = function(info)
								return ODC_Config.toggle.bank
							end,
						}, 
					} 
				},
			},
		},
	},
	-- reagent = {
		-- Textures = "Interface\\ICONS\\INV_Enchant_DustArcane",
		-- Tooltip = L["Deposit Reagents"],
		-- CallTabFunc = function()
			-- ODC_SF:CreateOrShowSubFrame("reagent")
			-- ODC_SF:Update("sort")
		-- end,
		-- CharChangedFunc = function()
			-- ODC_SF:CreateOrShowSubFrame("reagent")
			-- ODC_SF:Update("sort")
		-- end,
		-- Settings = {
			-- type = "group",
			-- name = L["Deposit Reagents"],
			-- args = {
				-- group1 = { 
					-- type = "group", order = 1, 
					-- name = L["Deposit Reagents"],guiInline = true, 
					-- args = { 
						-- enable = {
							-- type = "toggle",
							-- name = ENABLE,
							-- order = 1,
							-- set = function(info,val)
								-- if val then
									-- ODC:EnableTab("reagent")
								-- else
									-- ODC:DisableTab("reagent")
								-- end
							-- end,
							-- get = function(info)
								-- return ODC_Config.toggle.reagent
							-- end,
						-- }, 
					-- } 
				-- },
			-- },
		-- },
	-- },	
}

local playername, selectChar, selectTab = ODC.playername, ODC.selectChar, ODC.selectTab

local function AddItem(itemLink, bagID, slotID)
	local dest
	if bagID <= 4 and bagID >= 0 then
		dest = "bag"
	else
		dest = "bank"
	end
	-- if bagID == REAGENTBANK_CONTAINER then
		-- dest = "reagent"
	-- end
	
	local _, count, _, _, _ = GetContainerItemInfo(bagID, slotID)
	tinsert(ODC_DB[playername][dest][1], ODC:MergeItem(itemLink, count))
end
--[[
ODC_DB[charName] structure:
				bagID	slotID
["bag/bank"]= {	[1]		[1]		{	.itemLink
				[n]					.count
["bag/bank"]= {	[1]		{	itemLink, itemLink	, ...
				[2]		{	count	, count		, ...
]]
function Module:CheckBags()
--DepositReagentBank()
	local BagIDs = self.isBankOpened and {-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11} or {0, 1, 2, 3, 4}
	if self.isBankOpened then ODC_DB[playername]["bank"] = {[1]={}} end
	ODC_DB[playername]["bag"] = {[1]={}}
	for k, bagID in pairs(BagIDs) do
		local numSlots = GetContainerNumSlots(bagID)
		if numSlots > 0 then
			for slotIndex = 1, numSlots do
				local itemLink = GetContainerItemLink(bagID, slotIndex)
				if itemLink then
					AddItem(itemLink, bagID, slotIndex)
				end
			end
		end
	end
	
	-- ODC_DB[playername]["reagent"] = {[1]={}}
	-- for i = 1, 98 do
		-- local itemLink = GetContainerItemLink(REAGENTBANK_CONTAINER, i)
		-- if itemLink then
			-- AddItem(itemLink, REAGENTBANK_CONTAINER, i)
		-- end
	-- end				
	
	if ODC.Frame:IsVisible() and selectChar == playername and (selectTab == "bag" or selectTab == "bank") then
		ODC_SF:Update("sort")
	end
end

function Module:CheckMoney()
	-- if not ODC_DB[playername]["bag"] then
		-- ODC_DB[playername]["bag"] = {}
	-- end
	ODC_DB[playername]["bag"].money = GetMoney()
end

function Module:BAG_UPDATE_DELAYED()
	self:CancelAllTimers()
	self:ScheduleTimer("CheckBags", 2)
end

function Module:PLAYER_MONEY()
	self:CheckMoney()
end

function Module:BANKFRAME_OPENED()
	self.isBankOpened = true
	self:CheckBags()
end

function Module:BANKFRAME_CLOSED()
	self.isBankOpened = nil
end

Module.selectTabCallbackFunc = function(selectedTab)
	selectTab = selectedTab
end

Module.selectCharCallbackFunc = function(selectedChar)
	selectChar = selectedChar
end

function Module:OnInitialize()
	if ODC_Config.toggle.bag == nil then ODC_Config.toggle.bag = true end
	if ODC_Config.toggle.bank == nil then ODC_Config.toggle.bank = true end
--	if ODC_Config.toggle.reagent == nil then ODC_Config.toggle.reagent = true end
	ODC:AddAvaliableTab("bag", self)
	ODC:AddAvaliableTab("bank", self)
--	ODC:AddAvaliableTab("reagent", self)
end

function Module:OnEnable()
	if ODC_Config.toggle.bag then
		if not ODC_DB[playername]["bag"] then
			ODC_DB[playername]["bag"] = {}
			self:CheckMoney()
			self:CheckBags()
		end
		if not ODC_DB[playername]["bag"].money then
			ODC_DB[playername]["bag"].money = GetMoney() or 0
		end
		ODC:AddTab("bag", self.tabs["bag"])
	end
	if ODC_Config.toggle.bank then
		if not ODC_DB[playername]["bank"] then
			ODC_DB[playername]["bank"] = {}
		end
		ODC:AddTab("bank", self.tabs["bank"])
		self:RegisterEvent("BANKFRAME_OPENED")
		self:RegisterEvent("BANKFRAME_CLOSED")
	end
	-- if ODC_Config.toggle.reagent then
		-- if not ODC_DB[playername]["reagent"] then
			-- ODC_DB[playername]["reagent"] = {}
		-- end
		-- ODC:AddTab("reagent", self.tabs["reagent"])
		-- self:RegisterEvent("BANKFRAME_OPENED")
		-- self:RegisterEvent("BANKFRAME_CLOSED")
	-- end	
	if ODC_Config.toggle.bag or ODC_Config.toggle.bank then
		ODC:AddModule(self)
		self:RegisterEvent("BAG_UPDATE_DELAYED")
		self:RegisterEvent("PLAYER_MONEY")
	end
end

function Module:OnDisable()
	if not ODC_Config.toggle.bag then
		ODC:RemoveTab("bag")
	end
	if not ODC_Config.toggle.bank then
		ODC:RemoveTab("bank")
	end
--	if not ODC_Config.toggle.reagent then
--		ODC:RemoveTab("reagent")
--	end
	if not ODC_Config.toggle.bank then
		self:UnregisterEvent("BANKFRAME_OPENED")
		self:UnregisterEvent("BANKFRAME_CLOSED")
	end
	if not ODC_Config.toggle.bag and not ODC_Config.toggle.bank then
		ODC:RemoveModule(self)
		self:UnregisterEvent("PLAYER_MONEY")
		self:UnregisterEvent("BAG_UPDATE_DELAYED")
	end
end