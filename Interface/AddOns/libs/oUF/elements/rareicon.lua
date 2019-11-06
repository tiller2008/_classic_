--[[
	by eui.cc
--]]

local _, ns = ...
local oUF = ns.oUF

local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass
local UnitClassification = UnitClassification
local UnitName = UnitName


local function Update(self, event, unit)
	if(not unit or self.unit ~= unit) then return end

	local element = self.Rare

	--[[ Callback: Rare:PreUpdate()
	Called before the element has been updated.

	* self - the ComboPoints element
	--]]
	if(element.PreUpdate) then
		element:PreUpdate()
	end
	
	if UnitName(unit) and element.Texture then
		local TargetClass = UnitIsPlayer(unit) and select(2, UnitClass(unit)) or UnitClassification(unit)
		if TargetClass == 'worldboss' or TargetClass == 'elite' or TargetClass == 'rare' or TargetClass == 'rareelite' then
			element.Texture:SetTexture('Interface\\AddOns\\EuiScript\\textures\\'.. element.DragonOverlayStyle ..'\\'..TargetClass..'.tga')
			element:Show()
		else
			return element:Hide()
		end
	else
		return element:Hide()
	end

	--[[ Callback: HappinessIndicator:PostUpdate(role)
	Called after the element has been updated.

	* self      - the ComboPoints element
	* unit      - the unit for which the update has been triggered (string)
	* happiness        - the numerical happiness value of the pet (1 = unhappy, 2 = content, 3 = happy) (number)
	* damagePercentage - damage modifier, happiness affects this (unhappy = 75%, content = 100%, happy = 125%) (number)
	--]]
	if(element.PostUpdate) then
		return element:PostUpdate(unit, happiness, damagePercentage)
	end
end

local function Path(self, ...)
	--[[ Override: HappinessIndicator.Override(self, event, ...)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* ...   - the arguments accompanying the event
	--]]
	return (self.Rare.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.Rare
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('PLAYER_TARGET_CHANGED', Path)
		self:RegisterEvent('UNIT_TARGET', Path)

		return true
	end
end

local function Disable(self)
	local element = self.Rare
	if(element) then
		element:Hide()

		self:UnregisterEvent('UNIT_TARGET', Path)
		self:UnregisterEvent('PLAYER_TARGET_CHANGED', Path)
	end
end

oUF:AddElement('RareIcon', Path, Enable, Disable)
