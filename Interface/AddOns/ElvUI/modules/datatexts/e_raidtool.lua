local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')

local IsInInstance = IsInInstance
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsGroupAssistant = UnitIsGroupAssistant
local InitiateRolePoll = InitiateRolePoll
local DoReadyCheck = DoReadyCheck

local function CheckRaidStatus()
	local inInstance, instanceType = IsInInstance()
	if ((IsInGroup() and not IsInRaid()) or UnitIsGroupLeader('player') or UnitIsGroupAssistant("player")) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")) then
		return true
	else
		return false
	end
end

local raidfunc = {}
raidfunc.disbandRaid = function() if CheckRaidStatus() then E:StaticPopup_Show("DISBAND_RAID") end end
raidfunc.role = function() if CheckRaidStatus() then InitiateRolePoll() end end
raidfunc.raidcheck = function() if CheckRaidStatus() then DoReadyCheck() end end

local LL = {}
if GetLocale() == 'zhCN' then
	LL.RaidCheckTipLeftButtonOnLeftInfo = "到位情况"
	LL.RaidCheckTipRightButtonOnLeftInfo = "就位确认"
	LL.RaidCheckTipLeftButtonOnRightInfo = "检查BUFF"
	LL.RaidCheckRune = "检查强化符文"
	LL.RaidCheckTipRightButtonOnRightInfo = "检查合剂"
elseif GetLocale() == 'zhTW' then
	LL.RaidCheckTipLeftButtonOnLeftInfo = "到位情況"
	LL.RaidCheckTipRightButtonOnLeftInfo = "就位確認"
	LL.RaidCheckTipLeftButtonOnRightInfo = "檢查BUFF"
	LL.RaidCheckRune = "檢查強化符文"
	LL.RaidCheckTipRightButtonOnRightInfo = "檢查藥劑"
else
	LL.RaidCheckTipLeftButtonOnLeftInfo = "check team members in place"
	LL.RaidCheckTipRightButtonOnLeftInfo = "initiated by the team in place to confirm"
	LL.RaidCheckTipLeftButtonOnRightInfo = "check team BUFF"
	LL.RaidCheckRune = "Check Rune"
	LL.RaidCheckTipRightButtonOnRightInfo = "check the mixture effect "
end

local Raidtool = {
	{text = LL.RaidCheckTipLeftButtonOnLeftInfo,
	func = function() local RC = E:GetModule('RaidCheck'); if RC then RC:CheckPosition(); end; end},
	{text = LL.RaidCheckTipRightButtonOnLeftInfo,
	func = function() DoReadyCheck(); end},
	{text = LL.RaidCheckTipLeftButtonOnRightInfo, 
	func = function() local RC = E:GetModule('RaidCheck'); if RC then RC:CheckRaidBuff(); end; end},
	{text = LL.RaidCheckRune, 
	func = function() local RC = E:GetModule('RaidCheck'); if RC then RC:CheckRune(); end; end},	
	{text = LL.RaidCheckTipRightButtonOnRightInfo, 
	func = function() local RC = E:GetModule('RaidCheck'); if RC then RC:CheckRaidFlask(); end; end},
	{text = L['Disband Group'], 
	func = function() if CheckRaidStatus() then E:StaticPopup_Show("DISBAND_RAID") end; end},
	{text = ROLE_POLL,
	func = function() if CheckRaidStatus() then InitiateRolePoll() end;	end},
	{text = L['Raid Menu'],
	func = function() ToggleFriendsFrame(4) end},
	{text = L['EUIRaidToolBox1'],
	func = function() if _G['EUIRaidToolBox1'] then if _G['EUIRaidToolBox1']:IsVisible() then _G['EUIRaidToolBox1']:Hide(); else _G['EUIRaidToolBox1']:Show(); end end end},
	{text = L['EUIRaidToolBox2'],
	func = function() if _G['EUIRaidToolBox2'] then if _G['EUIRaidToolBox2']:IsVisible() then _G['EUIRaidToolBox2']:Hide(); else _G['EUIRaidToolBox2']:Show(); end end end},
	{text = L['EUIRaidToolBox3'],
	func = function() if _G['EUIRaidToolBox3'] then if _G['EUIRaidToolBox3']:IsVisible() then _G['EUIRaidToolBox3']:Hide(); else _G['EUIRaidToolBox3']:Show(); end end end},
}

local menuFrame = CreateFrame("Frame", "RaidToolClickMenu", E.UIParent)

local function Click(self)
	local position = self:GetPoint()
	if position:match("LEFT") then
		E:DropDown(Raidtool, menuFrame)
	else
		E:DropDown(Raidtool, menuFrame, -160, 0)
	end
end

local function OnEvent(self)
	menuFrame:SetTemplate("Transparent", true)
	self.text:SetText(L["RaidTool"])
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
DT:RegisterDatatext('E_Raidtool', {'PLAYER_ENTERING_WORLD'}, OnEvent, nil, Click, nil, nil)