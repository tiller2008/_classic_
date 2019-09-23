local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local CH = E:GetModule('Chat')

local sub, gsub = string.sub, gsub
local GetChannelName = GetChannelName
local sort, tinsert = table.sort, table.insert
local CreateFrame = CreateFrame
local IsInGuild = IsInGuild
local CanEditOfficerNote = CanEditOfficerNote
local IsPartyLFG = IsPartyLFG
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local ChatFrame_OpenChat = ChatFrame_OpenChat
local C_Club_GetClubInfo = C_Club.GetClubInfo
local unpack = unpack

local Button = {};

local ChannelList = {
	[L["BigFootChannel"]] = sub(L["BigFootChannel"],7,9),
}

local BlackChannelName = {
	['EUIGVC'] = true,
	['ElvUIGVC'] = true,
}

local function ChannelShortText(index)
	local channelNum, channelName = GetChannelName(index);
	if not channelName or BlackChannelName[channelName] then return 0 end

	if strfind(channelName, 'Community') then
		local _, clubId, _ = strsplit(':', channelName);
		local clubInfo = C_Club_GetClubInfo(clubId)
		if clubInfo then
			channelName = clubInfo.shortName or clubInfo.name
		end
		return E:ShortenString(gsub(channelName, "%s%-%s.*", ""), 1);
	else
		if channelNum ~= 0 and channelName ~= '集合石' then
			if E.zhlocale and channelName == L["BigFootChannel"] then
				return ChannelList[L["BigFootChannel"]]
			else
				return E:ShortenString(gsub(channelName, "%s%-%s.*", ""), 1);
			end
		else
			return 0
		end
	end
end

local ChatTypesList = {
	['CHANNEL1'] = 1,
	['CHANNEL2'] = 2,
	['CHANNEL3'] = 3,
	['CHANNEL4'] = 4,
	['CHANNEL5'] = 5,
	['CHANNEL6'] = 6,
	['CHANNEL7'] = 7,
	['CHANNEL8'] = 8,
	['CHANNEL9'] = 9,	
	['CHANNEL10'] = 10,
	['SAY'] = {
		['name'] = E.zhlocale and L['says'] or 'S',
		['cmd'] = '/s ',
		['show'] = function() return true; end,
	},
	['YELL'] = {
		['name'] = E.zhlocale and L['yells'] or 'Y',
		['cmd'] = '/y ',
		['show'] = function() return true; end,
	},
	['GUILD'] = {
		['name'] = L['G'],
		['cmd'] = '/g ',
		['show'] = function() return IsInGuild() end,
	},
	['OFFICER'] = {
		['name'] = L['O'],
		['cmd'] = '/o ',
		['show'] = function() return CanEditOfficerNote() end,
	},
	['PARTY'] = {
		['name'] = L['P'],
		['cmd'] = '/p ',
		['show'] = function() return IsInGroup() or IsInRaid(); end,
	},
	['RAID'] = {
		['name'] = L['R'],
		['cmd'] = '/raid ',
		['show'] = function() return IsInRaid(); end,
	},
	['RAID_WARNING'] = {
		['name'] = L['RW'],
		['cmd'] = '/rw ',
		['show'] = function() return IsInRaid(); end,
	},
	['BATTLE_CHAT'] = {
		['name'] = L['BG'],
		['cmd'] = '/bg ',
		['show'] = function() local inInstance, instanceType = IsInInstance();local isInPVP = inInstance and (instanceType == "pvp"); return isInPVP end,
	},
}
local chatTypesList = {}
for k, v in pairs(ChatTypesList) do
	tinsert(chatTypesList, k)
end
sort(chatTypesList, function(a, b)
	return a < b
end)

local function ChannelButton(parent, width, height, postion, order, text, color)
	local f = CreateFrame("Button", nil, parent);
	f:Width(width);
	f:Height(height);
	f:SetPoint("LEFT", parent ,"LEFT", (postion == 1) and 5 or (5 + (postion - 1) * 20), 0);
	f:RegisterForClicks("AnyUp");
	f:SetScript("OnClick", function()
		local text = ''
		if ChatFrame1EditBox:IsShown() then
			text = ChatFrame1EditBox:GetText()
		end
		if not order:find(' ') then order = order..' ' end
		ChatFrame_OpenChat(order..text, SELECTED_DOCK_FRAME)
	end)
	
	if E.zhlocale and text == ChannelList[L["BigFootChannel"]] then color = {23/255, 132/255, 209/255}; end
	
	f.text = f:CreateFontString(nil, 'OVERLAY')
	f.text:FontTemplate()
	f.text:SetText(text)
	f.text:SetPoint("CENTER", 0, 0)	
	f.text:SetTextColor(unpack(color))
	
	f:SetScript("OnEnter", function(self)
		self.text:SetShadowColor(0.9, 0, 0, 0.8)
	end)
	f:SetScript("OnLeave", function(self)
		self.text:SetShadowColor(0, 0, 0, 0.2)
	end)
	
	f:Show()
	
	tinsert(Button, f);
end

local function GetChannelColor(name)
	if name and ChatTypeInfo[name] then
		return {ChatTypeInfo[name].r, ChatTypeInfo[name].g, ChatTypeInfo[name].b}
	else
		return {1,1,1}
	end
end

local function CreateChannelButton(chat)
	for i = 1, #Button do
		Button[i]:Hide()
		Button[i] = nil
	end
	wipe(Button)

	local i = 1

	for n = 1, #chatTypesList do
		if chatTypesList[n]:find('CHANNEL') and ChannelShortText(ChatTypesList[chatTypesList[n]]) ~= 0 then
			ChannelButton(chat, 16, 16, i, "/"..string.sub(chatTypesList[n],8)..' ', ChannelShortText(ChatTypesList[chatTypesList[n]]), GetChannelColor(chatTypesList[n]))
			i = i + 1
		end
		if not chatTypesList[n]:find('CHANNEL') then
			if ChatTypesList[chatTypesList[n]].show() then
				ChannelButton(chat, 16, 16, i, ChatTypesList[chatTypesList[n]].cmd, ChatTypesList[chatTypesList[n]].name, GetChannelColor(chatTypesList[n]))
				i = i + 1;
			end
		end
	end
end

function CH:LoadChatbar()
	if E.db["euiscript"].chatbar ~= true then return end
	local chat = CreateFrame("Frame", nil, LeftChatPanel)
	chat:Point("TOP", LeftChatPanel, "TOP", 0, -1)
	chat:Width(E.db["chat"].panelWidth)
	chat:Height(28)
	CH.chatbar = chat

--	CreateChannelButton(chat);
	chat:RegisterEvent("PLAYER_ENTERING_WORLD")
	chat:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
	chat:RegisterEvent("UPDATE_CHAT_COLOR");
--	chat:RegisterEvent("PARTY_MEMBERS_CHANGED");
	chat:RegisterEvent("RAID_ROSTER_UPDATE");
	chat:RegisterEvent("GROUP_ROSTER_UPDATE");
	chat:RegisterEvent("PLAYER_GUILD_UPDATE");
	chat:RegisterEvent("CLUB_ADDED");
	chat:RegisterEvent("CLUB_REMOVED");
	chat:SetScript("OnEvent", function(self)
		E:ScheduleTimer(CreateChannelButton, 0.5, chat) --fix
	end)

	--Bigfootcannel
	local big = CreateFrame("Button", "Bigfootcannel", self.chatbar)
	big:Point("RIGHT", self.chatbar, "RIGHT", -25, 0)
	big:Size(20)
	big:RegisterForClicks("AnyDown")
	big:SetNormalTexture("Interface\\Addons\\ElvUI\\media\\textures\\world")
	big:SetHighlightTexture("Interface\\Addons\\ElvUI\\media\\textures\\world-Highlight")
	if E.db.chat.autojoin then
		big:GetNormalTexture():SetDesaturated(false)
	else
		big:GetNormalTexture():SetDesaturated(true)
	end
	big:SetScript("OnClick", function(self)
		if E.db.chat.autojoin ~= true then
			JoinTemporaryChannel(L["BigFootChannel"])
			ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, L["BigFootChannel"])
			ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, L["BigFootChannel"])	
			E.db.chat.autojoin = true
			self:GetNormalTexture():SetDesaturated(false)
		else
			SlashCmdList["LEAVE"](L["BigFootChannel"])
			E.db.chat.autojoin = false
			self:GetNormalTexture():SetDesaturated(true)
		end
		E:Print(L["Enable/Disable"].. ' '..L["Auto join BigFootChannel"])
	end)
	big:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 6)
		GameTooltip:AddLine(L["Enable/Disable"].. ' '..L["Auto join BigFootChannel"])
		GameTooltip:Show()
	end)
	big:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	-- ROLL点
	local roll = CreateFrame("Button", "rollMacro", E.UIParent, "SecureActionButtonTemplate")
	roll:SetAttribute("*type*", "macro")
	roll:SetAttribute("macrotext", "/roll")
	roll:SetParent(self.chatbar)
	roll:Width(16);
	roll:Height(16);
	roll:SetPoint("RIGHT",self.chatbar,"RIGHT", -50,0);
	roll:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")
	roll:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Down")
	roll:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Highlight")
	
	local raidLv = CreateFrame("Button", "raidLv", E.UIParent, "SecureActionButtonTemplate")
	raidLv:SetAttribute("*type*", "macro")
	raidLv:SetAttribute("macrotext", "/run ToggleFrame(TinyInspectRaidFrame)")
	raidLv:SetParent(self.chatbar)
	raidLv:Width(16);
	raidLv:Height(16);
	raidLv:SetPoint("RIGHT",roll,"LEFT", -4,0);
	raidLv:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 6)
		GameTooltip:AddLine(RAID..'/'..PARTY..INFO)
		GameTooltip:Show()
	end)
	raidLv:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	raidLv:SetNormalTexture("Interface\\FriendsFrame\\InformationIcon")
	raidLv:SetPushedTexture("Interface\\FriendsFrame\\InformationIcon")
	raidLv:SetHighlightTexture("Interface\\FriendsFrame\\InformationIcon-Highlight");

	local Lock = CreateFrame("Button", nil, self.chatbar)
	Lock:Point("RIGHT",self.chatbar,"RIGHT", -5,0);
	Lock:Size(16, 16)
	Lock:RegisterForClicks('AnyDown')
	Lock:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\unlock")
	Lock:SetHighlightTexture("Interface\\AddOns\\ElvUI\\media\\textures\\unlock-Highlight")
	Lock:SetScript("OnClick", function(self, button)
		if button == 'LeftButton' then
			if ElvUIMoverPopupWindow and ElvUIMoverPopupWindow:IsShown() then
				E:ToggleMoveMode(false)
			else
				E:ToggleMoveMode()
			--	local Quester = LibStub("AceAddon-3.0"):GetAddon("Quester")
			--	if Quester then Quester:ToggleTrackerMovable(true) end
			end
		elseif button == 'RightButton' then
			ToggleFrame(ChannelFrame);
		end
	end)
	Lock:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 6)
	--	GameTooltip:AddLine(L["Unlock various elements of the UI to be repositioned."])
		GameTooltip:AddDoubleLine(L["Left Click:"], L["Unlock various elements of the UI to be repositioned."], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Right button:"], BINDING_HEADER_VOICE_CHAT, 1, 1, 1)

		GameTooltip:Show()
	end)
	Lock:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	if E.db["euiscript"].statreport then
		local statreport = CreateFrame("Button", nil, self.chatbar);
		statreport:Width(16);
		statreport:Height(16);
		statreport:SetPoint("RIGHT", (raidLv or roll), "LEFT", -4 , 0);
		statreport:RegisterForClicks("AnyUp");
		statreport:SetScript("OnClick", function(self, btn)
			if btn == "RightButton" and E.db["euiscript"].bossnotes then
				E:SendBossNotes(UnitName("target"))
			else
				CH:SendReport()
			end
		end)
		statreport:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\report")
		statreport:SetHighlightTexture("Interface\\AddOns\\ElvUI\\media\\textures\\report-Highlight")
			
		statreport:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 6)
			GameTooltip:AddLine(CH.L.INFO_DURABILITY_TIP)
			if E.db["euiscript"].bossnotes then
				GameTooltip:AddLine(CH.L.INFO_DURABILITY_TIP2)
			end
			GameTooltip:Show() 
		end)
		statreport:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
	if E.db.chat.emotionIcons then
		local Emote = E.ChatEmote;
		local ChatEmote = CreateFrame("Button", nil, self.chatbar)
		ChatEmote:SetPoint("RIGHT", (raidLv or roll), "LEFT", E.db["euiscript"].statreport and -24 or -4, 0)
		ChatEmote:Size(16)
		ChatEmote:SetScript("OnClick", function() Emote.ToggleEmoteTable() end)
		
		ChatEmote:SetNormalTexture("Interface\\AddOns\\ElvUI\\modules\\chat\\icon\\Smile")
		ChatEmote:SetHighlightTexture("Interface\\AddOns\\ElvUI\\modules\\chat\\icon\\Smile-Highlight")
		ChatEmote:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 6)
			GameTooltip:AddLine(Emote.tipstr)
			GameTooltip:Show()
		end)
		ChatEmote:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
end