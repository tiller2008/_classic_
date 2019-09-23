local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')

local InCombatLockdown = InCombatLockdown

local ShortcutsList = {
	{text = L["Setup Chat"], 
	func = function() E:Install(); ElvUIInstallFrame.SetPage(3); end},
	{text = L['Theme Setup'],
	func = function() E:Install(); ElvUIInstallFrame.SetPage(4); end},
	{text = L['Raid Layout'], 
	func = function() E:Install(); ElvUIInstallFrame.SetPage(5); end},		
	{text = L["UF Style"], 
	func = function() E:Install(); ElvUIInstallFrame.SetPage(6); end},
	{text = L["AB Style"], 
	func = function() E:Install(); ElvUIInstallFrame.SetPage(8); end},
	{text = L["Toggle Anchors"],
	func = function()
		if ElvUIMoverPopupWindow and ElvUIMoverPopupWindow:IsShown() then
			E:ToggleMoveMode(false)
		else
			E:ToggleMoveMode()
		end
	end},
	{text = L["Reset Anchors"],
	func = function() E:ResetUI() end},
	{text = L["Enable/Disable"]..'|cff99ff33EUI|r'..L['Castbar'],
	func = function()
		if InCombatLockdown() then return; end
		if E.db.unitframe.units.player.castbar.enable then
			E.db.unitframe.units.player.castbar.enable = false;
			E.db.unitframe.units.target.castbar.enable = false;
			E.db.unitframe.units.focus.castbar.enable = false;
			E.db.unitframe.units.boss.castbar.enable = false;
			E.db.unitframe.units.arena.castbar.enable = false;
			E.db.unitframe.units.party.castbar.enable = false;
			E:Print(L['Castbar']..'-'..L['Disabled']);
		else
			E.db.unitframe.units.player.castbar.enable = true;
			E.db.unitframe.units.target.castbar.enable = true;
			E.db.unitframe.units.focus.castbar.enable = true;
			E.db.unitframe.units.boss.castbar.enable = true;
			E.db.unitframe.units.arena.castbar.enable = true;
			E.db.unitframe.units.party.castbar.enable = true;
			E:Print(L['Castbar']..'-'..L["Enable"]);
		end
		local UF = E:GetModule('UnitFrames');
		UF:CreateAndUpdateUF('player');
		UF:CreateAndUpdateUF('target');
		UF:CreateAndUpdateUF('focus');
		UF:CreateAndUpdateUFGroup('boss', MAX_BOSS_FRAMES)
		UF:CreateAndUpdateUFGroup('arena', 5)
	end},
}

local menuFrame = CreateFrame("Frame", "ShortOptClickMenu", E.UIParent)

local function Click(self)
	local position = self:GetPoint()
	if position and position:match("LEFT") then
		E:DropDown(ShortcutsList, menuFrame)
	else
		E:DropDown(ShortcutsList, menuFrame, -160, 0)
	end
end

local function OnEvent(self)
	menuFrame:SetTemplate("Transparent", true)
	self.text:SetText(L["Shortcuts"])
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
DT:RegisterDatatext('E_Shortopt', {'PLAYER_ENTERING_WORLD'}, OnEvent, nil, Click, nil, nil)