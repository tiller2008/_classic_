local E, L, V, P, G = unpack(ElvUI); --Engine
local S = E:NewModule('EuiScript', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0');
E.build = GetAddOnMetadata("EuiScript", "Version")
E.Euiscript = S

local select, tonumber, floor, format, gsub, ipairs, find, pcall, pairs, strsplit = select, tonumber, math.floor, string.format, string.gsub, ipairs, string.find, pcall, pairs, strsplit
local IsAltKeyDown = IsAltKeyDown
local BNGetFriendInfo = BNGetFriendInfo
local BNGetNumFriends = BNGetNumFriends
local BNGetGameAccountInfo = BNGetGameAccountInfo
local BuyMerchantItem = BuyMerchantItem
local collectgarbage = collectgarbage
local ConvertToRaid = ConvertToRaid
local DisableAddOn = DisableAddOn
local GetBattlefieldWinner = GetBattlefieldWinner
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots
local GetGuildRosterInfo = GetGuildRosterInfo
local GetItemInfo = GetItemInfo
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetLFGDungeonRewards = GetLFGDungeonRewards
local GetLFGRandomDungeonInfo = GetLFGRandomDungeonInfo
local GetLootMethod = GetLootMethod
local GetMerchantItemLink = GetMerchantItemLink
local GetMerchantItemMaxStack = GetMerchantItemMaxStack
local GetNumGuildMembers = GetNumGuildMembers
local GetNumRandomDungeons = GetNumRandomDungeons
local GetRealmName = GetRealmName
local GetSpellInfo = GetSpellInfo
local GetSpellLink = GetSpellLink
local GuildControlGetNumRanks = GuildControlGetNumRanks
local GuildControlGetRankName = GuildControlGetRankName
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local InviteUnit = InviteUnit
local IsAddOnLoaded = IsAddOnLoaded
local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local IsSpellKnown = IsSpellKnown
local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local LFDQueueFrame_SetType = LFDQueueFrame_SetType
local LoggingCombat = LoggingCombat
local ObjectiveTracker_Collapse = ObjectiveTracker_Collapse
local ObjectiveTracker_Expand = ObjectiveTracker_Expand
local PickupMerchantItem = PickupMerchantItem
local RegisterStateDriver = RegisterStateDriver
local SendChatMessage = SendChatMessage
local SetCVar = SetCVar
local SetLootMethod = SetLootMethod
local UnitCanAttack = UnitCanAttack
local UnitExists = UnitExists
local UnitFactionGroup = UnitFactionGroup
local UnitInParty = UnitInParty
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsPlayer = UnitIsPlayer
local UnitLevel = UnitLevel
local UseContainerItem = UseContainerItem
local UnitGUID = UnitGUID
local GetTime = GetTime

BINDING_HEADER_EUISCRIPT = GetAddOnMetadata("EuiScript", "Title")
-- buy max number value with alt
function S:ByMaxNumber(self, ...)
	if ( IsAltKeyDown() ) then
		local itemLink = GetMerchantItemLink(self:GetID())
		if not itemLink then return end
		local maxStack = select(8, GetItemInfo(itemLink))
		if ( maxStack and maxStack > 1 ) then
			BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
		end
	end
end

----------------------------------------------------------------------------------------
--	Chat channel check
----------------------------------------------------------------------------------------
function E:CheckChat(warning)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if warning and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()) then
			return "RAID_WARNING"
		else
			return "RAID"
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end
	return "SAY"
end

--自动卖垃圾
local GrayWihterList = {
	[114002] = true,
	[140661] = true,
	[140662] = true,
	[140663] = true,
	[140664] = true,
	[140665] = true
}

function S:SellItem()
	if not E.db.euiscript.autosell then return end
	local c = 0
	for b=0,4 do
		for s=1,GetContainerNumSlots(b) do
			local l = GetContainerItemLink(b, s)
			if l then
				if (select(11, GetItemInfo(l))) and (select(2, GetContainerItemInfo(b, s))) then
					local itemid = tonumber(l:match("item:(%d+)"))
					if not itemid or not GetItemInfo(itemid) then break; end

					local p = select(11, GetItemInfo(l))*select(2, GetContainerItemInfo(b, s))
					if itemid and ((select(3, GetItemInfo(l))==0) or E.db.euiscript.autosellList[itemid]) and (p>0) and (not GrayWihterList[itemid]) then
						UseContainerItem(b, s)
						PickupMerchantItem()
						c = c+p
						E:Print(L['Vendored gray items for:']..select(2, GetItemInfo(l)));
					end
				end
			end
		end
	end
	if c>0 then
		local g, s, c = floor(c/10000) or 0, floor((c%10000)/100) or 0, c%100
		E:Print(" |cffffffff"..g..L.goldabbrev.." |cffffffff"..s..L.silverabbrev.." |cffffffff"..c..L.copperabbrev..".")			
	end
end

function S:AutoCollect()
	-- local eventcount = 0
	-- local EUIInGame = CreateFrame("Frame")
	-- EUIInGame:RegisterAllEvents()
	-- EUIInGame:SetScript("OnEvent", function(self, event)
		-- eventcount = eventcount + 1
		-- if InCombatLockdown() then return end

		-- if eventcount > 6000 or event == "PLAYER_ENTERING_WORLD" then
			-- collectgarbage("collect")
			-- eventcount = 0
		-- end
	-- end)
end

-- Auto invite by whisper
function S:AutoInvite(...)
	local event, arg1, arg2 = ...
	if ((not UnitExists("party1") or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) and (arg1:lower() == E.db.euiscript.ainvkeyword:lower())) and E.db.euiscript.autoinvenable == true then
		if event == 'CHAT_MSG_BN_WHISPER' then
			local totalBNet = BNGetNumFriends()
			for i = 1, totalBNet do
				local _, presenceName, _,_,_,bnetIDGameAccount,client,isOnline = BNGetFriendInfo(i)
				if isOnline and presenceName == arg2 and client == 'WoW' and bnetIDGameAccount then
					local _, charName, _, realmName = BNGetGameAccountInfo(bnetIDGameAccount)
					if realmName ~= GetRealmName() then charName = charName..'-'..realmName end
					InviteToGroup(charName)
					return;
				end
			end	
		else
			InviteToGroup(arg2)
		end
	end
end

--特殊技能通告
function S:Announcements()
--	if E.db.unitframe.units.boss.attack_color then
--		self:ChangeBossFrameColor()
--	end

	local _, event, _, subEvent, _, _, srcName, _, _, _, destName, _, _, spellID = CombatLogGetCurrentEventInfo()

	if not IsInGroup() or InCombatLockdown() or not subEvent or not spellID or not srcName then return end
	if not UnitInRaid(srcName) and not UnitInParty(srcName) then return end
	if not E.db.euiscript.announcements then return; end
	
	local srcName = format(srcName:gsub("%-[^|]+", ""))
	if subEvent == "SPELL_CAST_SUCCESS" then
		-- Feasts
		if (spellID == 126492 or spellID == 126494) then
			SendChatMessage(format(L["ANNOUNCE_FP_STAT"], srcName, GetSpellLink(spellID), SPELL_STAT1_NAME), E:CheckChat(true))
		elseif (spellID == 126495 or spellID == 126496) then
			SendChatMessage(format(L["ANNOUNCE_FP_STAT"], srcName, GetSpellLink(spellID), SPELL_STAT2_NAME), E:CheckChat(true))
		elseif (spellID == 126501 or spellID == 126502) then
			SendChatMessage(format(L["ANNOUNCE_FP_STAT"], srcName, GetSpellLink(spellID), SPELL_STAT3_NAME), E:CheckChat(true))
		elseif (spellID == 126497 or spellID == 126498) then
			SendChatMessage(format(L["ANNOUNCE_FP_STAT"], srcName, GetSpellLink(spellID), SPELL_STAT4_NAME), E:CheckChat(true))
		elseif (spellID == 126499 or spellID == 126500) then
			SendChatMessage(format(L["ANNOUNCE_FP_STAT"], srcName, GetSpellLink(spellID), SPELL_STAT5_NAME), E:CheckChat(true))
		elseif (spellID == 104958 or spellID == 105193 or spellID == 126503 or spellID == 126504 or spellID == 145166 or spellID == 145169 or spellID == 145196 or spellID == 160914 or spellID == 160740 or spellID == 175215) then
			SendChatMessage(format(L["ANNOUNCE_FP_PRE"], srcName, GetSpellLink(spellID)), E:CheckChat(true))
		-- Refreshment Table
		elseif spellID == 43987 then
			SendChatMessage(format(L["ANNOUNCE_FP_PRE"], srcName, GetSpellLink(spellID)), E:CheckChat(true))
		-- Ritual of Summoning
		elseif spellID == 698 then
			SendChatMessage(format(L["ANNOUNCE_FP_CLICK"], srcName, GetSpellLink(spellID)), E:CheckChat(true))
		-- Piccolo of the Flaming Fire
		elseif spellID == 18400 then
			SendChatMessage(format(L["ANNOUNCE_FP_USE"], srcName, GetSpellLink(spellID)), E:CheckChat(true))
		elseif spellID == 34477 and destName then
			SendChatMessage(srcName..GetSpellLink(spellID)..'>>'..destName..'<<', E:CheckChat(true))
		end
	elseif subEvent == "SPELL_SUMMON" then
		-- Repair Bots
		if E.global.announcements.AnnounceBots[spellID] then
			SendChatMessage(format(L["ANNOUNCE_FP_PUT"], srcName, GetSpellLink(spellID)), E:CheckChat(true))
		end
	elseif subEvent == "SPELL_CREATE" then
		-- Ritual of Souls and MOLL-E
		if (spellID == 29893 or spellID == 54710) then
			SendChatMessage(format(L["ANNOUNCE_FP_PUT"], srcName, GetSpellLink(spellID)), E:CheckChat(true))
		-- Toys
		elseif E.global.announcements.AnnounceToys[spellID] then
			SendChatMessage(format(L["ANNOUNCE_FP_PUT"], srcName, GetSpellLink(spellID)), E:CheckChat(true))
		-- Portals
		elseif E.global.announcements.AnnouncePortals[spellID] then
			SendChatMessage(format(L["ANNOUNCE_FP_CAST"], srcName, GetSpellLink(spellID)), E:CheckChat(true))
		end
	elseif subEvent == "SPELL_AURA_APPLIED" then
		-- Turkey Feathers and Party G.R.E.N.A.D.E.
		if (spellID == 61781 or ((spellID == 51508 or spellID == 51510) and destName == E.myname)) then
			SendChatMessage(string.format(L["ANNOUNCE_FP_USE"], srcName, GetSpellLink(spellID)), E:CheckChat(true))
		end
	end
end

-- function S:ChangeActionbarPage()
	-- if not UnitIsPlayer("target") then return; end
	-- if InCombatLockdown() then self:RegisterEvent('PLAYER_REGEN_ENABLED'); return; end
	
	-- local change = (UnitFactionGroup('player') == UnitFactionGroup('target'))
	-- if not change then
		-- ChangeActionBarPage(2)
	-- else
		-- ChangeActionBarPage(1)
	-- end
-- end

-- function S:PLAYER_REGEN_ENABLED()
	-- self:UnregisterEvent("PLAYER_REGEN_ENABLED");
	-- self:ChangeActionbarPage()
-- end

-- local function changeLoot()
	-- if IsInGroup() and UnitIsGroupLeader('player') and GetNumGroupMembers() > 1 then
		-- if GetLootMethod() ~= "freeforall" then
			-- SetLootMethod("freeforall")
		-- end
	-- end
	-- if IsInRaid() and UnitIsGroupLeader('player') and GetNumGroupMembers() > 1 then
		-- if GetLootMethod() ~= "master" then
			-- SetLootMethod("master")
		-- end
		-- if GetLootThreshold() ~= 4 then
			-- SetLootThreshold(4)
		-- end
	-- end
-- end

function S:AutoChangeLoot()
--	if not E.db.euiscript.autochangeloot then 
--		S:UnregisterEvent("GROUP_ROSTER_UPDATE")
--		return; 
--	end
--	E:ScheduleTimer(changeLoot, 5)
end

function S:GetGuildRanks()
	local value = {}
	if IsInGuild() then
		local ranks = GuildControlGetNumRanks()
		for i = 1, ranks do
			value[i] = GuildControlGetRankName(i)
		end
	end
	return value
end

function S:InviteRanks()
	if not IsInGuild() then return end
	
	local numMembers = GetNumGuildMembers();
	for i = 1, numMembers do
		local name, _, rankIndex, _, _, _, _, _, online = GetGuildRosterInfo(i)
		if online and E.db.euiscript.InviteRank[rankIndex] then
			pcall(InviteUnit, name);
		end
		if not IsInRaid() and IsInGroup() and UnitIsGroupLeader("player") then ConvertToRaid(); end
	end
end

function S:TradeTargetLevel(event)
	if IsAddOnLoaded('TheBurningTrade') then
		self:UnregisterEvent("TRADE_SHOW")
		self:UnregisterEvent("TRADE_CLOSED")
		return;
	end
	
	if event == 'TRADE_SHOW' then
		if not TradeFrame.targetLevel then
			TradeFrame.targetLevel = TradeFrame:CreateFontString(nil, 'OVERLAY')
			TradeFrame.targetLevel:FontTemplate(nil, 12, 'OUTLINE')
			TradeFrame.targetLevel:Point("BOTTOMLEFT", TradeFrame, "BOTTOMLEFT", 8, 8)
		end
		TradeFrame.targetLevel:SetText(TARGET..LEVEL.. ': '.. UnitLevel('NPC'))
		if UnitLevel('NPC') < 10 then TradeFrame.targetLevel:SetTextColor(1,0,0) end
		TradeFrame.targetLevel:Show()
	elseif event == 'TRADE_CLOSED' then
		if not TradeFrame.targetLevel then return; end
		TradeFrame.targetLevel:Hide()
	end
end

----------------------------------------------------------------------------------------
--	Collect minimap buttons in one line
----------------------------------------------------------------------------------------
local BlackList = {
	["HelpOpenTicketButton"] = true,
	["ZygorGuidesViewerMapIcon"] = true,
	["MiniMapTrackingButton"] = true,
	
	["MiniMapTrackingFrame"] = true,
	["MiniMapMeetingStoneFrame"] = true,
	["MiniMapMailFrame"] = true,
	["MiniMapBattlefieldFrame"] = true,
	["MiniMapWorldMapButton"] = true,
	["MiniMapPing"] = true,
	["MinimapBackdrop"] = true,
	["MinimapZoomIn"] = true,
	["MinimapZoomOut"] = true,
	["BookOfTracksFrame"] = true,
	["GatherNote"] = true,
	["FishingExtravaganzaMini"] = true,
	["MiniNotePOI"] = true,
	["RecipeRadarMinimapIcon"] = true,
	["FWGMinimapPOI"] = true,
	["CartographerNotesPOI"] = true,
	["MBB_MinimapButtonFrame"] = true,
	["EnhancedFrameMinimapButton"] = true,
	["GFW_TrackMenuFrame"] = true,
	["GFW_TrackMenuButton"] = true,
	["TDial_TrackingIcon"] = true,
	["TDial_TrackButton"] = true,
	["MiniMapTracking"] = true,
	["GatherMatePin"] = true,
	["HandyNotesPin"] = true,
	["TimeManagerClockButton"] = true,
	["GameTimeFrame"] = true,
	["DA_Minimap"] = true,
	["ElvConfigToggle"] = true,
	["MiniMapInstanceDifficulty"] = true,
	["MinimapZoneTextButton"] = true,
	["GuildInstanceDifficulty"] = true,
	["MiniMapVoiceChatFrame"] = true,
	["MiniMapRecordingButton"] = true,
	["QueueStatusMinimapButton"] = true,
	["GatherArchNote"] = true,
	["ZGVMarker"] = true,
	["QuestPointerPOI"] = true,
	["poiMinimap"] = true,
	["MiniMapLFGFrame"] = true,
	["PremadeFilter_MinimapButton"] = true,
	["GarrisonMinimapButton"] = true,
}
local WhiteList = {
	["BagSync_MinimapButton"] = true,
	["WebDKP_MinimapButton"] = true,
}

local buttons = {}
local maxbuttonsize = 32
local function CreateMinimapButton()
	local button = CreateFrame("Button", "EUIMinimapButton", E.UIParent)
	E.FrameLocks['EUIMinimapButton'] = true;
	
	button:SetFrameStrata("MEDIUM")
	button:RegisterForClicks("anyUp")

	button:SetClampedToScreen(true)
	button:StyleButton()
	button:SetTemplate()
	button:Size(20)
	button:Point('CENTER', Minimap, 'TOPLEFT', 0, -E.db.general.minimap.size / 2)
	E:CreateMover(button, "EUIMinimapButtonMover", L['Square minimap icons'], nil, nil, nil, "ALL,SOLO", nil, "euiscript,euiscript_general")
	button.texture = button:CreateTexture(nil, 'OVERLAY')
	button.texture:Size(22)
	button.texture:Point('CENTER')
	button.texture:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\tank')
	button:SetScript("OnClick", function(self, button)
		if button == "RightButton" then
			E:ToggleOptionsUI()
		else
			for i = 1, #buttons do
				if buttons[i]:IsShown() then buttons[i]:Hide() else buttons[i]:Show() end
			end
		end
	end)
	
	return button
end

local function PositionAndStyle(button)
	for i = 1, #buttons do
		buttons[i]:ClearAllPoints()
		if E.db.euiscript.buttonCollectDC == 'DOWN' then
			if i == 1 then
				buttons[i]:Point("TOP", button, "BOTTOM", 0, -2)
			elseif i > 1 then
				buttons[i]:Point("TOP", button, "BOTTOM", 0, -maxbuttonsize*(i-1)-i)
			end
		elseif E.db.euiscript.buttonCollectDC == 'LEFT' then
			if i == 1 then
				buttons[i]:Point("RIGHT", button, "LEFT", -2, 0)
			elseif i > 1 then
				buttons[i]:Point("RIGHT", button, "LEFT", -maxbuttonsize*(i-1)-i, 0)
			end
		elseif E.db.euiscript.buttonCollectDC == 'RIGHT' then
			if i == 1 then
				buttons[i]:Point("LEFT", button, "RIGHT", 2, 0)
			elseif i > 1 then
				buttons[i]:Point("LEFT", button, "RIGHT", maxbuttonsize*(i-1)+i, 0)
			end
		else
			if i == 1 then
				buttons[i]:Point("BOTTOM", button, "TOP", 0, 2)
			else
				buttons[i]:Point("BOTTOM", button, "TOP", 0, maxbuttonsize*(i-1)+i)
			end
		end
		buttons[i].ClearAllPoints = E.dummy
		buttons[i].SetPoint = E.dummy
		buttons[i]:Hide()
		if (buttons[i]:HasScript("OnClick")) then
			buttons[i]:HookScript("OnClick", function(self)
				for i = 1, #buttons do
					if buttons[i]:IsShown() then buttons[i]:Hide() end
				end
			end)
		elseif (buttons[i]:HasScript("OnMouseUp")) then
			buttons[i]:HookScript("OnMouseUp", function(self)
				for i = 1, #buttons do
					if buttons[i]:IsShown() then buttons[i]:Hide() end
				end
			end)
		end
	end
end

local function buttonCollect()
	local button = _G['EUIMinimapButton'] or CreateMinimapButton()
	if #buttons > 0 then return; end
	
	for i, child in ipairs({Minimap:GetChildren()}) do
		local childName = child:GetName()
		local Handy = childName and (find(childName, "HandyNotesPin"))
		if (not BlackList[childName] and not Handy) then
			if ((child:IsObjectType("Button") and child:GetNumRegions() >= 3) or WhiteList[childName]) and child:IsShown() then
				pcall(child.SetParent,button)
				if child:GetHeight() and child:GetHeight() > maxbuttonsize then
					maxbuttonsize = child:GetHeight();
				end
				tinsert(buttons, child)
			end
		end
	end
	if #buttons == 0 then
		button:Hide()
	else
		button:Show()
	end
	
	PositionAndStyle(button)
end

function S:CollapseObjective()
	if not E.db.euiscript.autoCollapseObjective then return; end

	--折叠任务追踪框
	if IsInInstance() then
		if (not ObjectiveTrackerFrame.collapsed) then
			ObjectiveTracker_Collapse();
			if EuiAutoQuestButton then EuiAutoQuestButton:Hide(); end
		end
	else
		if ObjectiveTrackerFrame.collapsed then
			ObjectiveTracker_Expand();
			if EuiAutoQuestButton then EuiAutoQuestButton:Show(); end
		end
	end
end

-- function S:ChangeBossFrameColor()
	-- local inInstance, instanceType = IsInInstance()
	-- if inInstance and instanceType == 'raid' then
		-- for i = 1, 4 do
			-- _G['ElvUF_Boss'..i].Health.colorClass = false;
			-- _G['ElvUF_Boss'..i].Health.colorReaction = false;
			-- _G['ElvUF_Boss'..i].Health.colorSmooth = false;
			-- _G['ElvUF_Boss'..i].Health.colorHealth = false;
			-- if UnitCanAttack('player', 'boss'..i) then
				-- _G['ElvUF_Boss'..i].Health:SetStatusBarColor(0.78,0.25,0.25)
			-- else
				-- _G['ElvUF_Boss'..i].Health:SetStatusBarColor(0.3,0.68,0.3)
			-- end
		-- end
	-- end
-- end

function S:ButtonCollect()
--	self:ModifyChatSticky() --call other module

	self:loggingCombat() --call other module
--	self:ModifyCamera()
--	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS", "AutoBattle")--for autoleavebn
--	self:CollapseObjective()
--	self:FixPriestTicks()
--	S:ShowBlzClassBarFrame();

	
	if not E.db.euiscript.buttonCollect then return; end
	
	if IsAddOnLoaded('MBB') then DisableAddOn('MBB') end	

	buttonCollect()
	E:ScheduleTimer(buttonCollect, 2)

	SetCVar("cameraDistanceMaxZoomFactor", E.db.euiscript.camerafactor or 3.5) --set cameraDistance
end

function S:TakeScreen()
	if not E.db.euiscript.autoscreenshoot then return; end
	
	E:ScheduleTimer(Screenshot, 1)
end

function S:loggingCombat()
	if not E.db.euiscript.logging_combat then return; end
	
	local inInstance, instanceType = IsInInstance()
	if inInstance and instanceType == "raid" then
		if not LoggingCombat() then
			LoggingCombat(1)
			E:Print("|cffffff00"..COMBATLOGENABLED.."|r")
		end
	else
		if LoggingCombat() then
			LoggingCombat(0)
			E:Print("|cffffff00"..COMBATLOGDISABLED.."|r")
		end
	end
end

function S:AutoBattle()
	if E.db.euiscript.autoleavebnsec < 0 then return; end
	local inInstance, instanceType = IsInInstance()
	local sec = E.db.euiscript.autoleavebnsec
	if sec == 0 then sec = 0.5 end
	
	if GetBattlefieldWinner() and instanceType == "pvp" then
		E:Print(L['Will be in %s seconds, automatically leave the battlefield!']:format(sec))
		E:ScheduleTimer(LeaveBattlefield, sec)
		S:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
	end
end

function S:WorldStateAlwaysUpFrame_Update()
	_G["WorldStateAlwaysUpFrame"]:ClearAllPoints() 
	_G["WorldStateAlwaysUpFrame"].ClearAllPoints = E.noop 
	_G["WorldStateAlwaysUpFrame"]:SetPoint("TOP",S.WorldState,"TOP", 0, 0)
	_G["WorldStateAlwaysUpFrame"].SetPoint = E.noop
end 

function S:Pop_ShowMenu(self)
	E.Friends_Source = OPEN_DROPDOWNMENUS[1] and OPEN_DROPDOWNMENUS[1].which or self.owner
end

local function CreatePOI()
	local f = CreateFrame("Frame", "EuiScriptPOI", E.UIParent)
	f:SetFrameStrata("DIALOG")
	f:SetSize(36,36)
	f:Point("CENTER",0,0)
	
	f.text = f:CreateFontString(nil, "ARTWORK")
	f.text:SetAllPoints(f)
	f:Hide()
	
	return f
end

function S:ToggleEuiScriptPoi()
	if E.db.euiscript.poi then
		EuiScriptPOI = EuiScriptPOI or CreatePOI();
		EuiScriptPOI.text:FontTemplate(nil, E.db.euiscript.poiTextSize, nil);
		EuiScriptPOI.text:SetTextColor(E.db.euiscript.poiColor.r, E.db.euiscript.poiColor.g, E.db.euiscript.poiColor.b)
		EuiScriptPOI.text:SetText(E.db.euiscript.poiText)
		if E.db.euiscript.poiCombat then
			EuiScriptPOI:RegisterEvent("PLAYER_REGEN_ENABLED")
			EuiScriptPOI:RegisterEvent("PLAYER_REGEN_DISABLED")
			EuiScriptPOI:SetScript("OnEvent", function(self, event)
				if not E.db.euiscript.poiCombat then return; end
				if event == 'PLAYER_REGEN_DISABLED' then
					self:Show()
				else
					self:Hide()
				end
			end)
			EuiScriptPOI:Hide()
		else
			EuiScriptPOI:UnregisterAllEvents()
			EuiScriptPOI:SetScript("OnEvent", nil)
			EuiScriptPOI:Show()
		end
	else
		if EuiScriptPOI then EuiScriptPOI:Hide(); end
	end
end

function S:QuestLog()
	----------------------------------------------------------------------------------------
	--	Quest level
	----------------------------------------------------------------------------------------
	hooksecurefunc("QuestLogQuests_Update", function()
		for i, button in pairs(QuestMapFrame.QuestsFrame.Contents.Titles) do
			if button:IsShown() and button.questLogIndex then
				local level = strmatch(GetQuestLink(button.questLogIndex), "quest:%d+:(%d+)")
				if level then
					local height = button.Text:GetHeight()
					button.Text:SetFormattedText("[%d] %s", level, button.Text:GetText())
					button.Check:SetPoint("LEFT", button.Text, button.Text:GetWrappedWidth() + 2, 0)
					button:SetHeight(button:GetHeight() - height + button.Text:GetHeight())
				end
			end
		end
	end)

end

local function ToggleTalkingFrame()
	if(TalkingHeadFrame and TalkingHeadFrame:IsVisible() and E.db.euiscript.disable_talking) then
		TalkingHeadFrame.MainFrame.CloseButton:GetScript("OnClick")();
	end
end
S.ToggleTalkingFrame = ToggleTalkingFrame

local TalkingHooked = false
function S:ToggleTalkingHead()
	if not TalkingHooked and TalkingHeadFrame then
		TalkingHeadFrame:HookScript("OnShow", ToggleTalkingFrame)
		TalkingHooked = true
	end
end


--载具按钮
function S:CreateVehicleExit()
	if E.private.actionbar.enable then return; end

	local vehicle = CreateFrame("Button", nil, E.UIParent, "SecureHandlerClickTemplate")
	vehicle:Width(26)
	vehicle:Height(26)
	vehicle:Point("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 2, 2)
	vehicle:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\vehicleexit")
	vehicle:SetPushedTexture("Interface\\AddOns\\ElvUI\\media\\textures\\vehicleexit")
	vehicle:SetHighlightTexture("Interface\\AddOns\\ElvUI\\media\\textures\\vehicleexit")
	vehicle:SetTemplate()
	vehicle:RegisterForClicks("AnyUp")
	vehicle:SetScript("OnClick", function() VehicleExit() end)
	RegisterStateDriver(vehicle, "visibility", "[vehicleui][target=vehicle,noexists] hide;show")
end

function S:Dismount(event, ...)
	-- Title: LetMeCast
	-- Author: Anilusion
	-- Version: 1.3
	if not E.db.euiscript.dismount then return end

	if event == "UI_ERROR_MESSAGE" then
		local arg1, arg2 = ...
		if arg1 == 50 then
			if arg2 == SPELL_FAILED_NOT_STANDING then
				DoEmote("STAND")
			elseif arg2 == SPELL_FAILED_NOT_MOUNTED then
				Dismount()
			end
		elseif arg1 == 159 then
			if arg2 == ERR_LOOT_NOTSTANDING then
				DoEmote("STAND")
			end
		elseif arg1 == 198 then
			if arg2 == ERR_ATTACK_MOUNTED then
				Dismount()
			end
		elseif arg1 == 213 then
			if arg2 == ERR_TAXIPLAYERALREADYMOUNTED then
				Dismount()
			end
		elseif arg1 == 504 then
			if arg2 == ERR_NOT_WHILE_MOUNTED then
				Dismount()
			end
		end
	elseif event == "TAXIMAP_OPENED" then
		Dismount()
	end
end

function S:Initialize()
--	CreateAutoQuestButton()
	self:CreateVehicleExit()
--	self:AutoCollect()
	self:ToggleEuiScriptPoi()
--	S:QuestLog()
--	OpenGrassionReport()
	
	SetCVar("taintLog", 0); --禁止一些污染报告
	SetCVar("xpBarText", 1) --显示经验条数值

	E.db.combattext = nil

	if E.db.euiscript.hovertip then
		SetCVar("alwaysCompareItems", "1")
	end

	QuestFrameGreetingPanel:HookScript("OnShow", function()
		for i = 1, MAX_NUM_QUESTS do
			local titleLine = _G["QuestTitleButton"..i];
			if (titleLine:IsVisible()) then
				local bulletPointTexture = _G[titleLine:GetName().."QuestIcon"];
				if (titleLine.isActive == 1) then
					bulletPointTexture:SetTexture("Interface\\GossipFrame\\ActiveQuestIcon");
				else
					bulletPointTexture:SetTexture("Interface\\GossipFrame\\AvailableQuestIcon");
				end
			end
		end
	end)

	---------------------------------------------------------------------------------------
	--	Alt+Click to buy a stack
	----------------------------------------------------------------------------------------
	hooksecurefunc("MerchantItemButton_OnModifiedClick", function(self)
		if IsAltKeyDown() then
			local itemLink = GetMerchantItemLink(self:GetID())
			if not itemLink then return end

			local maxStack = select(8, GetItemInfo(itemLink))
			if maxStack and maxStack > 1 then
				local numAvailable = select(5, GetMerchantItemInfo(self:GetID()))
				if numAvailable > -1 then
					BuyMerchantItem(self:GetID(), numAvailable)
				else
					BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
				end
			end
		end
	end)

	local function IsMerchantButtonOver()
		return GetMouseFocus():GetName() and GetMouseFocus():GetName():find("MerchantItem%d")
	end

	GameTooltip:HookScript("OnTooltipSetItem", function(self)
		if MerchantFrame:IsShown() and IsMerchantButtonOver() then
			for i = 2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft"..i]:GetText():find(ITEM_VENDOR_STACK_BUY) then
					GameTooltip:AddLine("|cff00ff00<"..L["MISC_BUY_STACK"]..">|r")
				end
			end
		end
	end)

	----------------------------------------------------------------------------------------
	--	Fix compare tooltips(by Blizzard)(../FrameXML/GameTooltip.lua)
	----------------------------------------------------------------------------------------
	hooksecurefunc("GameTooltip_ShowCompareItem", function(self, anchorFrame)
		if not self then
			self = GameTooltip
		end

		if not anchorFrame then
			anchorFrame = self.overrideComparisonAnchorFrame or self
		end

		if self.needsReset then
			self:ResetSecondaryCompareItem()
			GameTooltip_AdvanceSecondaryCompareItem(self)
			self.needsReset = false
		end

		local shoppingTooltip1, shoppingTooltip2 = unpack(self.shoppingTooltips)
		local primaryItemShown, secondaryItemShown = shoppingTooltip1:SetCompareItem(shoppingTooltip2, self)
		local leftPos = anchorFrame:GetLeft()
		local rightPos = anchorFrame:GetRight()

		local side
		local anchorType = self:GetAnchorType()
		local totalWidth = 0
		if primaryItemShown then
			totalWidth = totalWidth + shoppingTooltip1:GetWidth()
		end
		if secondaryItemShown then
			totalWidth = totalWidth + shoppingTooltip2:GetWidth()
		end
		if self.overrideComparisonAnchorSide then
			side = self.overrideComparisonAnchorSide
		else
			-- Find correct side
			local rightDist = 0
			if not rightPos then
				rightPos = 0
			end
			if not leftPos then
				leftPos = 0
			end

			rightDist = GetScreenWidth() - rightPos

			if anchorType and totalWidth < leftPos and (anchorType == "ANCHOR_LEFT" or anchorType == "ANCHOR_TOPLEFT" or anchorType == "ANCHOR_BOTTOMLEFT") then
				side = "left"
			elseif anchorType and totalWidth < rightDist and (anchorType == "ANCHOR_RIGHT" or anchorType == "ANCHOR_TOPRIGHT" or anchorType == "ANCHOR_BOTTOMRIGHT") then
				side = "right"
			elseif rightDist < leftPos then
				side = "left"
			else
				side = "right"
			end
		end

		-- See if we should slide the tooltip
		if anchorType and anchorType ~= "ANCHOR_PRESERVE" then
			if (side == "left") and (totalWidth > leftPos) then
				self:SetAnchorType(anchorType, (totalWidth - leftPos), 0)
			elseif (side == "right") and (rightPos + totalWidth) >  GetScreenWidth() then
				self:SetAnchorType(anchorType, -((rightPos + totalWidth) - GetScreenWidth()), 0)
			end
		end

		if secondaryItemShown then
			shoppingTooltip2:SetOwner(self, "ANCHOR_NONE")
			shoppingTooltip2:ClearAllPoints()
			shoppingTooltip1:SetOwner(self, "ANCHOR_NONE")
			shoppingTooltip1:ClearAllPoints()

			if side and side == "left" then
				shoppingTooltip1:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -3, -10)
			else
				shoppingTooltip2:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 3, -10)
			end

			if side and side == "left" then
				shoppingTooltip2:SetPoint("TOPRIGHT", shoppingTooltip1, "TOPLEFT", -3, 0)
			else
				shoppingTooltip1:SetPoint("TOPLEFT", shoppingTooltip2, "TOPRIGHT", 3, 0)
			end
		else
			shoppingTooltip1:SetOwner(self, "ANCHOR_NONE")
			shoppingTooltip1:ClearAllPoints()

			if side and side == "left" then
				shoppingTooltip1:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -3, -10)
			else
				shoppingTooltip1:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 3, -10)
			end

			shoppingTooltip2:Hide()
		end

		-- We have to call this again because :SetOwner clears the tooltip.
		shoppingTooltip1:SetCompareItem(shoppingTooltip2, self)
		shoppingTooltip1:Show()
	end)

	if ChatFrame1EditBox:IsShown() then ChatFrame1EditBox:Hide() end
	
--	self:RegisterEvent("TALKINGHEAD_REQUESTED", "ToggleTalkingHead")
	self:SecureHook('MerchantItemButton_OnModifiedClick', 'ByMaxNumber')

	self:SecureHook("UnitPopup_ShowMenu", "Pop_ShowMenu")
	self:RegisterEvent("MERCHANT_SHOW", 'SellItem')
--	self:RegisterEvent("ACHIEVEMENT_EARNED", "TakeScreen")

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "ButtonCollect")
	self:RegisterEvent("CHAT_MSG_WHISPER", "AutoInvite")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER", "AutoInvite")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "Announcements")

	self:RegisterEvent("TRADE_SHOW", "TradeTargetLevel")
	self:RegisterEvent("TRADE_CLOSED", "TradeTargetLevel")
	self:RegisterEvent("UI_ERROR_MESSAGE", "Dismount")
	self:RegisterEvent("TAXIMAP_OPENED", "Dismount")
end

E:RegisterModule(S:GetName())