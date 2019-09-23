local ODC = LibStub("AceAddon-3.0"):NewAddon("OfflineDataCenter", "AceHook-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("OfflineDataCenter")
--local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local icon = LibStub("LibDBIcon-1.0", true)
--local dataobj = ldb:NewDataObject("OfflineDataCenter", {label = L["Offline Data Center"], type = "data source", icon = "Interface\\Buttons\\Button-Backpack-Up", text = "n/a"})
--dataobj.text = L["Offline Data Center"]

local getn, tinsert = table.getn, table.insert
local floor = math.floor
local len, sub, find, format, match = string.len, string.sub, string.find, string.format, string.match
ODC.version = 50
ODC.versionstate = "release"
ODC.playername = GetUnitName("player")..'-'..GetRealmName()
ODC.selectChar = ODC.playername
ODC.selectTab = nil

--[[
ODC.tabs = { [tabName] = ...}
[tabName] = { Textures, Tooltip, subFrame, CallTabFunc, CharChangedFunc }
]]
ODC.TabChangedCallback = {}
ODC.CharChangedCallback = {}
ODC.Tabs = {}
ODC.TabsAvaliable = {}

ODC.config_const = {
	frameWidth = 360,
	frameHeight = 540,
}

local function SetSelectedTab()
	for k, v in pairs(ODC.TabChangedCallback) do
		ODC.TabChangedCallback[k](ODC.selectTab)
	end
end

local function SetSelectedChar()
	for k, v in pairs(ODC.CharChangedCallback) do
		ODC.CharChangedCallback[k](ODC.selectChar)
	end
end

local function ChooseChar_OnClick(self)
	ODC.selectChar = self.value
	SetSelectedChar()

	UIDropDownMenu_SetSelectedValue(ODC.Frame.chooseChar, self.value);
	if not ODC.selectTab then return end
	ODC.Tabs[ODC.selectTab].CharChangedFunc()
	
	OfflineDataCenterFrameChooseCharDropDownText:SetWidth(140)
end

local function ChooseCharMenuInitialize(self, level)
	local info = UIDropDownMenu_CreateInfo();
	for k, v in pairs(ODC_DB) do
		if type(k) == 'string' and type(v) == 'table' then
			local info = UIDropDownMenu_CreateInfo()
			info.text = k
			info.value = k
			info.func = function(self)
				ChooseChar_OnClick(self)
			end;
			UIDropDownMenu_AddButton(info, level)
		end
	end
	UIDropDownMenu_SetSelectedValue(ODC.Frame.chooseChar, ODC.selectChar);
	OfflineDataCenterFrameChooseCharDropDownText:SetWidth(140)
end

function ODC:ShowSubFrame(tabName, subFrame)
	local thisFrame = self.Tabs[tabName].subFrame

	if not thisFrame then
		self.Tabs[tabName].subFrame = subFrame
		thisFrame = subFrame
	end

	for k, tab in pairs(self.Tabs) do
		local frame = tab.subFrame
		if frame ~= nil then
			if ( frame ~= thisFrame ) then
				frame:Hide();
			else
				frame:Show();
			end
		end
	end 
end

---- GUI ----

function ODC:SetActiveTab(tabName, showFrame)
	self.selectTab = tabName
	ODC_Config.UI.activePage = tabName
	if not tabName then return end
	SetSelectedTab()
	-- if not ODC_Config.toggle[tabName] then
		-- print(ODC.Tabs[tabName].Tooltip..'is not Enabled')
		-- return;
	-- end

	for k, v in pairs(ODC.Tabs) do
		if k == tabName then
			_G["OfflineDataCenterFrame"..k..'Tab']:SetChecked(true)
		elseif v then
			_G["OfflineDataCenterFrame"..k..'Tab']:SetChecked(false)
		end
	end
	if showFrame then self:FrameShow() end
	
	self.Tabs[tabName].CallTabFunc()

end
	
local function CreateODCFrame()
	----Create ODC frame
	local name = "OfflineDataCenterFrame"
	local f = CreateFrame("Frame", name , UIParent)
	ODC.Frame = f
	if ODC_Config.UI == nil then ODC_Config.UI = {} end
	
	if ElvUI then
		f:SetTemplate(ElvUI[1].db.bags.transparent and "notrans" or "Transparent")
	else
		f:SetBackdrop({
			bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
			edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
			tile = true, tileSize = 16, edgeSize = 16,
			insets = { left = 1, right = 1, top = 1, bottom = 1 }
		})
	end
	f:EnableMouse(true)
	f:SetFrameStrata("DIALOG");
	f:SetClampedToScreen(true)
	f:SetWidth(ODC.config_const.frameWidth)
	f:SetHeight(ODC.config_const.frameHeight)
	f:SetPoint(ODC_Config.UI.pa or "CENTER", ODC_Config.UI.px or 0, ODC_Config.UI.py or 0)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		ODC_Config.UI.p, ODC_Config.UI.pf, ODC_Config.UI.pa, ODC_Config.UI.px, ODC_Config.UI.py = self:GetPoint()
	end)
	f:SetFrameLevel(f:GetFrameLevel() + 100);
	f:Hide()
	
	----Create title
	f.title = f:CreateFontString(nil, 'OVERLAY');
	if ElvUI then
		f.title:FontTemplate(nil, 14, 'OUTLINE')
	else
		f.title:SetFont(STANDARD_TEXT_FONT, 14);
	end
	f.title:SetPoint("TOPLEFT", 10, -10);
	f.title:SetText(L["Offline Data Center"])
	
	----Create choose char dropdown menu
	f.chooseChar = CreateFrame('Frame', name..'ChooseCharDropDown', f, 'UIDropDownMenuTemplate')
	f.chooseChar:SetPoint("LEFT", f.title, f.title:GetStringWidth(), -5)
	UIDropDownMenu_Initialize(f.chooseChar, ChooseCharMenuInitialize)
	--UIDropDownMenu_SetWidth(OfflineDataCenterFrameChooseCharDropDown, 200);

	----Create close button
	f.closeButton = CreateFrame("Button", nil, f, "UIPanelCloseButton");
	f.closeButton:SetPoint("TOPRIGHT", -2, -2);
	f.closeButton:HookScript("OnClick", function()
		if not InCombatLockdown() then
			collectgarbage("collect")
		end
	end)

	if ElvUI then
		local S = ElvUI[1]:GetModule("Skins")
		if S then
			S:HandleCloseButton(f.closeButton);
			S:HandleDropDownBox(f.chooseChar, 200)
		end
	end
end

local function CreateTab(f, tabName)
	local texture = ODC.Tabs[tabName].Textures
	local tab = CreateFrame("CheckButton", f:GetName()..tabName..'Tab', f, "SpellBookSkillLineTabTemplate SecureActionButtonTemplate")
	tab:ClearAllPoints()
	if ElvUI then
		tab:DisableDrawLayer("BACKGROUND")
		tab:SetNormalTexture(texture)
		tab:GetNormalTexture():ClearAllPoints()
		tab:GetNormalTexture():Point("TOPLEFT", 2, -2)
		tab:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
		tab:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)

		tab:CreateBackdrop("Default")
		tab.backdrop:SetAllPoints()
		tab:StyleButton()
	else
		tab:SetNormalTexture(texture)
	end	
	tab:SetAttribute("type", "spell")
	tab:SetAttribute("spell", f:GetName())
	tab.tabName = tabName
	tab:SetScript("OnClick", function(self)
		ODC:SetActiveTab(self.tabName)
	end)
	tab.tooltip = ODC.Tabs[tabName].Tooltip
	return tab
end

local function CreateFrameTab(f)
	--tab button
	if not f then return end
	if f.tabButton then
		for tabName, tab in pairs(f.tabButton) do
			tab:Hide()
			tab:ClearAllPoints()
			tab.enable = false
		end
	else
		f.tabButton = {}
	end
	
	for tabName, v in pairs(ODC.Tabs) do
		if not f.tabButton[tabName] then
			f.tabButton[tabName] = CreateTab(f, tabName)
		end
		f.tabButton[tabName].enable = true
	end
	
	local num = 0
	for tabName, tab in pairs(f.tabButton) do
		if tab.enable then
			num = num + 1
		end
	end
		
	local tabIndex = 1
	for tabName, tab in pairs(f.tabButton) do
		if tab.enable then
			local tabindex = 0
			if tabName == 'settings' then
				tabindex = num
			else
				tabindex = tabIndex
				tabIndex = tabIndex + 1
			end
			if ElvUI then
				tab:SetPoint("TOPLEFT", f, "TOPRIGHT", 2, (-44 * tabindex) + 34)
			else
				tab:SetPoint("TOPLEFT", f, "TOPRIGHT", 0, (-48 * tabindex) + 18)
			end	

			tab:Show()
		end
	end
end

function ODC:CreatePopupFrame()
	self.PopupFrame = CreateFrame("Frame", nil , UIParent)
	local f = self.PopupFrame

	if ElvUI then
		f:SetTemplate(ElvUI[1].db.bags.transparent and "notrans" or "Transparent")
	else
		f:SetBackdrop({
			bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
			edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
			tile = true, tileSize = 16, edgeSize = 16,
			insets = { left = 1, right = 1, top = 1, bottom = 1 }
		})
	end
	f:EnableMouse(true)
	f:SetFrameStrata("DIALOG");
	f:SetWidth(333)
	f:SetHeight(200)
	f:SetPoint("CENTER", 0, 0)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)
	f:Hide()
	
	f.accept = CreateFrame("Button", nil, f, "UIPanelButtonTemplate");
	f.accept:SetWidth(100)
	f.accept:SetHeight(30)
	f.accept:SetPoint("BOTTOMLEFT", 10, 5);
	f.accept:SetText(ACCEPT)
	
	f.cancle = CreateFrame("Button", nil, f, "UIPanelButtonTemplate");
	f.cancle:SetWidth(100)
	f.cancle:SetHeight(30)
	f.cancle:SetPoint("BOTTOMRIGHT", -10, -5);
	f.cancle:SetText(CANCEL)
end



local OfflineDataCenterPopMenu = {}

local function AddPopMenu(tabName, tabTooltip)
	local t = {text = tabTooltip,
		func = function() PlaySound(850); ODC:SetActiveTab(tabName, true) end,}
	tinsert(OfflineDataCenterPopMenu, t)
end

local function RemovePopMenu(tabTooltip)
	for i, t in pairs(OfflineDataCenterPopMenu) do
		if t.text == tabTooltip then
			t = nil
		end
	end
end

local function DropDown(list, frame, xOffset, yOffset)
	if not frame.buttons then
		frame.buttons = {}
		frame:SetFrameStrata("TOOLTIP")
		frame:SetClampedToScreen(true)
		tinsert(UISpecialFrames, frame:GetName())
		frame:Hide()
	end

	xOffset = xOffset or 0
	yOffset = yOffset or 0

	for i=1, #frame.buttons do
		frame.buttons[i]:Hide()
	end

	for i=1, #list do 
		if not frame.buttons[i] then
			frame.buttons[i] = CreateFrame("Button", nil, frame)
			
			frame.buttons[i].hoverTex = frame.buttons[i]:CreateTexture(nil, 'OVERLAY')
			frame.buttons[i].hoverTex:SetAllPoints()
			frame.buttons[i].hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
			frame.buttons[i].hoverTex:SetBlendMode("ADD")
			frame.buttons[i].hoverTex:Hide()

			frame.buttons[i].text = frame.buttons[i]:CreateFontString(nil, 'BORDER')
			frame.buttons[i].text:SetAllPoints()
			frame.buttons[i].text:SetFont(STANDARD_TEXT_FONT, 14, 'OUTLINE')
			frame.buttons[i].text:SetJustifyH("LEFT")

			frame.buttons[i]:SetScript("OnEnter", function(btn)
				btn.hoverTex:Show()
			end)
			frame.buttons[i]:SetScript("OnLeave", function(btn)
				btn.hoverTex:Hide()
			end)
		end

		frame.buttons[i]:Show()
		frame.buttons[i]:SetHeight(16)
		frame.buttons[i]:SetWidth(135)
		frame.buttons[i].text:SetText(list[i].text)
		frame.buttons[i].func = list[i].func
		frame.buttons[i]:SetScript("OnClick", function(btn)
			btn.func()
			btn:GetParent():Hide()
		end)

		if i == 1 then
			frame.buttons[i]:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
		else
			frame.buttons[i]:SetPoint("TOPLEFT", frame.buttons[i-1], "BOTTOMLEFT")
		end
	end

	frame:SetHeight((#list * 16) + 10 * 2)
	frame:SetWidth(135 + 10 * 2)

	local UIScale = UIParent:GetScale();
	local x, y = GetCursorPosition();
	x = x/UIScale
	y = y/UIScale
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x + xOffset, y + yOffset)
	
	ToggleFrame(frame)
end

local menuFrame = CreateFrame("Frame", "OfflineDataCenterClickMenu", UIParent)
menuFrame:SetBackdrop({
	bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
	edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 11, right = 12, top = 12, bottom = 11 }
})

local function CreateElvUIBagToggleButton(parent)
	local f = CreateFrame('Button', nil, parent)
	f:Height(20)
	f:Width(20)
	f:SetFrameLevel(f:GetFrameLevel() + 2)
	f:SetTemplate('Default')
	f:StyleButton()
	f:SetNormalTexture("INTERFACE\\CHARACTERFRAME\\TempPortrait.blp")
	
	f:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	f:GetNormalTexture():SetInside()
	f:CreateBackdrop("Default")
	f.backdrop:SetAllPoints()
	f:SetScript("OnClick", function()
		ODC:ToggleWindow()
	end)
	f:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self:GetParent(), "ANCHOR_TOP", 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["Offline Data Center"])
		if self.backdropTexture then
			self:SetBackdropBorderColor(unpack(ElvUI[1].media.rgbvaluecolor))
		end		
		GameTooltip:Show()
	end)
	f:SetScript("OnLeave", function(self)
		if self.backdropTexture then
			self:SetBackdropBorderColor(unpack(ElvUI[1].media.bordercolor))
		end		
		GameTooltip:Hide()
	end)

	return f
end

local NotiCombatLockdown = false
local function CreateToggleButton(f)
	if not f then return; end
	if InCombatLockdown() and not NotiCombatLockdown then
		print(L["Offline Data Center toggle button can not be created in Combating, please leave the combat before retry!"]);
		NotiCombatLockdown = true
		return;
	end
	
	if f:GetName() == 'ContainerFrame1' then-- and not ContainerFrame1PortraitButton.dropdownmenu
		ContainerFrame1PortraitButton:RegisterForClicks('AnyUp', 'AnyDown')
		ContainerFrame1PortraitButton:EnableMouse(true)
		ContainerFrame1PortraitButton:SetScript("OnClick", function(self)
			DropDown(OfflineDataCenterPopMenu, menuFrame)
		end)
		ContainerFrame1PortraitButton:HookScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:AddLine(L['Offline Frame'])
			GameTooltip:AddLine(BACKPACK_TOOLTIP, 1.0, 1.0, 1.0);
			if (GetBindingKey("TOGGLEBACKPACK")) then
				GameTooltip:AddLine(" "..NORMAL_FONT_COLOR_CODE.."("..GetBindingKey("TOGGLEBACKPACK")..")"..FONT_COLOR_CODE_CLOSE)
			end
			GameTooltip:SetClampedToScreen(true)
			GameTooltip:Show()
		end)		
		ContainerFrame1PortraitButton.dropdownmenu = true
		return ContainerFrame1PortraitButton
	end

	if f:GetName() == "ElvUI_ContainerFrame" then --ElvUI and not f.offlineButton
		--offline button
		if not f.offlineButton then
			f.offlineButton = CreateElvUIBagToggleButton(f)
			f.offlineButton:Point('TOPLEFT', f, 'TOPLEFT', 8, -8)
		end
	end
	
	return f
end

function ODC:AddModule(module)
	self.TabChangedCallback[module.name] = module.selectTabCallbackFunc
	self.CharChangedCallback[module.name] = module.selectCharCallbackFunc
end

function ODC:RemoveModule(module)
	self.TabChangedCallback[module.name] = nil
	self.CharChangedCallback[module.name] = nil
end

function ODC:AddTab(tabName, tab)
	self.Tabs[tabName] = tab
	AddPopMenu(tabName, tab.Tooltip)
	CreateFrameTab(self.Frame)
	self:OpenBags()
end

function ODC:RemoveTab(tabName)
	if not self.Tabs[tabName] then return end
	RemovePopMenu(self.Tabs[tabName].Tooltip)
	if self.selectTab == tabName then
		self:SetActiveTab()
		self.Tabs[tabName].subFrame:Hide();
	end
	self.Tabs[tabName] = nil
	CreateFrameTab(self.Frame)
	self:OpenBags()
end

function ODC:AddAvaliableTab(tabName, module)
	self.TabsAvaliable[tabName] = {}
	self.TabsAvaliable[tabName].module = module
	self.TabsAvaliable[tabName].locale = module.tabs[tabName].Tooltip
end

function ODC:FrameShow()
	self.Frame:Show()
end

function ODC:FrameHide()
	self.Frame:Hide()
	ODC_Config.UI.activePage = self.selectTab
	if not InCombatLockdown() then
		collectgarbage("collect")
	end
end

function ODC:ToggleWindow()
	if self.Frame:IsVisible() then
		self:FrameHide()
	else
		if ODC_Config.UI.activePage and ODC_Config.toggle[ODC_Config.UI.activePage] then
			ODC:SetActiveTab(ODC_Config.UI.activePage, true)
		else
			for tabName, v in pairs(ODC.Tabs) do
				if ODC_Config.toggle[tabName] then
					ODC:SetActiveTab(tabName, true)
					return;
				end
			end
			ODC:SetActiveTab("settings", true)
		end
	end
end

local function PrintCmdHelper()
	print(L["COMMANDHELPER"])
end

function ODC:PrintTabState()
	for name, module in self:IterateModules() do
		if module.tabs then
			for tabName, _ in pairs(module.tabs) do
				if ODC_Config.toggle[tabName] == nil then
				
				elseif ODC_Config.toggle[tabName] then
					print(module.tabs[tabName].Tooltip.." [ "..tabName.." ] "..L[" is |cff33ff33enabled|r"])
				else
					print(module.tabs[tabName].Tooltip.." [ "..tabName.." ] "..L[" is |cffff3333disabled|r"])
				end
			end
		end
	end
end

function ODC:EnableTab(tabName)
	if not tabName then
		PrintCmdHelper()
	elseif ODC_Config.toggle[tabName] == nil then
		print(L["Tab name does not exist!"])
		self:PrintTabState()
	else
		ODC_Config.toggle[tabName] = true
		self.TabsAvaliable[tabName].module:OnEnable()
	end
end

function ODC:DisableTab(tabName)
	if not tabName then
		PrintCmdHelper()
	elseif ODC_Config.toggle[tabName] == nil then
		print(L["Tab name does not exist!"])
		self:PrintTabState()
	else
		ODC_Config.toggle[tabName] = false
		self.TabsAvaliable[tabName].module:OnDisable()
	end
end

local function ClearTable(ori_tab)
	if (type(ori_tab) ~= "table") then
		return;
    end
	for i,v in pairs(ori_tab) do
		local vtyp = type(v);
		if (vtyp == "table") then
			ClearTable(v);
			ori_tab[i] = nil;
		else
			ori_tab[i] = nil;
		end
	end
	ori_tab = nil;
end

StaticPopupDialogs["ODC_ACCEPT_WIPE_ALL_VER"] = {
    text = L["Because the upgrade versions of all ADDON need to be reset ODC data, click OK to reload UI!"],
    button1 = ACCEPT,
    OnAccept = function(self)
        ODC_DB, ODC_Config,  MB_DB, BB_DB, IN_DB, MB_Config = nil
		ODC_Config = {UI = {},toggle = {},DBver = ODC.version, icon = {hide = false, radius = 80, minimapPos = 195}, Options = {}}
		ReloadUI();
    end,
    OnShow = function(self)
        
    end,
    timeout = 0,
    hideOnEscape = 1
};	

StaticPopupDialogs["ODC_ACCEPT_WIPE_ALL"] = {
    text = L["Do you want to wipe ALL offline data?"],
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept = function(self)
        ODC:FrameHide()
		ODC:SetActiveTab()
		for playerName, t in pairs(ODC_DB) do
			if t then
				print(playerName..L["'s data wiped."])
				ClearTable(t)
			end
			if ODC.playername ~= playerName then
				ODC_DB[playerName] = nil
			end
		end
		UIDropDownMenu_Initialize(ODC.Frame.chooseChar, ChooseCharMenuInitialize)
		print(L["All data wiped!"]);
		if icon then
			icon:Refresh("OfflineDataCenter", ODC_Config.icon)
			if ODC_Config.icon.hide then
				icon:Hide("OfflineDataCenter")
			else
				icon:Show("OfflineDataCenter")
			end
		end		
    end,
    OnShow = function(self)
        
    end,
    timeout = 0,
    hideOnEscape = 1
};

function ODC:WipeData(arg1, arg2)
	if arg1 == "all" then
		StaticPopup_Show("ODC_ACCEPT_WIPE_ALL")
	elseif arg1 == "disabled" then
		for tabName, enable in pairs(ODC_Config.toggle) do
			if not enable then
				for playerName, t in pairs(ODC_DB) do
					if t[tabName] then
						ClearTable(t[tabName])
					end
				end
			end
		end
		print(L["Disabled data wiped!"])
	elseif arg1 == "character" and arg2 then
		wipe(ODC_DB[arg2])
		print(arg2..L["'s data wiped."])
		if ODC.playername ~= arg2 then
			ODC_DB[arg2] = nil
		end
	else
		PrintCmdHelper()
	end
end

function ODC:SlashCmdHandler(param)
	param = string.lower(param)
	local _, _, arg1, arg2 = string.find(param, "(%a+)%s*(%a*)")
	if arg1 == "toggle" or arg1 == "t" then
		self:ToggleWindow()
	elseif arg1 == "enable" or arg1 == "en" then
		self:EnableTab(arg2)
	elseif arg1 == "disable" or arg1 == "dis" then
		self:DisableTab(arg2)
	elseif arg1 == "state" or arg1 == "s"  then
		self:PrintTabState()
	elseif arg1 == "wipe" then
		self:WipeData(arg2)
	elseif arg1 == "icon" then
		self:ChangeIcon()
	else
		PrintCmdHelper()
	end
end

function ODC:OpenBags()
	CreateToggleButton(ElvUI_ContainerFrame)
	CreateToggleButton(ContainerFrame1)
	
	if ElvUI and ElvUI_ContainerFrame and ElvUI_ContainerFrame.offlineButton then
		if not ElvUI_ContainerFrame.offlineButton.img1 then
			ElvUI_ContainerFrame.offlineButton.img1 = ElvUI_ContainerFrame.offlineButton:CreateTexture(nil, "BACKGROUND")
			ElvUI_ContainerFrame.offlineButton.img1:SetHeight(32)
			ElvUI_ContainerFrame.offlineButton.img1:SetWidth(32)
			ElvUI_ContainerFrame.offlineButton.img1:SetInside()
		end
		SetPortraitTexture(ElvUI_ContainerFrame.offlineButton.img1, "player")

		ElvUI_ContainerFrame.offlineButton.img1:SetTexCoord(0.2, 0.8, 0.0666, 0.9);
		ElvUI_ContainerFrame.offlineButton.img1:SetAlpha(1);		
		ElvUI_ContainerFrame.offlineButton:SetNormalTexture(ElvUI_ContainerFrame.offlineButton.img1)
	end		
end

---- for itemlink process ----
function ODC:ClearUniqueString(link)
--	local _, _, unique = string.find(link, "|?c?f?f?%x*|?H?[^:]*:?%d+:?%d*:?%d*:?%d*:?%d*:?%d*:?%-?%d*:?(%-?%d*):?%d*:?%d*:?%d*|?h?%[?[^%[%]c]*%]?|?h?|?r?")
--	if unique~= 0 then
--		link = string.gsub(link ,unique ,0 )
--	end
	return link
end

function ODC:MergeItem(link, count)
-- local i, j, color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Reforge, Upgrade, Name = string.find(itemlink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%d*)|?h?%[?([^%[%]c]*)%]?|?h?|?r?");
--	local _, _, unique = string.find(link, "|?c?f?f?%x*|?H?[^:]*:?%d+:?%d*:?%d*:?%d*:?%d*:?%d*:?%-?%d*:?(%-?%d*):?%d*:?%d*:?%d*|?h?%[?[^%[%]c]*%]?|?h?|?r?")
--	if unique~= 0 then
--		link = string.gsub(link ,unique ,0 )
--	end
	return count.."@"..link
end

function ODC:GetItemCount(str)
	local _, _, count = string.find(str, "(%d+)@.*")
	return count
end

function ODC:GetItemLink(str)
	local _, _, link = string.find(str, "%d+@(.*)")
	return link
end

function ODC:SplitItem(str)
	local _, _, count, link = string.find(str, "(%d+)@(.*)")
	return link, count
end

local function CopyTable(ori_tab)
    if (type(ori_tab) ~= "table") then
        return nil;
    end
    local new_tab = {};
    for i,v in pairs(ori_tab) do
        local vtyp = type(v);
        if (vtyp == "table") then
            new_tab[i] = CopyTable(v);
        else
            new_tab[i] = v;
        end
    end
    return new_tab;
end

---- Config ---
function ODC:SetDefaultConfig(tabs) --self.tabs
	for tabname, tab in pairs(tabs) do
		if tab.DefaultConfig then
			if not ODC_Config.Options[tabname] then ODC_Config.Options[tabname] = {} end
			for key, value in pairs(tab.DefaultConfig) do
				if ODC_Config.Options[tabname][key] == nil then ODC_Config.Options[tabname][key] = value end
			end
		end
	end
end

--[[
MB_DB structure:
				mailIndex		attachIndex
[charName] = {	[1]				[1]			{	.count
				[n]				.sender			.itemLink
				/.mailCount		.daysLeft
				/.itemCount		.wasReturned
				.checkMailTick	.CODAmount?
								.money?
BB_DB structure:
				bagID		slotID
[charName] = {	[1]			[1]			{	.count
				[n]			/.slotMAX		.itemLink

IN_DB structure:
							INVSLOT
[charName] = {	[1]		{	[1]			{	.count
							[2]				.itemLink
]]

--Data Broker begin --
-- function dataobj:OnEnter()
	-- GameTooltip:SetOwner(self, "ANCHOR_NONE")
	-- GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
	-- GameTooltip:ClearLines()
	-- GameTooltip:AddLine(L["Offline Data Center"])
	-- GameTooltip:Show()
-- end

-- function dataobj:OnLeave()
	-- GameTooltip:Hide()
-- end

-- function dataobj:OnClick(button)
	-- ODC:ToggleWindow()
-- end
--Data Broker end--

function ODC:ChangeIcon()
	ODC_Config.icon.hide = not ODC_Config.icon.hide
	
	if icon then
		icon:Refresh("OfflineDataCenter", ODC_Config.icon)
		if ODC_Config.icon.hide then
			icon:Hide("OfflineDataCenter")
		else
			icon:Show("OfflineDataCenter")
		end
	end
end

function ODC:OnInitialize()
	if ODC_Config == nil then ODC_Config = {UI = {},toggle = {},DBver = ODC.version, icon = {hide = false, radius = 80, minimapPos = 195}, Options = {}} end
	if ODC_DB == nil then ODC_DB = {} end
	if ODC_DB[ODC.playername] == nil then ODC_DB[ODC.playername] = {} end
	if not ODC_Config.DBver or ODC_Config.DBver ~= ODC.version then StaticPopup_Show("ODC_ACCEPT_WIPE_ALL_VER") end
	self.selectTab = ODC_Config.UI.activePage or nil

	CreateODCFrame()
	
	self:SecureHook('OpenAllBags', 'OpenBags')
	self:SecureHook('ToggleBag', 'OpenBags')
	---- Slash command ----
	
	-- if not ODC_Config.icon then ODC_Config.icon = {hide = false, radius = 80, minimapPos = 195}; end
	-- Minimap button.
--	if icon and not icon:IsRegistered("OfflineDataCenter") then
--		icon:Register("OfflineDataCenter", dataobj, ODC_Config.icon)
--	end	
	
	SLASH_OFFLINEDATACENTER1 = "/odc";
	SlashCmdList["OFFLINEDATACENTER"] = function(param)
		ODC:SlashCmdHandler(param)
	end;
end