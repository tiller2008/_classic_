local addonName, addOn = ...
local E, L = unpack(ElvUI)

BetterQuestFrame = CreateFrame("Frame", nil, UIParent)
local BQF = BetterQuestFrame
local AnchorFrame = CreateFrame("Frame")
local showAnchors = false
local isCollapsed = false
local showHidden = false
local IsInInstance = IsInInstance
local GetQuestLogTitle = GetQuestLogTitle
local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
local SelectQuestLogEntry = SelectQuestLogEntry
local GetQuestLogQuestText = GetQuestLogQuestText
local GetQuestIDFromLogIndex = GetQuestIDFromLogIndex
local GetCVar = GetCVar
local GetScreenHeight = GetScreenHeight
local GetScreenWidth = GetScreenWidth

local defaults = {
	version = 4,
	positionX = -50,
	positionY = 150,
	frameHeight = 500,
	frameWidth = 270,
	showQuestCount = true,
	questTitleFormat = "[[quest:level]][quest:title]",
}

function BQF:Initialize()
	if QuestWatchFrame:IsVisible() then
		QuestWatchFrame:Hide()
	end
	
	QuestWatchFrame.Show = QuestWatchFrame.Hide

	self:SetFrameStrata("BACKGROUND")
	self:SetMovable(true)
	self:SetClampedToScreen(true)
	self:SetUserPlaced(true)
	self:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"})
	self:SetBackdropColor(0, 0, 0, 0)
	self:SetPoint("RIGHT", "UIParent", "RIGHT", -50, 150)
	self:SetSize(self.db.frameWidth, self.db.frameHeight)
	E:CreateMover(self, 'EuiObjectiveTrackerMover', L["Watch Frame"], nil, nil, nil,'ALL,GENERAL', nil, 'euiscript,euiscript_general,questGroup')

	self.header = {}
	
	-- local background = self:CreateTexture(nil, "BACKGROUND")
	-- self.header.background = background
	-- background:SetWidth(296)
	-- background:SetHeight(90)
	-- background:SetPoint("TOPLEFT", -13, 15)
	-- background:SetAtlas("Objective-Header")
	
	local title = self:CreateFontString(nil, nil, "GameFontNormal")
	self.header.title = title
	title:FontTemplate(E.media.normFont, E.db.general.questfontSize, nil)
	
	title:SetText(L["Quest Frames"])
	title:SetPoint("TOPLEFT", 21, -8)

	local collapseButton = CreateFrame("BUTTON", nil, self)
	self.header.collapse = collapseButton
	collapseButton:SetWidth(15.5)
	collapseButton:SetHeight(15.5)
	collapseButton:SetPoint("TOPRIGHT", self, "TOPRIGHT", -4.5, -1.5)

	collapseButton:SetNormalTexture(E.Media.Textures.MinusButton)
--	collapseButton:SetHighlightTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Highlight.blp")
	collapseButton:SetScript("OnClick", function()
		if isCollapsed == true then
			isCollapsed = false
			collapseButton:SetNormalTexture(E.Media.Textures.MinusButton)
		else
			isCollapsed = true
			collapseButton:SetNormalTexture(E.Media.Textures.PlusButton)
		end		
		self:LoadQuests()
	end)
	
	local showHiddenButton = CreateFrame("CHECKBUTTON", nil, self, "UICheckButtonTemplate")
	self.header.showHidden = showHiddenButton
	showHiddenButton:SetSize(14.5, 14.5)
	showHiddenButton:SetPoint("TOPRIGHT", collapseButton, "TOPLEFT", 1, -1)
	showHiddenButton:SetScript("OnClick", function()
		showHidden = not(showHidden)
		self:LoadQuests()
	end)

	local accept = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate")
	accept:SetSize(14.5, 14.5)
	accept.text:SetText(L["idQuestAutomation"]);
	accept.text:FontTemplate(E.media.normFont, E.db.general.questfontSize-2, nil)
	accept:SetPoint("BOTTOMLEFT", title, "TOPLEFT", 0, 4)
	accept:SetScript("OnClick", function(self)
		E.db["euiscript"].idq = not E.db["euiscript"].idq;
		if CodexConfig and E.db["euiscript"].idq then
			CodexConfig.autoAccept = true
			CodexConfig.autoTurnin = true
			E.db["euiscript"].idq = false
		end
	end)
	accept:SetChecked(E.db["euiscript"].idq);
	self.acceptCheck = accept

	-- local LockFrame = CreateFrame("Button")
	-- LockFrame:SetPoint("LEFT", title, "RIGHT", 4, 0)
	-- LockFrame.lock = LockFrame:CreateTexture()
	-- LockFrame.lock:SetAllPoints(LockFrame)
	-- LockFrame.lock:SetTexture("Interface\\GuildFrame\\GuildFrame")
	-- LockFrame.lock:SetTexCoord(0.51660156, 0.53320313, 0.92578125, 0.96679688)
	-- LockFrame:SetSize(14.5, 14.5)
	-- LockFrame:SetScript("OnClick", function() BQF:ToggleAnchors() end)

	self.checkBoxes = {}
	self.fontStrings = {}
	self.clickFrames = {}
	
end

local function BQFCollapsed()
	isCollapsed = true
	self:LoadQuests()
end

function BQF:LoadQuests()
	
	local hiddenQuests = BetterQuestFrameCharDB
	local newHidden = {}
	
	-- Config Values
	local showQuestCount = self.db.showQuestCount
	local questTitleFormat = self.db.questTitleFormat
	
	local numEntries, _ = GetNumQuestLogEntries()
	local totalQuestCount = 0
	local visibleQuestCount = 0
	local textLines = 0
	
	for i = 1, numEntries, 1
	do
		local title, level, _, isHeader, _, isComplete, _, questID, _, _, _, _, _, _ = GetQuestLogTitle(i);
		
		if not isHeader then
		
			totalQuestCount = totalQuestCount + 1
			
			local showQuest = true

			if hiddenQuests[questID] ~= nil then
				showQuest = hiddenQuests[questID]
			end
			
			newHidden[questID] = showQuest
			
			if (showHidden == true or showQuest == true) and isCollapsed ~= true then
			
				visibleQuestCount = visibleQuestCount + 1				
				textLines = textLines + 1
				
				if not self.checkBoxes[visibleQuestCount] then
					self.checkBoxes[visibleQuestCount] = CreateFrame("CHECKBUTTON", nil, nil, "UICheckButtonTemplate")
				end
				
				local checkButton = self.checkBoxes[visibleQuestCount]
				checkButton:SetSize(14.5, 14.5)
				checkButton:SetChecked(showQuest)
				checkButton.questID = questID
				checkButton:SetScript("OnClick", function(cBtn)
					BetterQuestFrameCharDB[cBtn.questID] = not(BetterQuestFrameCharDB[cBtn.questID])
				end)
				
				if visibleQuestCount == 1 then			
					checkButton:SetPoint("TOPLEFT", self.header.title, "BOTTOMLEFT", -13.5, -7)
				else
					checkButton:SetPoint("TOP", self.fontStrings[textLines - 1], "BOTTOM", 3, 0)
					checkButton:SetPoint("LEFT", self.checkBoxes[visibleQuestCount - 1], "LEFT", 0, 0)
				end
				
				if showHidden == true then
					checkButton:Show()
				else
					checkButton:Hide()
				end
					
				local questHeader = questTitleFormat
				questHeader = string.gsub(questHeader, "%[quest:title%]", title)
				questHeader = string.gsub(questHeader, "%[quest:level%]", level)
				
				if not self.fontStrings[textLines] then
					self.fontStrings[textLines] = self:CreateFontString(nil, nil, "GameFontNormal")
					self.fontStrings[textLines]:FontTemplate(E.media.normFont, E.db.general.questfontSize, nil)
				end
		
				local questTitle = self.fontStrings[textLines]
				questTitle:Show()
				questTitle:SetText(questHeader)
				questTitle:SetJustifyH("LEFT")
				
				if isComplete then
					questTitle:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b) -- 1, .82, 0			
				else
					questTitle:SetTextColor(.75, .61, 0)
				end
				
				questTitle:SetPoint("TOPLEFT", checkButton, "TOPRIGHT", 3, -4)
				
				local objectivesCount = GetNumQuestLeaderBoards(i)
				local objectives = {}
				
				if objectivesCount > 0 then			
					for j = 1, objectivesCount, 1
					do
						textLines = textLines + 1
						
						local desc, _, done = GetQuestLogLeaderBoard(j, i)
						
						if not self.fontStrings[textLines] then
							self.fontStrings[textLines] = self:CreateFontString(nil, nil, "GameFontNormal")
							self.fontStrings[textLines]:FontTemplate(E.media.normFont, E.db.general.questfontSize, nil)
						end
						
						local objectiveText = self.fontStrings[textLines]
						objectiveText:Show()
						objectiveText:SetText(" - " .. desc)
						objectiveText:SetJustifyH("LEFT")
						
						if done then
							objectiveText:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b) -- 1, 1, 1
						else
							objectiveText:SetTextColor(.8, .8, .8)
						end
						
						objectiveText:SetPoint("TOPLEFT", self.fontStrings[textLines - 1], "BOTTOMLEFT", 0, -1)
						objectiveText:SetPoint("RIGHT", self, "RIGHT", -5, 0)
						
						local objective = {}
						objective.text = objectiveText
						objective.done = done
						tinsert(objectives, objective)
					end
				else
					textLines = textLines + 1			
					
					SelectQuestLogEntry(i);
					local _, desc = GetQuestLogQuestText()

					if not self.fontStrings[textLines] then
						self.fontStrings[textLines] = self:CreateFontString(nil, nil, "GameFontNormal")
						self.fontStrings[textLines]:FontTemplate(E.media.normFont, E.db.general.questfontSize, nil)
					end
					
					local objectiveText = self.fontStrings[textLines]
					objectiveText:Show()
					objectiveText:SetText(" - " .. desc)
					objectiveText:SetJustifyH("LEFT")
					objectiveText:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b) -- 1, 1, 1
					objectiveText:SetPoint("TOPLEFT", self.fontStrings[textLines - 1], "BOTTOMLEFT", 0, -1)
					objectiveText:SetPoint("RIGHT", self, "RIGHT", -5, 0)
					
					local objective = {}
					objective.text = objectiveText
					objective.done = true
					tinsert(objectives, objective)
					
					objectivesCount = 1
				end
				
				BQF:SetClickFrame(visibleQuestCount, i, questTitle, objectives, isComplete)
				
			end
		end
	end
		
	if table.getn(self.checkBoxes) > visibleQuestCount then
		for i = visibleQuestCount + 1, table.getn(self.checkBoxes), 1 do
			self.checkBoxes[i]:Hide()
			self.checkBoxes[i] = nil
		end
	end
	
	if table.getn(self.fontStrings) > textLines then
		for i = textLines + 1, table.getn(self.fontStrings), 1 do
			self.fontStrings[i]:Hide()
			self.fontStrings[i] = nil
		end
	end
	
	if table.getn(self.clickFrames) > visibleQuestCount then
		for i = visibleQuestCount + 1, table.getn(self.clickFrames), 1 do
			self.clickFrames[i]:Hide()
			self.clickFrames[i] = nil
		end
	end
	
	self:RefreshSize()
--	self:RefreshPosition()
			
	local headerText = L["Quest Frames"]
	
	if showQuestCount then
		headerText = headerText .. " (" .. totalQuestCount .. "/20)"
	end	

	if totalQuestCount>0 then
		self:Show()
	else
		self:Hide()
	end

	self.header.title:SetText(headerText)
	
	BetterQuestFrameCharDB = CopyTable(newHidden)
end

local function OnMouseUp(self)
	if IsShiftKeyDown() then -- untrack quest
		local questID = GetQuestIDFromLogIndex(self.questIndex)
		BetterQuestFrameCharDB[questID] = not(BetterQuestFrameCharDB[questID])
		BQF:LoadQuests()
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
end

local function OnEnter(self)
	if self.completed then
		-- use normal colors instead as highlight
		self.headerText:SetTextColor(.75, .61, 0)
		for _, objective in ipairs(self.objectives) do
			objective.text:SetTextColor(.8, .8, .8)
		end
	else
		self.headerText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b) -- 1, .82, 0
		for _, objective in ipairs(self.objectives) do
			objective.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b) -- 1, 1, 1
		end
	end
end

local function OnLeave(self)
	if self.completed then
		self.headerText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b) -- 1, .82, 0
		for _, objective in ipairs(self.objectives) do
			objective.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b) -- 1, 1, 1
		end
	else
		self.headerText:SetTextColor(.75, .61, 0)
		for _, objective in ipairs(self.objectives) do
			if objective.done then
				objective.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b) -- 1, 1, 1
			else
				objective.text:SetTextColor(.8, .8, .8)
			end
		end
	end
end

function BQF:SetClickFrame(index, questIndex, headerText, objectives, completed)
	if not self.clickFrames[index] then
		self.clickFrames[index] = CreateFrame("Frame")
		self.clickFrames[index]:SetScript("OnMouseUp", OnMouseUp)
		self.clickFrames[index]:SetScript("OnEnter", OnEnter)
		self.clickFrames[index]:SetScript("OnLeave", OnLeave)
	end
	local f = self.clickFrames[index]
	f:SetAllPoints(headerText)
	f.questIndex = questIndex
	f.headerText = headerText
	f.objectives = objectives
	f.completed = completed
end

function BQF:RefreshSize()
	self:SetSize(self.db.frameWidth, self.db.frameHeight)	
end

local function round(num)
  return math.floor(num + 0.5)
end

function BQF:GetResolution()
	local scale = string.match(GetCVar("gxWindowedResolution"), "%d+x(%d+)");
	local uiScale = UIParent:GetScale()	
	local realScale = 768 / scale / uiScale	
	
	return {
		height = math.floor(GetScreenHeight() / realScale + 0.5),
		width = math.floor(GetScreenWidth() / realScale + 0.5),
	}
end

function BQF:ToggleAnchors()
	if showAnchors == false then
		self:EnableMouse(true)
		self:SetBackdropColor(0, 0, 0, .5)
		showAnchors = true
	else
		self:EnableMouse(false)
		self:SetBackdropColor(0, 0, 0, 0)
		-- avoid getting stuck to the cursor when alt is released while dragging
		self:StopMovingOrSizing()
		showAnchors = false
	end
end

function BQF:ADDON_LOADED(addon)
	if addon == 'ClassicCodex' then
		if E:IsConfigurableAddOn('ClassicCodex') and CodexConfig then
			if CodexConfig.autoAccept or CodexConfig.autoTurnin then
				E.db["euiscript"].idq = false
				self.acceptCheck:SetChecked(true)
			else
				self.acceptCheck:SetChecked(E.db["euiscript"].idq)
			end
		end
	end
	if addon == 'EuiScript' and E.db.euiscript.objectiveTrackerFrame then
		if not BetterQuestFrameDB or BetterQuestFrameDB.version == nil or BetterQuestFrameDB.version < defaults.version then
			BetterQuestFrameDB = CopyTable(defaults)
		end
		if not BetterQuestFrameCharDB then
			BetterQuestFrameCharDB = {}
		end
		self.db = BetterQuestFrameDB
		self:Initialize()
	--	self:RefreshPosition()
	--	self:UnregisterEvent("ADDON_LOADED")
		self:RegisterEvent("QUEST_LOG_UPDATE")
		self:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
	end
end

function BQF:QUEST_WATCH_LIST_CHANGED()
	self:LoadQuests()
end

function BQF:QUEST_LOG_UPDATE(unitTarget)
	self:LoadQuests()
end

function BQF:PLAYER_ENTERING_WORLD()
	if E.db.euiscript.auto_collapse then
		if IsInInstance() then
			isCollapsed = true
			self:LoadQuests()
		else
			isCollapsed = false
			self:LoadQuests()
		end
	end
end

function BQF:OnEvent(event, ...)
	self[event](self, ...)
end

-- DEFAULT_CHAT_FRAME:AddMessage("Test")

BQF:RegisterEvent("ADDON_LOADED")
BQF:SetScript("OnEvent", BQF.OnEvent)
