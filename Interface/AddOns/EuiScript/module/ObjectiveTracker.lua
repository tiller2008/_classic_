local E, L = unpack(ElvUI)
if not E.db.euiscript.objectiveTrackerFrame then return end

local GetQuestIDFromLogIndex = GetQuestIDFromLogIndex
local ShowUIPanel = ShowUIPanel
local ipairs, tinsert, pairs = ipairs, tinsert, pairs
local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR
local QUEST_LOG = QUEST_LOG
local UNTRACK_QUEST_ABBREV = UNTRACK_QUEST_ABBREV
local HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR
local CURRENT_QUESTS = CURRENT_QUESTS
local GetNumQuestWatches = GetNumQuestWatches
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
local PlaySound = PlaySound


----------------------------------------------------------------------------------------
--	Move QuestWatchFrame (with ModernQuestWatch from Ketho - EU-Boulderfist)
----------------------------------------------------------------------------------------
local ObjectiveTracker = CreateFrame("Frame", "EuiObjectiveTrackerAnchor", UIParent)
ObjectiveTracker:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -238, -330)
ObjectiveTracker:SetHeight(150)
ObjectiveTracker:SetWidth(224)
ObjectiveTracker:SetFrameStrata("LOW")
E:CreateMover(ObjectiveTracker, 'EuiObjectiveTrackerMover', L["Watch Frame"], nil, nil, nil,'ALL,GENERAL')

local ClickFrames = {}

local function OnMouseUp(self)
	if IsShiftKeyDown() then -- untrack quest
		local questID = GetQuestIDFromLogIndex(self.questIndex)
		for index, value in ipairs(QUEST_WATCH_LIST) do
			if value.id == questID then
				tremove(QUEST_WATCH_LIST, index)
			end
		end
		RemoveQuestWatch(self.questIndex)
		QuestWatch_Update()
	else -- open to quest log
		if QuestLogEx then -- https://www.wowinterface.com/downloads/info24980-QuestLogEx.html
			ShowUIPanel(QuestLogExFrame)
			QuestLogEx:QuestLog_SetSelection(self.questIndex)
			QuestLogEx:Maximize()
		elseif ClassicQuestLog then -- https://www.wowinterface.com/downloads/info24937-ClassicQuestLogforClassic.html
			ShowUIPanel(ClassicQuestLog)
			QuestLog_SetSelection(self.questIndex)
		else
			ShowUIPanel(QuestLogFrame)
			QuestLog_SetSelection(self.questIndex)
			local valueStep = QuestLogListScrollFrame.ScrollBar:GetValueStep()
			QuestLogListScrollFrame.ScrollBar:SetValue(self.questIndex*valueStep/2)
		end
	end
	QuestLog_Update()
end

local function SetHighlightColor(self)
	self.watchText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b) -- 1, .82, 0
	for _, text in ipairs(self.objectiveTexts) do
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b) -- 1, 1, 1
	end
end

local function SetNormalColor(self)
	self.watchText:SetTextColor(.75, .61, 0)
	for _, text in ipairs(self.objectiveTexts) do
		text:SetTextColor(.8, .8, .8)
	end
end

local function OnEnter(self)
	if self.completed then
		SetNormalColor(self) -- use normal colors instead as highlight
	else
		SetHighlightColor(self)
	end
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT", 20, 20)
	GameTooltip:ClearLines()
	GameTooltip:AddLine("|cfffed100Click:|r "..QUEST_LOG.."\n|cfffed100Shift-Click:|r "..UNTRACK_QUEST_ABBREV, 1, 1, 1)
	GameTooltip:Show()
end

local function OnLeave(self)
	if self.completed then
		SetHighlightColor(self)
	else
		SetNormalColor(self)
	end
	GameTooltip:Hide()
end

local function CreateClickFrame(watchIndex, questIndex, watchText, objectiveTexts, completed)
	if not ClickFrames[watchIndex] then
		ClickFrames[watchIndex] = CreateFrame("Frame")
		ClickFrames[watchIndex]:SetScript("OnMouseUp", OnMouseUp)
		ClickFrames[watchIndex]:SetScript("OnEnter", OnEnter)
		ClickFrames[watchIndex]:SetScript("OnLeave", OnLeave)
	end
	local f = ClickFrames[watchIndex]
	f:SetAllPoints(watchText)
	f.watchIndex = watchIndex
	f.questIndex = questIndex
	f.watchText = watchText
	f.objectiveTexts = objectiveTexts
	f.completed = completed
end

local QuestWatchFrameHeader = CreateFrame("Frame", "QuestWatchFrameHeader", ObjectiveTracker)
--QuestWatchFrameHeader:CreatePanel("ClassColor", 1, 1, "TOPLEFT", QuestWatchFrame, "TOPRIGHT", 0, 0)
QuestWatchFrameHeader:SetPoint("TOPLEFT", QuestWatchFrame, "TOPRIGHT", 0, 0)
QuestWatchFrameHeader:Size(1,1)
QuestWatchFrameHeader:SetTemplate()
QuestWatchFrameHeader.Text = QuestWatchFrameHeader:CreateFontString(nil, "OVERLAY")
QuestWatchFrameHeader.Text:SetFont(E.media.normFont, E.db.general.questfontSize, "OUTLINE")
QuestWatchFrameHeader.Text:SetPoint("LEFT", QuestWatchFrameHeader, "LEFT", -2, 14)
QuestWatchFrameHeader.Text:SetText(CURRENT_QUESTS)

hooksecurefunc("QuestWatch_Update", function()
	QuestWatchFrame:SetParent(ObjectiveTrackerAnchor)
	QuestWatchFrame:ClearAllPoints()
	QuestWatchFrame:SetPoint("TOPLEFT", ObjectiveTracker, 0, 0)

	QuestWatchFrameHeader:SetPoint("TOPLEFT", QuestWatchFrame, "TOPLEFT", 0, 0)
	QuestWatchFrameHeader:SetPoint("TOPRIGHT", QuestWatchFrame, "TOPLEFT", QuestWatchFrame:GetWidth(), 0)

	-- Change font of watched quests/objectives
	for i = 1, 30 do
		local line = _G["QuestWatchLine"..i]
		line:SetFont(E.media.normFont, E.db.general.questfontSize)
		-- line:SetShadowColor(0, 0, 0, 0)
	end

	if GetNumQuestWatches() > 0 then
		ObjectiveTracker:Show()

		local questIndex, numObjectives, title, level, color, hex, watchText, objectivesGroup, objectivesCompleted, finished
		local watchTextIndex = 1
		for i = 1, GetNumQuestWatches() do
			questIndex = GetQuestIndexForWatch(i)
			if questIndex then
				numObjectives = GetNumQuestLeaderBoards(questIndex)
				title, level = GetQuestLogTitle(questIndex)
				color = GetQuestDifficultyColor(level)
				hex = E:RGBToHex(color.r, color.g, color.b)
				text = hex.."["..level.."] "..title

				if numObjectives > 0 then
					watchText = _G["QuestWatchLine"..watchTextIndex]
					watchText:SetText(text)

					watchTextIndex = watchTextIndex + 1
					objectivesGroup = {}
					objectivesCompleted = 0

					for j = 1, numObjectives do
						finished = select(3, GetQuestLogLeaderBoard(j, questIndex))
						if finished then
							watchText:SetTextColor(0, 1, 0)
							objectivesCompleted = objectivesCompleted + 1
						else
							watchText:SetTextColor(0.8, 0.8, 0.8)
						end
						if ( watchTextIndex > 1 ) then
							_G["QuestWatchLine"..watchTextIndex]:SetPoint("TOPLEFT", "QuestWatchLine"..(watchTextIndex - 1), "BOTTOMLEFT", 0, -(E.db.general.questfontSize-10));
						end
						tinsert(objectivesGroup, _G["QuestWatchLine"..watchTextIndex])
						watchTextIndex = watchTextIndex + 1
					end
					CreateClickFrame(i, questIndex, watchText, objectivesGroup, objectivesCompleted == numObjectives)
				end
			end
		end
		-- hide/show frames so it doesnt eat clicks, since we cant parent to a FontString
		for _, frame in pairs(ClickFrames) do
			frame[GetQuestIndexForWatch(frame.watchIndex) and "Show" or "Hide"](frame)
		end
	else
		ObjectiveTracker:Hide()
	end
end)

local function OnEvent(self, event, questIndex)
	-- tracking otherwise untrackable quests (without any objectives) would still count against the watch limit
	-- calling AddQuestWatch() while on the max watch limit silently fails
	if GetCVarBool("autoQuestWatch") and GetNumQuestLeaderBoards(questIndex) ~= 0 and GetNumQuestWatches() < MAX_WATCHABLE_QUESTS then
		AutoQuestWatch_Insert(questIndex, QUEST_WATCH_NO_EXPIRE)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("QUEST_ACCEPTED")
f:SetScript("OnEvent", OnEvent)

----------------------------------------------------------------------------------------
--	Expand / Collapse Button
----------------------------------------------------------------------------------------
local ExpandButton = CreateFrame("Button", "QuestWatchFrameExpandButton", ObjectiveTracker)
--ExpandButton:CreatePanel("Overlay", 17, 17, )
ExpandButton:Size(17)
ExpandButton:SetTemplate()
ExpandButton:SetPoint("TOPLEFT", QuestWatchFrameHeader, "TOPLEFT", -26, 22)
ExpandButton:EnableMouse(true)
ExpandButton:RegisterForClicks("AnyUp")
ExpandButton:SetFrameLevel(1)
ExpandButton:SetFrameStrata("HIGH")

ExpandButton.minus = ExpandButton:CreateTexture(nil, "OVERLAY")
ExpandButton.minus:SetSize(7, 1)
ExpandButton.minus:SetPoint("CENTER")
ExpandButton.minus:SetTexture(E.media.blankTex)

ExpandButton.plus = ExpandButton:CreateTexture(nil, "OVERLAY")
ExpandButton.plus:SetSize(1, 7)
ExpandButton.plus:SetPoint("CENTER")
ExpandButton.plus:SetTexture(E.media.blankTex)

ExpandButton.plus:Hide()

local expanded = true

local function QuestWatchCollapse()
	local f = ExpandButton
	f.plus:Show()
	QuestWatchFrame:Hide()
	QuestWatchFrameHeader:Hide()
end

local function QuestWatchExpand()
	local f = ExpandButton
	f.plus:Hide()
	QuestWatchFrame:Show()
	QuestWatchFrameHeader:Show()
end

ExpandButton:SetScript("OnMouseUp", function(self)
	expanded = not expanded
	PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
	if expanded then
		QuestWatchExpand()
	else
		QuestWatchCollapse()
	end
end)

----------------------------------------------------------------------------------------
--	Auto collapse QuestWatchFrame
----------------------------------------------------------------------------------------
local collapse = CreateFrame("Frame")
collapse:RegisterEvent("PLAYER_ENTERING_WORLD")
collapse:SetScript("OnEvent", function()
	if E.db.euiscript.auto_collapse then
		if IsInInstance() then
			E:Delay(2, QuestWatchCollapse)
			ExpandButton.plus:Show()
			expanded = false
		elseif not expanded and not InCombatLockdown() then
			E:Delay(2, QuestWatchExpand)
			ExpandButton.plus:Hide()
			expanded = true
		end
	end
end)

----------------------------------------------------------------------------------------
--	Move QuestTimerFrame (issues with the mover)
----------------------------------------------------------------------------------------
-- local ObjectiveTimer = CreateFrame("Frame", "ObjectiveTimerAnchor", UIParent)
-- ObjectiveTimer:SetPoint("BOTTOM", Minimap, "TOP", 0, 64)
-- ObjectiveTimer:SetHeight(80)
-- ObjectiveTimer:SetWidth(120)
-- E:CreateMover(ObjectiveTimer, 'EuiObjectiveTimerMover', L["QuestTimerFrame"], nil, nil, nil,'ALL,GENERAL')

-- QuestTimerFrame:StripTextures()
-- QuestTimerFrame:SetParent(ObjectiveTimer)
-- QuestTimerFrame:ClearAllPoints()
-- QuestTimerFrame:SetAllPoints(ObjectiveTimer)
