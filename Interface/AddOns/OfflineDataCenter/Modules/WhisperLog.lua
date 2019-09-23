local MAX_MSG_ITEMS_STORAGED = 1000
local MAX_MSG_ITEMS_DISPLAY = 60
local FRAMENAME = "ODCFrameWhisperSubFrame"
-- local ODC_TIMESTAMP = TIMESTAMP_FORMAT_HHMMSS_24HR
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local ODC = LibStub("AceAddon-3.0"):GetAddon("OfflineDataCenter")
local ODC_SMF = ODC:GetModule("ScrollingMessageFrame")
if not ODC_SMF then return end
local Module = ODC:NewModule("OfflineWhisperLog", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("OfflineDataCenter")
Module.description = L["Offline Whisper Log"]
Module.type = "tab"
Module.name = "OfflineWhisperLog"
Module.tabs = {
	["whisperlog"] = {
		Textures = "Interface\\AddOns\\OfflineDataCenter\\Textures\\Ability_Warrior_RallyingCry",
		Tooltip = L['Offline Whisper Log'],
		CallTabFunc = function()
			ODC_SMF:CreateOrShowSubFrame("whisperlog", Module.OutputFunc)
		end,
		CharChangedFunc = function()
			ODC_SMF:CreateOrShowSubFrame("whisperlog", Module.OutputFunc)
		end,
		Settings = {
			type = "group",
			name = L['Offline Whisper Log'],
			order = 1,
			args = {
				group1 = { 
					type = "group", order = 1, 
					name = L['Offline Whisper Log'],guiInline = true, 
					args = { 
						enable = {
							type = "toggle",
							name = ENABLE,
							order = 1,
							set = function(info,val)
								if val then
									ODC:EnableTab("whisperlog")
								else
									ODC:DisableTab("whisperlog")
								end
							end,
							get = function(info)
								return ODC_Config.toggle.whisperlog
							end,
						}, 
					} 
				},
				group2 = { 
					type = "group", order = 2, 
					name = " ",guiInline = true, 
					disabled = function() return ODC_Config.toggle.whisperlog == false end,
					args = { 
						-- timestamp = {
							-- type = "select",
							-- name = "Auto whisper",
							-- desc = "Enables / disables auto whisper",
							-- order = 1,
							-- values = {
								-- whisper = WHISPER,
								-- say = SAY,
								-- yell = YELL,
								-- party = PARTY,
								-- raid = RAID,
								-- none = NONE,
							-- },
							-- set = function(info,val)
								-- ODC_Config.Options.tradelog.autowhisper = val
							-- end,
							-- get = function(info)
								-- return ODC_Config.Options.tradelog.autowhisper
							-- end,
						-- },
						maxmsg = {
							type = "range",
							name = L["Maximum messages"],
							order = 2,
							min = 50, max = 1000, step = 1,
							set = function(info,val)
								ODC_Config.Options.whisperlog.maxmsg = val
							end,
							get = function(info)
								return ODC_Config.Options.whisperlog.maxmsg
							end,
						},
						-- maxmsgdisp = {
							-- type = "range",
							-- name = "Maximum messages display",
							-- desc = "Maximum messages to display",
							-- order = 2,
							-- min = 30, max = 500, step = 1,
							-- set = function(info,val)
								-- if tonumber(val) > 0 and tonumber(val) < 999 then
									-- ODC_Config.Options.whisperlog.maxmsgdisp = val
								-- end
							-- end,
							-- get = function(info)
								-- return ODC_Config.Options.whisperlog.maxmsgdisp
							-- end,
						-- },
					} 
				},
			},
		},
		DefaultConfig = {
			maxmsg = 500,		
		},
	},
}

local playername, selectChar, selectTab = ODC.playername, ODC.selectChar, ODC.selectTab

local function CheckDBLoad()
	while table.getn(ODC_DB[playername]["whisperlog"]) >= MAX_MSG_ITEMS_STORAGED do
		table.remove(ODC_DB[playername]["whisperlog"], 1)
	end
end

local function AddMessage(message, recipient, type)
	CheckDBLoad()
	local t = {}
	table.insert(t, message)
	table.insert(t, recipient)
	table.insert(t, time())
	table.insert(t, type)
	table.insert(ODC_DB[playername]["whisperlog"], t)
	if ODC.Frame:IsVisible() and selectChar == playername and selectTab == "whisperlog" then
		ODC_SMF:CreateOrShowSubFrame("whisperlog", Module.OutputFunc)
	end
end
--[[
ODC_DB[charName] structure:
					WhisperID	content
["whisperlog"]= {	[1]			[1] = message
								[2] = recipient
								[3] = tick
								[4] = type
]]
--[[
TIMESTAMP_FORMAT_HHMM = "%I:%M ";
TIMESTAMP_FORMAT_HHMMSS = "%I:%M:%S ";
TIMESTAMP_FORMAT_HHMMSS_24HR = "%H:%M:%S ";
TIMESTAMP_FORMAT_HHMMSS_AMPM = "%I:%M:%S %p ";
TIMESTAMP_FORMAT_HHMM_24HR = "%H:%M ";
TIMESTAMP_FORMAT_HHMM_AMPM = "%I:%M %p ";
]]
-- local chatTypes = {
	-- BN_WHISPER_INFORM = CHAT_WHISPER_SEND,
		
	-- WHISPER_INFORM = CHAT_WHISPER_SEND,

-- }

local function FormatMessage(m)
	local text = ""
	if ODC_SMF.TIMESTAMP then
		text = "["..BetterDate(ODC_SMF.TIMESTAMP, m[3]).."] "
	end
	if m[4] == "BN_WHISPER_INFORM" or m[4] == "WHISPER_INFORM" then
		text = text..format(CHAT_WHISPER_SEND, (m[2] or "???"))..m[1]
	else
		text = text..format(CHAT_WHISPER_GET, (m[2] or "???"))..m[1]
	end
	return text
end

local function InsertText(f, firstPage, s, type)
	if type then
		local info = ChatTypeInfo[type];--msgType[type]
		f:AddMessage(s, info.r, info.g, info.b, info.id);
	else
		f:AddMessage(s);
	end

--	if f:GetNumMessages() == f:GetNumLinesDisplayed() then
		firstPage = f:GetNumMessages()
--	end

	return firstPage
end

Module.OutputFunc = function(f, thisDay, firstPage, searchText)
	for i, t in ipairs(ODC_DB[selectChar]["whisperlog"]) do
		if not thisDay or date("%x", t[3]) ~= thisDay then
			thisDay = date("%x", t[3])
			if not searchText then
				firstPage = InsertText(f, firstPage, date("=== %Y-%m-%d ===", t[3]))
			end
		end
		if not searchText or string.find(t[1], searchText) or string.find(t[2], searchText) then
			firstPage = InsertText(f, firstPage, FormatMessage(t), t[4])
		end
	end
	return firstPage
end

local function GetClassColor(name, class)
	if class and RAID_CLASS_COLORS[class] then
		return "|c"..RAID_CLASS_COLORS[class].colorStr..name.."|r"
	else
		return name;
	end
end

local function GetBNFriendColor(name, class, game)
	if game ~= BNET_CLIENT_WOW or not class then
		return name
	else
		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
		for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end

		return GetClassColor(name, class)
	end
end

local function ProcessBN(event, arg2, arg13)
	local type = strsub(event, 10);
	-- local hasFocus, toonName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = BNGetGameAccountInfo(arg13);
	local hasFocus, toonName, client, realmName, _, _, _, localizedClass = BNGetGameAccountInfo(arg13);
	-- local presenceID, RealID, BattleTag = BNGetFriendInfoByID(arg13)
	-- local realName = RealID or BattleTag or ""
	if (toonName and toonName ~= "" and client and client ~= "") then
		toonName = GetBNFriendColor(toonName, localizedClass, client)
		-- return format("[%s] (%s)", arg2, BNet_GetClientEmbeddedTexture(client, 14)..toonName);
		return format("|HBNplayer:%s:%s|h[%s]|h (%s)", arg2, arg13, arg2, BNet_GetClientEmbeddedTexture(client, 14)..toonName);
		--format("|HBNplayer:%s:%s:%s:%s:%s|h[%s]|h", arg2, arg13, arg11, Chat_GetChatCategory(type)--BN_WHISPER, arg8, arg2);
	else
		-- return format("[%s]", arg2);
		return format("|HBNplayer:%s:%s|h[%s]|h", arg2, arg13, arg2);
	end
end

function Module:CHAT_MSG_WHISPER(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
	if arg6 == "GM" then
		local pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
		arg2 = pflag..format("|Hplayer:%s|h[%s]|h", arg2, arg2);
	elseif arg12 then
		local _, englishClass = GetPlayerInfoByGUID(arg12)
		arg2 = format("|Hplayer:%s|h[%s]|h", arg2, GetClassColor(arg2, englishClass));
	end
	local type = strsub(event, 10);
	AddMessage(arg1, arg2, type)
	--"|Hplayer:"..trade.target.."|h"..GetClassColor(trade.target, trade.class).."|h"
end

function Module:CHAT_MSG_WHISPER_INFORM(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
	if arg6 == "GM" then
		local pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
		arg2 = pflag..format("|Hplayer:%s|h[%s]|h", arg2, arg2);
	elseif arg12 then
		local _, englishClass = GetPlayerInfoByGUID(arg12)
		arg2 = format("|Hplayer:%s|h[%s]|h", arg2, GetClassColor(arg2, englishClass));
	end
	local type = strsub(event, 10);
	AddMessage(arg1, arg2, type)
end

function Module:CHAT_MSG_BN_WHISPER(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13)
	arg2 = ProcessBN(event, arg2, arg13)
	local type = strsub(event, 10);
	AddMessage(arg1, arg2, type)
end

function Module:CHAT_MSG_BN_WHISPER_INFORM(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13)
	arg2 = ProcessBN(event, arg2, arg13)
	local type = strsub(event, 10);
	AddMessage(arg1, arg2, type)
end

Module.selectTabCallbackFunc = function(selectedTab)
	selectTab = selectedTab
end

Module.selectCharCallbackFunc = function(selectedChar)
	selectChar = selectedChar
end

function Module:OnInitialize()
	if ODC_Config.toggle.whisperlog == nil then ODC_Config.toggle.whisperlog = true end
	ODC:SetDefaultConfig(self.tabs)
	ODC:AddAvaliableTab("whisperlog", self)
end

function Module:OnEnable()
	if ODC_Config.toggle.whisperlog then
		if not ODC_DB[playername]["whisperlog"] then
			ODC_DB[playername]["whisperlog"] = {}
		end
		ODC:AddTab("whisperlog", self.tabs["whisperlog"])
		ODC:AddModule(self)
		self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
		self:RegisterEvent("CHAT_MSG_WHISPER")
		self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
		self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	end
end

function Module:OnDisable()
	if not ODC_Config.toggle.whisperlog then
		ODC:RemoveTab("whisperlog")
		ODC:RemoveModule(self)
		self:UnregisterEvent("CHAT_MSG_WHISPER_INFORM")
		self:UnregisterEvent("CHAT_MSG_WHISPER")
		self:UnregisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
		self:UnregisterEvent("CHAT_MSG_BN_WHISPER")
	end
end