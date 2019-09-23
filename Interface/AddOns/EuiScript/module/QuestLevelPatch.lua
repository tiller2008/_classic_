local E, L = unpack(ElvUI)
if not E.db.euiscript.QuestLevel then return; end

local LE_QUEST_FREQUENCY_DAILY = LE_QUEST_FREQUENCY_DAILY
local LE_QUEST_FREQUENCY_WEEKLY = LE_QUEST_FREQUENCY_WEEKLY
local format, pcall = format, pcall
local GetQuestLogTitle = GetQuestLogTitle


--add QuestLogTitle Level
local tags = {
	DAILY = "\226\128\162",
	GROUP = "+",
	SCENARIO = "s",
	DUNGEON = "d",
	HEROIC_DUNGEON = "d+",
	RAID = "r"
}

local function GetQuestTag(groupSize, frequency, tagId, tagName)
	local tag = ""
	if frequency == LE_QUEST_FREQUENCY_DAILY or frequency == LE_QUEST_FREQUENCY_WEEKLY then
		tag = tags.DAILY
	end
	if tagId == Enum.QuestTag.Group then
		tag = tag .. tags.GROUP
	elseif tagId == Enum.QuestTag.Scenario then
		tag = tag .. tags.SCENARIO
	elseif tagId == Enum.QuestTag.Dungeon then
		tag = tag .. tags.DUNGEON
	elseif tagId == Enum.QuestTag.Heroic then
		tag = tag .. tags.HEROIC_DUNGEON
	elseif QUEST_TAG_DUNGEON_TYPES[tagId] then
		tag = tag .. tags.RAID
	end
	return tag
end

local function GetTaggedTitle(i, color, tag)
	if not i or i == 0 then return nil end
	local title, level, groupSize, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory, isHidden, isScaling = GetQuestLogTitle(i)
	if not isHeader and title then
		local tagString = tag and GetQuestTag(groupSize, frequency, GetQuestTagInfo(questID)) or ""
		title = format("[%s%s] %s", level, tagString, title)
	end
	return title, level, groupSize, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory, isHidden, isScaling
end


local objective_count = "^(%d+)/(%d+) "

local function EnvironmentProxy()
	local env = setmetatable({
		GetQuestLogTitle = function(index)
			return GetTaggedTitle(index, false, true)
		end,
	}, {__index = _G})

	-- quest log
	pcall(setfenv, QuestLog_Update, env)

	-- quest watch
	if not E.db.euiscript.objectiveTrackerFrame then
		pcall(setfenv, QuestWatch_Update, env)
	end

	-- support the ClassicQuestLog addon
	if ClassicQuestLog and ClassicQuestLog.UpdateLog then
		pcall(setfenv, ClassicQuestLog.UpdateLog, env)
	end
end

EnvironmentProxy()