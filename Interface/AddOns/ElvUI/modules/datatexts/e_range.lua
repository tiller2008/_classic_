local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')
local RC = E.Libs.RC

local format = string.format
local UnitName = UnitName

local function RGB(r, g, b)
	return format("%02x%02x%02x", r*255, g*255, b*255);	
end

local function GetRangeColorText(minRange, maxRange)
	local color, text;
	if (minRange) then
		if (minRange > 100) then
			maxRange = nil;
		end		
		
		if (maxRange) then
			local tmpText = format("%d-%d %s", minRange, maxRange, L["Yard"]);		
	
			if ( maxRange <= 5) then
				color = RGB(0.9, 0.9, 0.9);
			elseif (maxRange <= 20) then
				color = RGB(0.055, 0.875, 0.825);
			elseif (maxRange <= 30) then
				color = RGB(0.035, 0.865, 0.0);
			elseif (minRange >= 40) then
				color = RGB(0.9, 0.055, 0.075);
			else
				color = RGB(1.0, 0.82, 0);
			end
			
			text = format("|cff%s%s|r", color, tmpText);
		end
	end
	
	return text;
end

local function Update(self, elapsed)
	if(self.elapsed and self.elapsed > 0.2) then
		if not UnitName('target') then
			self.text:SetText('? - ?')
		else
			local minRange, maxRange = RC:getRange('target')
			if maxRange then
				local text = GetRangeColorText(minRange, maxRange)
				self.text:SetText(text)
			else
				self.text:SetText('|cFFB04F4F80+ '.. L["Yard"])
			end
		end
		
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end	
end

local function OnEvent(self)
	self.text:SetText("? - ?")
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
DT:RegisterDatatext('E_Range', {'PLAYER_ENTERING_WORLD'}, OnEvent, Update, nil, nil, nil)