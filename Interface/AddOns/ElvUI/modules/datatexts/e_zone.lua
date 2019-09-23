local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')
local LO = E:GetModule('Layout');

local ToggleFrame = ToggleFrame
local GetMinimapZoneText = GetMinimapZoneText
local GetRealZoneText = GetRealZoneText

local function Click(self, button)
	if button == "LeftButton" then
		ToggleFrame(WorldMapFrame)
	else
		ToggleFrame(GameMenuFrame)
	end
end

local function Update(self, elapsed)
	if(self.elapsed and self.elapsed > 0.2) then
		local subZoneText = GetMinimapZoneText() or ""
		local zoneText = GetRealZoneText() or ""		
		local displayLine = ''
		if (subZoneText ~= "") and (subZoneText ~= zoneText) then
			displayLine = zoneText .. ": " .. subZoneText
		end
		if displayLine == '' then
			displayLine = zoneText
		end
		
		self.text:SetText(displayLine)
		self.text:SetTextColor(LO:GetLocTextColor())
		
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end	
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
DT:RegisterDatatext('E_Zone', nil, nil, Update, Click, nil, nil)