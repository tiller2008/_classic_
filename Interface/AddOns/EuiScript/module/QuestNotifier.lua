local E, L = unpack(ElvUI) -- Import Functions/Constants, Config, Locales

--## Version: 8.0.2
--## Author: Gentoo/Asem/聂荣/才人/大爱无疆/Suse/我真的是上帝/siweia
--2014/1/2修改并精简代码 by eui.cc
--2014/10/29 针对wod修改API by eui.cc
--2016/10/28 modify by eui.cc for 7.1
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestLink = GetQuestLink
local IsQuestWatched = IsQuestWatched
local RemoveQuestWatch = RemoveQuestWatch
local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
local SendChatMessage = SendChatMessage
local IsInGroup, IsInRaid, LE_PARTY_CATEGORY_HOME, LE_PARTY_CATEGORY_INSTANCE, UnitInParty, UnitInRaid = IsInGroup, IsInRaid, LE_PARTY_CATEGORY_HOME, LE_PARTY_CATEGORY_INSTANCE, UnitInParty, UnitInRaid
local find, pairs = string.find, pairs

local QN_Locale   = {
	["Colon"]       = ":",
	["Quest"]       = "Quest",
	["Progress"]    = "Progress",
	["Complete"]    = "Completed!", 
	["Accept"]      = "AcceptQuest",
}
if GetLocale() == 'zhCN' then
	QN_Locale = {
		["Colon"]       = "：",
		["Quest"]       = "任务",
		["Progress"]    = "进度",
		["Complete"]    = "已完成!",
		["Accept"]      = "接受任务",
	}
elseif GetLocale() == 'zhTW' then
	QN_Locale = {
		["Colon"]       = ":",
		["Quest"]       = "任務",
		["Progress"]    = "進度",
		["Complete"]    = "已完成!",
		["Accept"]      = "接受任務",
	}
end

local function PrtChatMsg(msg)
	if (not IsInGroup(LE_PARTY_CATEGORY_HOME) or IsInRaid(LE_PARTY_CATEGORY_HOME)) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		if E.db.euiscript.questnoti.Instance == true then
		  SendChatMessage(msg, "INSTANCE_CHAT", nil)
		end
	elseif UnitInRaid("player") then
		if E.db.euiscript.questnoti.Raid == true then
		  SendChatMessage(msg, "RAID", nil)
		end
	elseif UnitInParty("Party1") then
		if E.db.euiscript.questnoti.Party == true then
		  SendChatMessage(msg, "PARTY", nil)
		end
	else
		if E.db.euiscript.questnoti.Solo == true then
		  SendChatMessage(msg, "SAY", nil)
		end
	end
end

--[[ QuestAnnounce ZeichenTabelle Chinese]]--
local QUEST_INFO_REGEX = "(.*):%s*([-%d]+)%s*/%s*([-%d]+)%s*$"
	if (GetLocale() == "zhCN") then
		QUEST_INFO_REGEX = "(.*)：%s*([-%d]+)%s*/%s*([-%d]+)%s*$"
end

local QN = CreateFrame("Frame")
QN:RegisterEvent("UI_INFO_MESSAGE")
QN:SetScript("OnEvent", function(self, event, id, msg)
	if (msg ~= nil) then
		if (E.db.euiscript.questnoti.enable) then
			local questText = gsub(msg, QUEST_INFO_REGEX, "%1", 1)

			if (questText ~= msg) then
				local ii, jj, strItemName, iNumItems, iNumNeeded = string.find(msg, QUEST_INFO_REGEX)
				local stillNeeded = iNumNeeded - iNumItems

				if(stillNeeded == 0 and E.db.euiscript.questnoti.every == 0) then
					PrtChatMsg(QN_Locale["Completed"]..QN_Locale["Colon"]..msg)
				elseif(E.db.euiscript.questnoti.every > 0) then
					local every = math.fmod(iNumItems, E.db.euiscript.questnoti.every)

					if(every == 0 and stillNeeded > 0) then
						PrtChatMsg(QN_Locale["Progress"]..QN_Locale["Colon"]..msg)
					elseif(stillNeeded == 0) then
						PrtChatMsg(QN_Locale["Completed"]..QN_Locale["Colon"]..msg)
					end
				end
			end
		end
	end
end)