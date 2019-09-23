local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')
local LO = E:GetModule('Layout');

local floor = math.floor
local join = string.join
local IsInRaid = IsInRaid
local IsInGroup = IsInGroup
local SendChatMessage = SendChatMessage
local UnitName = UnitName
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local GetRealZoneText = GetRealZoneText
local ToggleFrame = ToggleFrame

local displayString = ""
local inRestrictedArea = false

local function Click(self, button)
	if button == 'LeftButton' then
		local chattype = "SAY"
		if IsInRaid() then
			chattype = "RAID"
		elseif IsInGroup() then
			chattype = "PARTY"
		end
		local targetStr, current = '', '';
		if UnitName('target') then
			targetStr = UnitName('target').. '@ '
			current = E:GetFormattedText('CURRENT_PERCENT', UnitHealth('target'), UnitHealthMax('target'))
		end
		local msg = targetStr.. GetRealZoneText()..": ".. self.loc.. " - ".. current;
		if ChatFrame1EditBox:IsShown() then
			ChatFrame1EditBox:Insert(msg);
		else
			SendChatMessage(msg, chattype)
		end
	elseif button == 'RightButton' then
		ToggleFrame(WorldMapFrame)
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	DT.tooltip:AddDoubleLine(L["Left button:"], L["Send player's coord to chatframe"], 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
	DT.tooltip:AddDoubleLine(L["Right button:"], L["Open world map"], 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
	
	DT.tooltip:Show()
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function Update(self, elapsed)
	if inRestrictedArea or not E.MapInfo.coordsWatching then return end

	self.timeSinceUpdate = (self.timeSinceUpdate or 0) + elapsed

	if self.timeSinceUpdate > 0.2 then
		self.text:SetFormattedText(displayString, E.MapInfo.xText or 0, E.MapInfo.yText or 0)
		self.timeSinceUpdate = 0
	end
end

local function OnEvent(self)
	E:MapInfo_Update()

	if E.MapInfo.x and E.MapInfo.y then
		inRestrictedArea = false
		self.text:SetFormattedText(displayString, E.MapInfo.xText or 0, E.MapInfo.yText or 0)
	else
		inRestrictedArea = true
		self.text:SetText("N/A")
	end
end

local function ValueColorUpdate(hex)
	displayString = join("", hex, "%.0f|r", " , ", hex, "%.0f|r")
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

DT:RegisterDatatext('E_Coord', {"ZONE_CHANGED","ZONE_CHANGED_INDOORS","ZONE_CHANGED_NEW_AREA"}, OnEvent, Update, Click, OnEnter, OnLeave)