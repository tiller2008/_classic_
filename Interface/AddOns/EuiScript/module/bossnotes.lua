local E = unpack(ElvUI) -- Import Functions/Constants, Config, Locales
if E.db["euiscript"].bossnotes ~= true then return end

local SendChatMessage = SendChatMessage
local UnitName = UnitName
local pairs = pairs
local type = type
local ipairs = ipairs

--BOSS数据来源于Bigfoot
local function getRaidersByEncounterName(name)
	for i,k in pairs(E.Raiders_List) do
		for i,v in pairs(k) do
			if v.name == name then
				return v.raiders
			end
		end
	end
end

function E:SendBossNotes(bossname)
	local raidersText
	local encounterName
	if EncounterJournal and EncounterJournal.encounterID then
		encounterName = EJ_GetEncounterInfo(EncounterJournal.encounterID)
	end
	if bossname then
		raidersText = getRaidersByEncounterName(bossname) or "无此BOSS数据"
	elseif encounterName then
		raidersText = getRaidersByEncounterName(encounterName) or "无此BOSS数据"
		bossname = encounterName
	end
	if raidersText and bossname then
		bossname = 'EUI:' .. bossname
		if IsInRaid() then
			SendChatMessage(bossname, (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT") or "raid");
			SendChatMessage(raidersText, (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT") or "raid");
		elseif IsInGroup() then
			SendChatMessage(bossname, (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT") or "party");
			SendChatMessage(raidersText, (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT") or "party");
		else
			SendChatMessage(bossname, "say");
			SendChatMessage(raidersText, "say");
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("请选中BOSS为你的目标或打开地下城手册选择BOSS",1,0,0)
	end
end

SLASH_BOSS1 = "/boss"
SLASH_BOSS2 = "/BOSS"
SlashCmdList["BOSS"] = function(input)
	local bossname = UnitName("target")
	if bossname == nil then
		DEFAULT_CHAT_FRAME:AddMessage("请选中BOSS为你的目标",1,0,0)
		return
	end
	E:SendBossNotes(bossname)
end