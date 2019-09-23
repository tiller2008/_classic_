local ODC = LibStub("AceAddon-3.0"):GetAddon("OfflineDataCenter")
local Module = ODC:NewModule("ScrollingMessageFrame", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("OfflineDataCenter")
--Module.description =
Module.type = "subFrame"
Module.name = "ScrollingMessageFrame"

local len, sub, find, format, match = string.len, string.sub, string.find, string.format, string.match
local playername, selectChar, selectTab = ODC.playername, ODC.selectChar, ODC.selectTab
local OutputFunc
Module.TIMESTAMP = TIMESTAMP_FORMAT_HHMMSS_24HR

local FRAMENAME = "ODCFrameScrollingMessageSubFrame"


local function OutputLog(f, searchText)
	local thisDay, firstPage
	f.messageFrame:Clear()
	if not ODC_DB[ODC.selectChar][ODC.selectTab] then return end

	firstPage = OutputFunc(f.messageFrame, thisDay, firstPage, searchText)

	if not firstPage then firstPage = 0 end
	f.scrollBar:SetMinMaxValues(firstPage, f.messageFrame:GetNumMessages())
	f.scrollBar:SetValue(f.messageFrame:GetNumMessages())
end

local function MessageFrameScroll(self, delta)
	if (delta > 0) then
		if IsShiftKeyDown() then
			self:ScrollToTop()--PageUp()
		else
			self:ScrollUp()
		end
	else
		if IsShiftKeyDown() then
			self:ScrollToBottom()--PageDown()
		else
			self:ScrollDown()
		end
	end
	self:GetParent().scrollBar:SetValue(self:GetNumMessages() - self:GetCurrentScrollY())
end

local function SearchBarResetAndClear(self)
	if not self then self = Module.Frame.searchingBar end
	self:SetText("");
	self:ClearFocus();
	SearchBoxTemplate_OnEditFocusLost(self)
end

local function CreateSubFrame()
	local p = ODC.Frame
	local f = CreateFrame('Frame',FRAMENAME, p);
	f:SetPoint('TOPLEFT', 0, -40);
	f:SetPoint('BOTTOMRIGHT', 0, 0);
	Module.Frame = f
	f:Hide()

	----Search
	f.searchingBar = CreateFrame('EditBox', '$parentSearchBox', f, "SearchBoxTemplate");
	if ElvUI then
		ODCFrameScrollingMessageSubFrameSearchBox.Left:Hide()
		ODCFrameScrollingMessageSubFrameSearchBox.Middle:Hide()
		ODCFrameScrollingMessageSubFrameSearchBox.Right:Hide()
	end
	f.searchingBar:SetFrameLevel(f:GetFrameLevel() + 2);
	f.searchingBar:SetHeight(15);
	f.searchingBar:SetWidth(180);
	f.searchingBar:SetPoint('TOPLEFT', f, 'TOPLEFT', 12, 0);
	f.searchingBar:SetScript("OnEscapePressed", function(self)
		SearchBarResetAndClear(self)
		OutputLog(f)
	end);
	f.searchingBar:SetScript("OnEnterPressed", function(self)
		-- SearchBarResetAndClear(self)
		OutputLog(f, self:GetText())
	end);
	f.searchingBar:SetScript("OnEditFocusLost", function(self)
		SearchBarResetAndClear(self)
		OutputLog(f)
	end);

	-- f.searchingBar:SetScript("OnTextChanged", function()
		-- UpdateSearch()
	-- end);
	-- f.searchingBar:SetScript('OnChar', function()
		-- UpdateSearch()
	-- end);
	
	----Create stack up button
	f.stackUpCheckButton = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate");
	f.stackUpCheckButton:SetPoint("LEFT",f.searchingBar, 200, 0)
	f.stackUpCheckButton.text:SetText(SHOW_TIMESTAMP)
	f.stackUpCheckButton:SetChecked(true)
	f.stackUpCheckButton:SetScript("OnClick", function(self)
		if self:GetChecked() then
			Module.TIMESTAMP = TIMESTAMP_FORMAT_HHMMSS_24HR
		else
			Module.TIMESTAMP = nil
		end
		OutputLog(f)
	end)
	
	-- f.messageFrame = CreateFrame('EditBox', nil, f);
	f.messageFrame = CreateFrame('ScrollingMessageFrame', nil, f);
	if ElvUI then
		-- f.messageFrame:CreateBackdrop('Default', true);
		f.messageFrame:FontTemplate(nil, 12, 'OUTLINE')
	else
		f.messageFrame:SetFont(STANDARD_TEXT_FONT, 12);
	end
	f.messageFrame:SetFrameLevel(f:GetFrameLevel() + 2);
	-- f.messageFrame:SetMultiLine(true)
	f.messageFrame:SetHyperlinksEnabled(true)
	f.messageFrame:EnableMouseWheel(true)
	f.messageFrame:SetFading(false)
	f.messageFrame:SetMaxLines(2000)
	f.messageFrame:SetJustifyH("LEFT")
	f.messageFrame:SetPoint('TOPLEFT', f, 10, -30);
	f.messageFrame:SetPoint('BOTTOMRIGHT', f, -30, 30);
	f.messageFrame:SetScript("OnMouseWheel", MessageFrameScroll)
	f.messageFrame:SetScript("OnHyperlinkClick", function(self, link, text, button)
		if IsShiftKeyDown() and button == 'LeftButton' then
			if AuctionFrame and AuctionFrame:IsVisible() then
				BrowseName:SetText(GetItemInfo(text))
				return;
			end
			if ChatFrame1EditBox:IsShown() then
				ChatFrame1EditBox:Insert(text);
			else
				local ExistMSG = ChatFrame1EditBox:GetText() or "";
				ChatFrame1EditBox:SetText(ExistMSG..text);
				ChatEdit_SendText(ChatFrame1EditBox);
				ChatFrame1EditBox:SetText("");
				ChatFrame1EditBox:Hide();
			end
		else
			SetItemRef(link, text, button, self);
		end
	end);
	f.messageFrame:SetScript("OnHyperlinkEnter", function(self, linkData, link)
		if string.find(link, "|HBNplayer") or string.find(link, "|Hplayer") then
		
		else
			local x = self:GetRight();
			if ( x >= ( GetScreenWidth() / 2 ) ) then
				GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			else
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			end
			GameTooltip:SetHyperlink(link)
		end
	end);
	f.messageFrame:SetScript("OnHyperlinkLeave", function()
		GameTooltip:Hide()
	end);
	
	----Create scroll frame
	f.scrollBar = CreateFrame("Slider", "$parentScrollBar", f, "UIPanelScrollBarTemplate")--"FauxScrollFrameTemplate")
	f.scrollBar:SetPoint("TOPRIGHT", -10, -50)
	f.scrollBar:SetPoint("BOTTOMRIGHT", -28, 45)
	f.scrollBar:SetValueStep(1)
	f.scrollBar:SetScript("OnValueChanged", function(self, value)
		f.messageFrame:SetScrollOffset(select(2, self:GetMinMaxValues()) - value)
	end)
	
	if ElvUI then
		local S = ElvUI[1]:GetModule("Skins")
		if S then
			S:HandleEditBox(f.searchingBar)
			S:HandleCheckBox(f.stackUpCheckButton);
			f.stackUpCheckButton:Size(20)
			-- S:HandleEditBox(f.messageFrame)
			S:HandleScrollBar(f.scrollBar)
		end
	end
	-- EditBox:HighlightText([start [, end]])
end

function Module:CreateOrShowSubFrame(tabName, postOutputFunc)
	if not Module.Frame then
		CreateSubFrame()
	end
	OutputFunc = postOutputFunc
	ODC:ShowSubFrame(tabName, Module.Frame)
	OutputLog(Module.Frame)
end

function Module:OnEnable()
	ODC:AddModule(self)
end

function Module:OnDisable()
	ODC:RemoveModule(self)
end