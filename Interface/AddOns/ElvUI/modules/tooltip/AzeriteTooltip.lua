AzeriteTooltip = LibStub("AceAddon-3.0"):NewAddon("AzeriteTooltip", "AceEvent-3.0", "AceHook-3.0")
local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

local locationIDs = {
	["Head"] = 1, 
	["Shoulder"] = 3, 
	["Chest"] = 5,
}

local itemEquipLocToSlot = {
	["INVTYPE_HEAD"] = 1,
	["INVTYPE_SHOULDER"] = 3,
	["INVTYPE_CHEST"] = 5,
	["INVTYPE_ROBE"] = 5
}

local rings = {
	1,
	2,
}

local addText = ""

local L = {
	["Reload your UI to apply changes?"] = "Reload your UI to apply changes?",
	["Reload"] = "Reload",
	["Later"] = "Later",
	["AzeriteTooltip"] = "AzeriteTooltip",
	["Lightweight addon that shows azerite traits on tooltip/gear."] = "Lightweight addon that shows azerite traits on tooltip/gear.",
	["Remove Blizzard Text"] = "Remove Blizzard Text",
	["Only Spec"] = "Only Spec",
	["Compact Mode"] = "Compact Mode",
	["Show traits in bags"] = "Show traits in bags",
	["Show traits in character frame"] = "Show traits in character frame",
}
if GetLocale() == 'zhCN' then
	L = {
		["Reload your UI to apply changes?"] = "重载界面以应用设置?",
		["Reload"] = "重载",
		["Later"] = "再说",
		["AzeriteTooltip"] = "艾泽拉斯之心提示",
		["Lightweight addon that shows azerite traits on tooltip/gear."] = "在鼠标提示和装备上显示艾泽拉斯之心特质.",
		["Remove Blizzard Text"] = "替代暴雪提示",
		["Only Spec"] = "天赋专属",
		["Compact Mode"] = "紧凑模式",
		["Show traits in bags"] = "显示特质在背包",
		["Show traits in character frame"] = "显示特质在角色框",
	}
elseif GetLocale() == 'zhTW' then
	L = {
		["Reload your UI to apply changes?"] = "重載介面以應用設置?",
		["Reload"] = "重載",
		["Later"] = "再說",
		["AzeriteTooltip"] = "艾澤拉斯之心提示",
		["Lightweight addon that shows azerite traits on tooltip/gear."] = "在滑鼠提示和裝備上顯示艾澤拉斯之心特質.",
		["Remove Blizzard Text"] = "替代暴雪提示",
		["Only Spec"] = "天賦專屬",
		["Compact Mode"] = "緊湊模式",
		["Show traits in bags"] = "顯示特質在背包",
		["Show traits in character frame"] = "顯示特質在角色框",
	}
end

StaticPopupDialogs["ReloadUI_Popup"] = {
	text = L["Reload your UI to apply changes?"],
	button1 = L["Reload"],
	button2 = L["Later"],
	OnAccept = function()
	    ReloadUI()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

local defaults_settings = {
    profile = {
        removeblizzard = true,
        onlyspec = false,
        compact = false,
        bags = true,
        paperdoll = true,                       
    }
}

function AzeriteTooltip:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("AzeriteTooltipDB", defaults_settings, true)
	self.settings = self.db.profile

	self:SetupOptions()

    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AzeriteTooltip", "AzeriteTooltip")
end

function AzeriteTooltip:SetupOptions()
	self.options = {
		name = "AzeriteTooltip",
		descStyle = "inline",
		type = "group",
		childGroups = "tab",
		args = {
			desc = {
				type = "description",
				name = L["Lightweight addon that shows azerite traits on tooltip/gear."],
				fontSize = "medium",
				order = 1
			},
			author = {
				type = "description",
				name = "\n|cffffd100Author: |r Kygo @ EU-Hyjal",
				order = 2
			},
			version = {
				type = "description",
				name = "|cffffd100Version: |r 2.0.3\n",
				order = 3
			},
			removeblizzard = {
                name = L["Remove Blizzard Text"],
                desc = "|cffaaaaaaReplace blizzard's default text. |r",
                descStyle = "inline",
                width = "full",
                type = "toggle",
                order = 4,
                set = function(info,val)
                    self.settings.removeblizzard = val
                end,
                get = function(info) return self.settings.removeblizzard end
            },
            onlyspec = {
                name = L["Only Spec"],
                desc = "|cffaaaaaaShow only traits for your current specialization. |r",
                descStyle = "inline",
                width = "full",
                type = "toggle",
                order = 5,
                set = function(info,val)
                    self.settings.onlyspec = val
                end,
                get = function(info) return self.settings.onlyspec end
            },
            compact = {
                name = L["Compact Mode"],
                desc = "|cffaaaaaaTraits will show in a more compact layout. |r",
                descStyle = "inline",
                width = "full",
                type = "toggle",
                order = 6,
                set = function(info,val)
                    self.settings.compact = val
                end,
                get = function(info) return self.settings.compact end
            },
            bags = {
                name = L["Show traits in bags"],
                desc = "|cffaaaaaaShow two main traits on gear in bags (works only with Blizzard Bags and Bagnon). |r",
                descStyle = "inline",
                width = "full",
                type = "toggle",
                order = 7,
                set = function(info,val)
                	StaticPopup_Show("ReloadUI_Popup")
                    self.settings.bags = val
                end,
                get = function(info) return self.settings.bags end
            },
            paperdoll = {
                name = L["Show traits in character frame"],
                desc = "|cffaaaaaaShow two main traits on gear on character frame. |r",
                descStyle = "inline",
                width = "full",
                type = "toggle",
                order = 8,
                set = function(info,val)
                	StaticPopup_Show("ReloadUI_Popup")
                    self.settings.paperdoll = val
                end,
                get = function(info) return self.settings.paperdoll end
            },
		}
	}

    LibStub("AceConfig-3.0"):RegisterOptionsTable("AzeriteTooltip", self.options)
end

function AzeriteTooltip:OnEnable()
    self:SecureHook('PaperDollItemSlotButton_Update')
    self:SecureHook('EquipmentFlyout_DisplayButton')
    self:SecureHook('ContainerFrame_Update')

    if IsAddOnLoaded("Bagnon") then
    	hooksecurefunc(Bagnon.ItemSlot, "Update", function(self)
    		if not AzeriteTooltip.db.profile.bags then return end
    		 
    		AzeriteTooltip:SetContainerAzerite(self) 
    	end)
    end

    self:SecureHookScript(GameTooltip, 'OnTooltipSetItem', 'OnTooltipSetItem')
    self:SecureHookScript(ItemRefTooltip, 'OnTooltipSetItem', 'OnTooltipSetItem')
    self:SecureHookScript(ShoppingTooltip1, 'OnTooltipSetItem', 'OnTooltipSetItem')
    --self:SecureHookScript(WorldMapTooltip, 'OnTooltipSetItem', 'OnTooltipSetItem')
    --self:SecureHookScript(WorldMapCompareTooltip1, 'OnTooltipSetItem', 'OnTooltipSetItem')
    self:SecureHookScript(EmbeddedItemTooltip, 'OnTooltipSetItem', 'OnTooltipSetItem')    
end

function AzeriteTooltip:GetSpellID(powerID)
	local powerInfo = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
  	if (powerInfo) then
    	local azeriteSpellID = powerInfo["spellID"]
    	return azeriteSpellID
  	end
end

function AzeriteTooltip:HasUnselectedPower(tooltip)
	local AzeriteUnlock = strsplit("%d", AZERITE_POWER_UNLOCKED_AT_LEVEL)
	for i = 8, tooltip:NumLines() do
		local left = _G[tooltip:GetName().."TextLeft"..i]
		local text = left:GetText()
        if text and ( text:find(AzeriteUnlock) or text:find(NEW_AZERITE_POWER_AVAILABLE) ) then
        	return true
        end
    end
end

function AzeriteTooltip:ScanSelectedTraits(tooltip, powerName)
	local empowered = GetSpellInfo(263978)
	for i = 8, tooltip:NumLines() do
		local left = _G[tooltip:GetName().."TextLeft"..i]
		local text = left:GetText()
		local newText
		local newPowerName
		if text and text:find("-") then
			newText = string.gsub(text, "-", " ")
		end
		if powerName:find("-") then
			newPowerName = string.gsub(powerName, "-", " ")
		end
        if text and text:find(powerName) then
        	return true
       	elseif (newText and newPowerName and newText:match(newPowerName)) then
       		return true
        elseif (powerName == empowered and not self:HasUnselectedPower(tooltip)) then
         	return true
        end
    end
end

function AzeriteTooltip:GetAzeriteLevel()
	local level
	local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
	if azeriteItemLocation then
		level = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
	else
		level = 0
	end
	return level
end		

function AzeriteTooltip:ClearBlizzardText(tooltip)
	local textLeft = tooltip.textLeft
	if not textLeft then
		local tooltipName = tooltip:GetName()
		textLeft = setmetatable({}, { __index = function(t, i)
			local line = _G[tooltipName .. "TextLeft" .. i]
			t[i] = line
			return line
		end })
		tooltip.textLeft = textLeft
	end
	for i = 7, tooltip:NumLines() do
		if textLeft then
			local line = textLeft[i]		
			local text = line:GetText()
			local r, g, b = line:GetTextColor()
			if text then
				local ActiveAzeritePowers = strsplit("(%d/%d)", CURRENTLY_SELECTED_AZERITE_POWERS) -- Active Azerite Powers (%d/%d)
				local AzeritePowers = strsplit("(0/%d)", TOOLTIP_AZERITE_UNLOCK_LEVELS) -- Azerite Powers (0/%d)
				local AzeriteUnlock = strsplit("%d", AZERITE_POWER_UNLOCKED_AT_LEVEL) -- Unlocked at Heart of Azeroth Level %d
				local Durability = strsplit("%d / %d", DURABILITY_TEMPLATE)
				local ReqLevel = strsplit("%d", ITEM_MIN_LEVEL) 
				
				if text:match(NEW_AZERITE_POWER_AVAILABLE) then
					line:SetText("")
				end

				if text:find(AzeriteUnlock) then
					line:SetText("")
				end

				if text:find(Durability) or text:find(ReqLevel) then
					textLeft[i-1]:SetText("")
				end

				if text:find(ActiveAzeritePowers) then
                    textLeft[i-1]:SetText("")
                    line:SetText("")
					textLeft[i+1]:SetText(addText)
				elseif (text:find(AzeritePowers) and not text:find(">")) then
                    textLeft[i-1]:SetText("")
                    line:SetText("")
					textLeft[i+1]:SetText(addText)
				-- 8.1 FIX --
				elseif text:find(AZERITE_EMPOWERED_ITEM_FULLY_UPGRADED) then
					textLeft[i-1]:SetText("")
					line:SetText(addText)
					textLeft[i+1]:SetText("")
				end
			end
		end
	end
end

function AzeriteTooltip:RemovePowerText(tooltip, powerName)
	local textLeft = tooltip.textLeft
	if not textLeft then
		local tooltipName = tooltip:GetName()
		textLeft = setmetatable({}, { __index = function(t, i)
			local line = _G[tooltipName .. "TextLeft" .. i]
			t[i] = line
			return line
		end })
		tooltip.textLeft = textLeft
	end
	for i = 7, tooltip:NumLines() do
		if textLeft then
			local enchanted = strsplit("%d", ENCHANTED_TOOLTIP_LINE)
			local use = strsplit("%d", ITEM_SPELL_TRIGGER_ONUSE)			 
			local line = textLeft[i]		
			local text = line:GetText()
			local r, g, b = line:GetTextColor()
			local newText
			local newPowerName
			if text and text:find("-") then
				newText = string.gsub(text, "-", " ")
			end
			if powerName:find("-") then
				newPowerName = string.gsub(powerName, "-", " ")
			end
			if text then				
				if text:match(CURRENTLY_SELECTED_AZERITE_POWERS_INSPECT) then return end
				if text:find("- "..powerName) then
					line:SetText("")
				elseif (newText and newPowerName and newText:match(newPowerName)) then
       				line:SetText("")
				end
				if ( r < 0.1 and g > 0.9 and b < 0.1 and not text:find(">") and not text:find(ITEM_SPELL_TRIGGER_ONEQUIP) and not text:find(enchanted) and not text:find(use) ) then
					line:SetText("")
				end
			end
		end
	end
end

function AzeriteTooltip:BuildTooltip(self)
	if not E.db.tooltip.azerite or E:IsPRType() then return end
	local name, link = self:GetItem()
  	if not name then return end

  	if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(link) then

  		addText = ""
		
		local currentLevel = AzeriteTooltip:GetAzeriteLevel()

		local specID = GetSpecializationInfo(GetSpecialization())
		local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID(link)

		if not allTierInfo then return end

		local activePowers = {}
		local activeAzeriteTrait = false

		if AzeriteTooltip.db.profile.compact then
			for j=1, 5 do
				if not allTierInfo[j] then break end

				local tierLevel = allTierInfo[j]["unlockLevel"]
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

				if not allTierInfo[1]["azeritePowerIDs"][1] then return end

				local azeriteTooltipText = " "
				for i, _ in pairs(allTierInfo[j]["azeritePowerIDs"]) do
					local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
					local azeriteSpellID = AzeriteTooltip:GetSpellID(azeritePowerID)				
					local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)	

					if tierLevel <= currentLevel then
						if AzeriteTooltip:ScanSelectedTraits(self, azeritePowerName) then
							local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:255:255:255|t'
							azeriteTooltipText = azeriteTooltipText.."  >"..azeriteIcon.."<"

							tinsert(activePowers, {name = azeritePowerName})
							activeAzeriteTrait = true
						elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then
							local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:255:255:255|t'
							azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
						elseif not AzeriteTooltip.db.profile.onlyspec or IsControlKeyDown() then
							local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
							azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
						end
					elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then						
						local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
						azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
					elseif not AzeriteTooltip.db.profile.onlyspec or IsControlKeyDown() then
						local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
						azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
					end				
				end

				if tierLevel <= currentLevel then
					if j > 1 then 
						addText = addText.."\n \n|cFFffcc00Level "..tierLevel..azeriteTooltipText.."|r"
					else
						addText = addText.."\n|cFFffcc00Level "..tierLevel..azeriteTooltipText.."|r"
					end
				else
					if j > 1 then 
						addText = addText.."\n \n|cFF7a7a7aLevel "..tierLevel..azeriteTooltipText.."|r"
					else
						addText = addText.."\n|cFF7a7a7aLevel "..tierLevel..azeriteTooltipText.."|r"
					end
				end
				
			end
		else
			for j=1, 5 do
				if not allTierInfo[j] then break end

				local tierLevel = allTierInfo[j]["unlockLevel"]
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

				if not allTierInfo[1]["azeritePowerIDs"][1] then return end

				local r, g, b

                if tierLevel <= currentLevel then
                    r, g, b = 1, 0.8, 0
                else
                    r, g, b = 0.5, 0.5, 0.5
                end

                local rgb = ("ff%.2x%.2x%.2x"):format(r*255, g*255, b*255)
                
                if j > 1 then
					addText = addText.. "\n\n|c" .. rgb .. format(" Level %d", tierLevel) .. "|r\n"
				else
					addText = addText.. "\n|c" .. rgb .. format(" Level %d", tierLevel) .. "|r\n"
				end

				for i, v in pairs(allTierInfo[j]["azeritePowerIDs"]) do
					local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
					local azeriteSpellID = AzeriteTooltip:GetSpellID(azeritePowerID)
						
					local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)
					local azeriteIcon = '|T'..icon..':20:20:0:0:64:64:4:60:4:60|t'
					local azeriteTooltipText = "  "..azeriteIcon.."  "..azeritePowerName
  
					if tierLevel <= currentLevel then
						if AzeriteTooltip:ScanSelectedTraits(self, azeritePowerName) then
							tinsert(activePowers, {name = azeritePowerName})
							activeAzeriteTrait = true	

							addText = addText.."\n|cFF00FF00"..azeriteTooltipText.."|r"			
						elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then
							addText = addText.."\n|cFFFFFFFF"..azeriteTooltipText.."|r"
						elseif not AzeriteTooltip.db.profile.onlyspec or IsControlKeyDown()  then
							addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
						end
					elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then
						addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
					elseif not AzeriteTooltip.db.profile.onlyspec or IsControlKeyDown() then
						addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
					end	
				end	
			end
		end

		if AzeriteTooltip.db.profile.removeblizzard then
			if activeAzeriteTrait then
				for k, v in pairs(activePowers) do
					AzeriteTooltip:RemovePowerText(self, v.name)
				end
			end
			AzeriteTooltip:ClearBlizzardText(self)
		else
			self:AddLine(addText)
			self:AddLine(" ")
		end
		wipe(activePowers)
	end
end

function AzeriteTooltip:CreateAzeriteIcons(button, azeriteEmpoweredItemLocation)
	if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(azeriteEmpoweredItemLocation) then
	    if not button.azerite then
	        button.azerite = CreateFrame("Frame", "$parent.azerite", button);
	        button.azerite:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT")
	        button.azerite:SetSize(37, 18)
	    else
			button.azerite:Show()
		end

		local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo(azeriteEmpoweredItemLocation)
		local noneSelected = true

		for j, k in ipairs(rings) do
			if not allTierInfo[j] then break end

			local azeritePowerID = allTierInfo[k]["azeritePowerIDs"][1]

			if not allTierInfo[1]["azeritePowerIDs"][1] then return end

			if button.azerite[j] then
				button.azerite[j]:Hide()
				button.azerite[j].overlay:Hide()
			end	

			for i, _ in pairs(allTierInfo[k]["azeritePowerIDs"]) do
				local azeritePowerID = allTierInfo[k]["azeritePowerIDs"][i]
				local azeriteSpellID = AzeriteTooltip:GetSpellID(azeritePowerID)				
				local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)	

				if C_AzeriteEmpoweredItem.IsPowerSelected(azeriteEmpoweredItemLocation, azeritePowerID) then
					noneSelected = false
					if not button.azerite[j] then
						if j == 1 then
							button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
							button.azerite[j]:SetPoint("LEFT", button.azerite, "LEFT")
							button.azerite[j]:SetSize(16, 16)
							button.azerite[j]:SetTexture(icon)
							-- Border
					        button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
					        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
					        button.azerite[j].overlay:SetVertexColor(0.7,0.7,0.7,0.8)
					        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
					        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
					        button.azerite[j].overlay:SetBlendMode("ADD")
						else
							button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
							button.azerite[j]:SetPoint("BOTTOMLEFT", button.azerite[j-1], "BOTTOMRIGHT", 4, 0)
							button.azerite[j]:SetSize(16, 16)
							button.azerite[j]:SetTexture(icon)
							-- Border
							button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
					        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
					        button.azerite[j].overlay:SetVertexColor(0.7,0.7,0.7,0.8)
					        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
					        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
					        button.azerite[j].overlay:SetBlendMode("ADD")
						end
					else
	  					button.azerite[j]:Show()
						button.azerite[j].overlay:Show()
	  					button.azerite[j]:SetTexture(icon)
					end;
				end	
			end					
		end
		if noneSelected	then button.azerite:Hide() end
	else
		if button.azerite then
			button.azerite:Hide()
		end
	end
end

function AzeriteTooltip:SetContainerAzerite(self)
	local name = self:GetName();
    for i = 1, self.size or 1 do
        local button = self.size and _G[name .. "Item" .. i] or self;
        local self = self.size and self or button:GetParent()
        local link = GetContainerItemLink(self:GetID(), button:GetID())

	    if not button then
	        return
	    end;	    

		if link then
			local azeriteEmpoweredItemLocation = ItemLocation:CreateFromBagAndSlot(self:GetID(), button:GetID())

			AzeriteTooltip:CreateAzeriteIcons(button, azeriteEmpoweredItemLocation)
		else
			if button.azerite then
				button.azerite:Hide()
			end
		end
	end
end

function AzeriteTooltip:SetPaperDollAzerite(self)
    local button = self
    local id = self:GetID();
    local textureName = GetInventoryItemTexture("player", id);

    local hasItem = textureName ~= nil;

    if (id == 1 or id == 3 or id == 5) and hasItem then

	    local azeriteEmpoweredItemLocation = ItemLocation:CreateFromEquipmentSlot(id)

	    AzeriteTooltip:CreateAzeriteIcons(button, azeriteEmpoweredItemLocation)
	else
		if button.azerite then
			button.azerite:Hide()
		end
	end
end

function AzeriteTooltip:SetFlyoutAzerite(self)
	if self.azerite then
		self.azerite:Hide()
	end

	if ( not self.location ) then
		return;
	end

	if ( self.location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION ) then
		return;
	end

    local _, _, _, _, slot, bag = EquipmentManager_UnpackLocation(self.location)
    local azeriteEmpoweredItemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
    local button = self

    if not bag then return end

    if not button then
        return
    end;

   	AzeriteTooltip:CreateAzeriteIcons(button, azeriteEmpoweredItemLocation)
end

-- HOOKS

function AzeriteTooltip:ContainerFrame_Update(frame)
	if not AzeriteTooltip.db.profile.bags then return end

	self:SetContainerAzerite(frame)
end

function AzeriteTooltip:PaperDollItemSlotButton_Update(frame)
	if not AzeriteTooltip.db.profile.paperdoll then return end

	self:SetPaperDollAzerite(frame)
end

function AzeriteTooltip:EquipmentFlyout_DisplayButton(frame)
	if not AzeriteTooltip.db.profile.paperdoll then return end

	self:SetFlyoutAzerite(frame)
end

function AzeriteTooltip:OnTooltipSetItem(frame)
	self:BuildTooltip(frame)
end

SLASH_AZERITETOOLTIP1 = "/azeritetooltip"
SLASH_AZERITETOOLTIP2 = "/at"
SlashCmdList["AZERITETOOLTIP"] = function()
    InterfaceOptionsFrame_OpenToCategory("AzeriteTooltip")
    InterfaceOptionsFrame_OpenToCategory("AzeriteTooltip")
end 
