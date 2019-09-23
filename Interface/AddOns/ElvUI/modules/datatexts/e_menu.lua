local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')
local LO = E:GetModule('Layout');

local menuFrame = CreateFrame("Frame", "TopInfobarRightClickMenu", E.UIParent)

local function Click(self)
	local position = self:GetPoint()
	if position:match("LEFT") then
		E:DropDown(LO.menuList, menuFrame)
	else
		E:DropDown(LO.menuList, menuFrame, -160, 0)
	end
end

local function OnEvent(self)
	menuFrame:SetTemplate("Transparent", true)
	self.text:SetText(L["Menu"])
--	self.tex:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\computer.tga')
end

--[[
	DT:RegisterDatatext(name, events, eventFunc, updateFunc, clickFunc, onEnterFunc, onLeaveFunc)
	
	name - name of the datatext (required)
	events - must be a table with string values of event names to register 
	eventFunc - function that gets fired when an event gets triggered
	updateFunc - onUpdate script target function
	click - function to fire when clicking the datatext
	onEnterFunc - function to fire OnEnter
	onLeaveFunc - function to fire OnLeave, if not provided one will be set for you that hides the tooltip.
]]
DT:RegisterDatatext('E_Menu', {'PLAYER_ENTERING_WORLD'}, OnEvent, nil, Click, nil, nil)